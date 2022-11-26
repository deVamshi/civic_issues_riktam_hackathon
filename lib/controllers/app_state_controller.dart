import 'package:civic_issues_riktam_hackathon/services/app_db_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/state_manager.dart';

import '../models/issue_model.dart';

class AppStateController extends GetxController {
  int currIndex = 0;
  int currOffset = 0;

  List<Issue> fetchedIssues = [];

  void fetchIssues() async {
    EasyLoading.show(status: "Fetching Issues");
    fetchedIssues = await AppDBService().getAllIssues(currOffset);
    EasyLoading.dismiss();
    update();
  }

  @override
  void onInit() {
    fetchIssues();
    super.onInit();
  }

  void updateIndex(int i) {
    currIndex = i;
    update();
  }
}
