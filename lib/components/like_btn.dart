import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_state_controller.dart';
import '../models/issue_model.dart';

class LikeButton extends StatefulWidget {
  LikeButton({super.key, required this.iss});

  Issue iss;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  int likeCount = 0;

  final appStateCtrl = Get.find<AppStateController>();

  @override
  void initState() {
    isLiked = widget.iss.likes
        .contains(FirebaseAuth.instance.currentUser?.email ?? "&");
    likeCount = widget.iss.likes.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        if (isLiked)
          likeCount--;
        else
          likeCount++;
        isLiked = !isLiked;
        setState(() {});
        appStateCtrl.hanldeUpvote(widget.iss.id ?? "*", widget.iss,
            FirebaseAuth.instance.currentUser?.email ?? "*");
      },
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border_rounded,
        size: 20,
        color: Colors.red,
      ),
      label: Text("$likeCount"),
    );
  }
}
