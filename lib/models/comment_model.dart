import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  String email;
  String content;
  String time;
  String belongsTo;

  Comment({
    this.id,
    required this.email,
    required this.time,
    required this.content,
    required this.belongsTo,
  });

  factory Comment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Comment(
      email: data?['email'],
      content: data?['content'],
      time: data?['time'] ?? DateTime.now(),
      belongsTo: data?['belongsTo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "content": content,
      "time": time,
      'belongsTo': belongsTo,
    };
  }
}
