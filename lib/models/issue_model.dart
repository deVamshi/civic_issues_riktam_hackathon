import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  String? id;
  String? title;
  String? desc;
  String time;
  List<String?>? images = [];
  String status;
  int upvotes;

  Issue({
    this.id,
    this.title,
    this.desc,
    required this.time,
    this.images,
    this.status = "OPEN",
    this.upvotes = 0,
  });

  factory Issue.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Issue(
        id: data?['id'],
        title: data?['title'],
        desc: data?['desc'],
        time: data?['time'] ?? DateTime.now(),
        images: data?['images'] is Iterable ? List.from(data?['images']) : null,
        status: data?['status'],
        upvotes: data?['upvotes']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (title != null) "title": title,
      if (desc != null) "desc": desc,
      "time": time,
      if (images != null) "images": images,
      "status": status,
      "upvotes": upvotes,
    };
  }
}
