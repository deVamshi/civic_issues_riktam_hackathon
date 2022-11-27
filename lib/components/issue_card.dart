import 'package:cached_network_image/cached_network_image.dart';
import 'package:civic_issues_riktam_hackathon/models/issue_model.dart';
import 'package:civic_issues_riktam_hackathon/untils.dart';
import 'package:civic_issues_riktam_hackathon/views/edit_issue_view.dart';
import 'package:civic_issues_riktam_hackathon/views/comments_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'like_btn.dart';

class IssueCard extends StatelessWidget {
  IssueCard({super.key, required this.curIssue, this.isEditable = false});

  bool isEditable = false;

  void openBottomSheet() {
    Widget tile(String title, IconData iconData) {
      return ListTile(
        onTap: () {
          Get.back(result: title);
        },
        title: Text(title),
        leading: Icon(
          iconData,
          color: badgeColor[title],
        ),
      );
    }

    Get.bottomSheet(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Update Issue Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          tile("OPEN", Icons.check_box_outline_blank_rounded),
          tile("RESOLVED", Icons.check_box_rounded),
          tile("SUBMITTED TO NEWSPAPER", Icons.newspaper_rounded),
          tile("NO ACTION TAKEN", Icons.error_outline),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Issue curIssue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(minHeight: 400),
      height: 50,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      curIssue.images?.first ?? imgURL,
                    ),
                  ),
                ),
              ),
            ),
            vspace(10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    curIssue.title ?? "Issue",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      openBottomSheet();
                    },
                    child: Chip(
                      label: Text(
                        "${curIssue.status}",
                      ),
                      backgroundColor: badgeColor["${curIssue.status}"],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Text(
                curIssue.desc ?? "Desc",
                textAlign: TextAlign.start,
              ),
            ),
            vspace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    LikeButton(iss: curIssue),
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.to(CommentsView(
                          iss: curIssue,
                        ));
                      },
                      icon: const Icon(
                        Icons.message,
                        size: 20,
                      ),
                      label: const Text("Chat"),
                    ),
                    Visibility(
                      visible: isEditable,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Get.to(EditIssue(issue: curIssue));
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        label: const Text("Edit"),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
