import 'package:civic_issues_riktam_hackathon/services/app_db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/issue_model.dart';

class AppStateController extends GetxController {
  int currIndex = 0;
  int currOffset = 0;
  bool isAdmin = false;

  void updateIsAdmin(bool newAdminState) {
    isAdmin = newAdminState;
    update();
  }

  List<Issue> fetchedIssues = [];
  List<Issue> own = [];

  void updateIssueStatus(Issue iss, String newStatus) async {
    EasyLoading.show();
    await AppDBService().updateStatus(iss, newStatus);
    EasyLoading.dismiss();
    fetchIssues();
    update();
  }

  Future<void> fetchOwnIssues() async {
    List<Issue> ownIssues = [];
    String currUserEmail = FirebaseAuth.instance.currentUser?.email ?? "*";

    print(currUserEmail);
    for (Issue iss in fetchedIssues) {
      if (iss.email == currUserEmail) ownIssues.add(iss);
      print(iss.email);
    }

    print(ownIssues);

    own = ownIssues;
    update();
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
    fetchIssues();
    super.onInit();
  }

  void updateIndex(int i) {
    currIndex = i;
    if (currIndex == 0) {
      fetchIssues(onlyOwner: false, showLoading: false);
    } else if (currIndex == 2) {
      fetchOwnIssues();
    }
    update();
  }
}
