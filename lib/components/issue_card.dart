import 'package:cached_network_image/cached_network_image.dart';
import 'package:civic_issues_riktam_hackathon/views/login_view.dart';
import 'package:civic_issues_riktam_hackathon/views/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IssueCard extends StatelessWidget {
  const IssueCard({super.key});

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
                      "https://images.unsplash.com/photo-1604357209793-fca5dca89f97?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFwfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite,
                        size: 20,
                      ),
                      label: Text("234"),
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
                    OutlinedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Get.offAll(LoginScreen());
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      label: Text(
                        "Edit",
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
