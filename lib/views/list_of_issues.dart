import 'package:civic_issues_riktam_hackathon/controllers/app_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/state_manager.dart';

import '../components/issue_card.dart';
import '../models/issue_model.dart';

class ListOfIssues extends StatelessWidget {
  ListOfIssues({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppStateController>(
      builder: (ctrl) {
        return ListView.builder(
          itemCount: ctrl.fetchedIssues.length,
          itemBuilder: (item, ind) => IssueCard(
            curIssue: ctrl.fetchedIssues[ind],
          ),
        );
      },
    );
  }
}
