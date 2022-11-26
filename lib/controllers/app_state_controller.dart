import 'package:civic_issues_riktam_hackathon/main.dart';
import 'package:civic_issues_riktam_hackathon/services/app_db_service.dart';
import 'package:civic_issues_riktam_hackathon/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/issue_model.dart';

class AppStateController extends GetxController {
  int currIndex = 0;
  int currOffset = 0;

  List<Issue> fetchedIssues = [];
  List<Issue> own = [];

  void fetchOwnIssues() {
    fetchIssues(onlyOwner: true, showLoading: true);
  }

  Future<List<Issue>> fetchIssues(
      {bool onlyOwner = false, bool showLoading = true}) async {
    if (showLoading) EasyLoading.show(status: "Fetching Issues");

    print(onlyOwner);

    if (onlyOwner) {
      own = await AppDBService().getAllIssues(currOffset, true);
    } else {
      fetchedIssues = await AppDBService().getAllIssues(currOffset, false);
    }
    if (showLoading) EasyLoading.dismiss();
    update();
    return fetchedIssues;
  }

  void hanldeUpvote(String id, Issue iss, String email) async {
    await AppDBService().handleUpvote(id: id, iss: iss, email: email);
    await fetchIssues(onlyOwner: false, showLoading: false);
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  void updateIndex(int i) {
    currIndex = i;
    update();
  }
}
