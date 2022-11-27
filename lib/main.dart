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
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isAdmin = false;
  @override
  void initState() {
    lookAuthChanges();
    super.initState();
  }

  void lookAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        isLoggedIn = false;
      } else {
        print("User logged in");
        isAdmin = user.email == "admin@gmail.com";
        isLoggedIn = true;
      }
      if (mounted) {
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Civic Issues',
        builder: EasyLoading.init(),
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: isLoggedIn ? MyHomePage(isAdmin: isAdmin) : LoginScreen());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.isAdmin});

  bool isAdmin;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currInd = 0;

  int currOffSet = 0;

  List<Widget> screens = [ListOfIssues(), AddIssue()];
  List<String> headings = ["All Issues", "Add Issue", "My Issues"];

  final appStateCtrl = Get.put(AppStateController());

  final dbService = AppDBService();

  List<Issue> fetchedIssues = [];

  @override
  void initState() {
    if (widget.isAdmin) {
      appStateCtrl.updateIsAdmin(true);
    }
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
                EasyLoading.show(status: "Please wait!");
                await FirebaseAuth.instance.signOut();
                EasyLoading.dismiss();
                Get.offAll(LoginScreen());
              },
              icon: const Icon(Icons.login))
        ],
        title: Text(headings[currInd]),
      ),
      body: widget.isAdmin
          ? ListOfIssues()
          : GetBuilder<AppStateController>(
              builder: (ctrl) => getCurrentScreen(ctrl.currIndex),
            ),
      bottomNavigationBar: widget.isAdmin
          ? null
          : ConvexAppBar(
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
