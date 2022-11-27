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

Widget emptyListWidget() {
  return Center(
    child: Lottie.asset('assets/lottie/empty.json'),
  );
}

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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppStateController>(
      builder: (ctrl) {
        if (widget.onlyOwner) {
          return OwnIssuesWidget(allIssues: ctrl.fetchedIssues);
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

class OwnIssuesWidget extends StatefulWidget {
  OwnIssuesWidget({super.key, required this.allIssues});
  List<Issue> allIssues;

  @override
  State<OwnIssuesWidget> createState() => _OwnIssuesWidgetState();
}

class _OwnIssuesWidgetState extends State<OwnIssuesWidget> {
  List<Issue> allIssues = [];

  List<Issue> ownIssues = [];
  String currId = FirebaseAuth.instance.currentUser?.email ?? "*";

  @override
  void initState() {
    print("CURR ID");
    print(currId);
    allIssues = widget.allIssues;
    filterOutOwnIssues();
    super.initState();
  }

  void filterOutOwnIssues() {
    ownIssues = [];
    print("ALLL ISSUESSS IN OWN ISSUS S");
    print(allIssues);
    for (var iss in allIssues) {
      debugPrint("${iss.email} --- $currId");
      if (iss.email == currId) {
        ownIssues.add(iss);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ownIssues.isNotEmpty
        ? ListView.builder(
            itemCount: ownIssues.length,
            itemBuilder: (item, ind) {
              Issue iss = ownIssues[ind];
              return IssueCard(
                curIssue: iss,
                isEditable: true,
              );
            })
        : emptyListWidget();
  }
}
