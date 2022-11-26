import 'package:civic_issues_riktam_hackathon/controllers/app_state_controller.dart';
import 'package:civic_issues_riktam_hackathon/models/issue_model.dart';
import 'package:civic_issues_riktam_hackathon/services/app_db_service.dart';
import 'package:civic_issues_riktam_hackathon/views/add_issue_view.dart';
import 'package:civic_issues_riktam_hackathon/views/list_of_issues.dart';
import 'package:civic_issues_riktam_hackathon/views/login_view.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Civic Issues',
        builder: EasyLoading.init(),
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const MyHomePage()

        // const MyHomePage(),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currInd = 0;

  int currOffSet = 0;

  List<Widget> screens = [ListOfIssues(), AddIssue()];
  List<String> headings = ["All Issues", "Add Issue", "My Issues"];

  final dbService = AppDBService();

  List<Issue> fetchedIssues = [];
  final appStateCtrl = Get.put(AppStateController());

  @override
  void initState() {
    super.initState();
  }

  Widget getCurrentScreen(int index) {
    switch (index) {
      case (0):
        return ListOfIssues();
      case (1):
        return AddIssue();
      case (2):
        return ListOfIssues(onlyOwner: true);
      default:
        return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(LoginScreen());
              },
              icon: const Icon(Icons.login))
        ],
        title: Text(headings[currInd]),
      ),
      body: GetBuilder<AppStateController>(
        builder: (ctrl) => getCurrentScreen(ctrl.currIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.indigo,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.add, title: 'Add Issue'),
          TabItem(icon: Icons.list, title: 'My Issues'),
        ],
        onTap: (int i) => appStateCtrl.updateIndex(i),
      ),
    );
  }
}
