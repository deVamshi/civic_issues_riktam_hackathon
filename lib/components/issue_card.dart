import 'package:cached_network_image/cached_network_image.dart';
import 'package:civic_issues_riktam_hackathon/models/issue_model.dart';
import 'package:civic_issues_riktam_hackathon/untils.dart';
import 'package:civic_issues_riktam_hackathon/views/login_view.dart';
import 'package:civic_issues_riktam_hackathon/views/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IssueCard extends StatelessWidget {
  IssueCard({super.key, required this.curIssue});

  final imgURL =
      "https://images.unsplash.com/photo-1560802053-615279b5f7d9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHNld2FnZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60";

  bool isEditable = false;

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
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        curIssue.images?.first ?? imgURL),
                  ),
                ),
              ),
            ),
            vspace(10),
            Text(curIssue.title ?? "Issue"),
            vspace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        size: 20,
                      ),
                      label: Text("${curIssue.upvotes}"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.to(Messages());
                      },
                      icon: Icon(
                        Icons.message,
                        size: 20,
                      ),
                      label: Text(
                        "Chat",
                      ),
                    ),
                    Visibility(
                      visible: isEditable,
                      child: OutlinedButton.icon(
                        onPressed: () async {},
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        label: Text(
                          "Edit",
                        ),
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
