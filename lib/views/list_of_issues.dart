import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/issue_card.dart';

class ListOfIssues extends StatelessWidget {
  const ListOfIssues({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (item, ind) => const IssueCard(),
    );
  }
}
