import 'package:civic_issues_riktam_hackathon/components/issue_card.dart';
import 'package:civic_issues_riktam_hackathon/views/add_issue_view.dart';
import 'package:civic_issues_riktam_hackathon/views/list_of_issues.dart';
import 'package:civic_issues_riktam_hackathon/views/login_view.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LoginScreen()

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

  List<Widget> screens = [ListOfIssues(), AddIssue()];
  List<String> headings = ["All Issues", "Add Issue", "My Issues"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(headings[currInd]),
      ),
      body: screens[currInd],
      bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.indigo,
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.add, title: 'Add Issue'),
            TabItem(icon: Icons.list, title: 'My Issues'),
          ],
          onTap: (int i) => setState(() {
                currInd = i;
              })),
    );
  }
}
