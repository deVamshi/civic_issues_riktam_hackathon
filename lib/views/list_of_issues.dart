import 'package:civic_issues_riktam_hackathon/controllers/app_state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:lottie/lottie.dart';

import '../components/issue_card.dart';
import '../models/issue_model.dart';

class ListOfIssues extends StatefulWidget {
  ListOfIssues({super.key, this.onlyOwner = false});

  bool onlyOwner;

  @override
  State<ListOfIssues> createState() => _ListOfIssuesState();
}

class _ListOfIssuesState extends State<ListOfIssues> {
  final appStateCtrl = Get.find<AppStateController>();

  @override
  void initState() {
    // if (widget.onlyOwner) {
    //   appStateCtrl.fetchOwnIssues();
    // } else {
    //   appStateCtrl.fetchIssues(onlyOwner: false);
    // }
    super.initState();
  }

  Widget emptyListWidget() {
    return Center(
      child: Lottie.asset('assets/lottie/empty.json'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppStateController>(
      builder: (ctrl) {
        if (widget.onlyOwner) {
          return FutureBuilder(
              future: ctrl.fetchOwnIssues(),
              builder: (ctxt, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ctrl.own.isNotEmpty
                    ? ListView.builder(
                        itemCount: ctrl.own.length,
                        itemBuilder: (item, ind) {
                          Issue iss = ctrl.own[ind];
                          return IssueCard(
                            curIssue: iss,
                            isEditable: widget.onlyOwner,
                          );
                        })
                    : emptyListWidget();
              });
        } else {
          List<Issue> allIss = ctrl.fetchedIssues;
          print("All Issues");
          print(allIss);
          allIss.sort((a, b) =>
              DateTime.parse(a.time).isAfter(DateTime.parse(b.time)) ? 0 : 1);

          return allIss.isNotEmpty
              ? ListView.builder(
                  itemCount: allIss.length,
                  itemBuilder: (item, ind) {
                    Issue iss = allIss[ind];

                    return IssueCard(
                      curIssue: iss,
                      isEditable: widget.onlyOwner,
                    );
                  })
              : emptyListWidget();
        }
      },
    );
  }
}
