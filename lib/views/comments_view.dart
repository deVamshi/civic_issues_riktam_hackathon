import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:civic_issues_riktam_hackathon/models/comment_model.dart';
import 'package:civic_issues_riktam_hackathon/services/app_db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

import '../models/issue_model.dart';
import '../untils.dart';

class CommentsView extends StatefulWidget {
  CommentsView({super.key, required this.iss});

  Issue iss;

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  List<Comment> comments = [];

  TextEditingController cmtCtrl = TextEditingController();

  final AppDBService appDB = AppDBService();

  @override
  void initState() {
    fetchComments();
    super.initState();
  }

  void fetchComments() async {
    comments = await appDB.getAllComments(widget.iss.id ?? "");
    comments.sort((a, b) =>
        DateTime.parse(a.time).isAfter(DateTime.parse(b.time)) ? 0 : 1);
    setState(() {});
  }

  void addComment() async {
    final Comment newComment = Comment(
        email: FirebaseAuth.instance.currentUser?.email ?? "Bugging",
        time: DateTime.now().toIso8601String(),
        content: cmtCtrl.text.trim(),
        belongsTo: widget.iss.id ?? "Bugging");

    FocusScope.of(context).unfocus();
    cmtCtrl.clear();

    await appDB.addComment(newComment);
    fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: cmtCtrl,
              autofocus: false,
              style: const TextStyle(fontSize: 15.0, color: Colors.black),
              decoration: inputDecor("Add Comment"),
            ),
          ),
          hspace(5),
          GestureDetector(
            onTap: () {
              if (cmtCtrl.text.isEmpty) return;
              addComment();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]),
      ),
      appBar: AppBar(
        title: const Text("Comments"),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[100],
            leading: const SizedBox(),
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text('${widget.iss.title}', textScaleFactor: 0.8),
              background: CarouselSlider(
                items: widget.iss.images?.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                i ?? imgURL,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 350,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.95,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (i, _) {},
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
          //3

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int ind) {
                if (comments.isEmpty) {
                  return Lottie.asset('assets/lottie/comments.json',
                      width: 100);
                } else {
                  Comment com = comments[ind];

                  final time = DateTime.parse(com.time);

                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    title: Text(com.content),
                    subtitle: Text(
                        "\nBy: ${com.email}\nOn: ${DateFormat('yyyy-MM-dd – kk:mm').format(time)}"),
                    leading: CircleAvatar(
                      child: Center(child: Text("${com.email[0]}")),
                    ),
                  );
                }
              },
              childCount: comments.isEmpty ? 1 : comments.length,
            ),
          ),
        ],
      ),
    );
  }
}
