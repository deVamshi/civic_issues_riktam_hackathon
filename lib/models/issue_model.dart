import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  String? id;
  String? email;
  String? title;
  String? desc;
  String time;
  List<String?>? images = [];
  String status;
  List<String> likes = [];

  Issue({
    this.id,
    this.email,
    this.title,
    this.desc,
    required this.time,
    this.images,
    this.status = "OPEN",
    this.likes = const [],
  });

  factory Issue.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Issue(
      email: data?['email'],
      title: data?['title'],
      desc: data?['desc'],
      time: data?['time'] ?? DateTime.now(),
      images: data?['images'] is Iterable ? List.from(data?['images']) : [],
      status: data?['status'],
      likes: data?['likes'] is Iterable ? List.from(data?['likes']) : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      if (title != null) "title": title,
      if (desc != null) "desc": desc,
      "time": time,
      if (images != null) "images": images,
      "status": status,
      "likes": likes,
    };
  }
}
