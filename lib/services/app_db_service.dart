import 'dart:io';

import 'package:civic_issues_riktam_hackathon/models/issue_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppDBService {
  Future<List<Issue>> getAllIssues(int offset, bool onlyOwner) async {
    CollectionReference<Issue> ref =
        FirebaseFirestore.instance.collection("issues").withConverter(
              fromFirestore: Issue.fromFirestore,
              toFirestore: (Issue issue, _) => issue.toFirestore(),
            );
    if (onlyOwner) {
      ref.where('id', isEqualTo: FirebaseAuth.instance.currentUser?.email);
    }
    final docSnap = await ref.get();
    final issues = docSnap.docs;
    List<Issue> allIssues = [];

    for (final iss in issues) {
      Issue currIssue = iss.data();
      currIssue.id = iss.id;
      allIssues.add(currIssue);
    }

    return allIssues;
  }

  Future<String> addIssue(Issue issue) async {
    final dbRef = FirebaseFirestore.instance.collection("issues").withConverter(
          fromFirestore: Issue.fromFirestore,
          toFirestore: (Issue issue, options) => issue.toFirestore(),
        );
    final docRef = await dbRef.add(issue);
    return docRef.id;
  }

  Future<bool> editIssue(String id, Issue iss) async {
    final dbRef = FirebaseFirestore.instance
        .collection("issues")
        .withConverter(
          fromFirestore: Issue.fromFirestore,
          toFirestore: (Issue issue, options) => issue.toFirestore(),
        )
        .doc(id);
    await dbRef.set(iss);
    return true;
  }

  Future<bool> handleUpvote(
      {required String id, required Issue iss, required String email}) async {
    if (iss.likes.contains(email)) {
      iss.likes.removeWhere((element) => element == email);
    } else {
      iss.likes.add(email);
    }

    final dbRef = FirebaseFirestore.instance
        .collection("issues")
        .withConverter(
          fromFirestore: Issue.fromFirestore,
          toFirestore: (Issue issue, options) => issue.toFirestore(),
        )
        .doc(id);
    await dbRef.set(iss);
    return true;
  }

  Future<List<String>> uploadFiles(List<File> _images) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => _uploadFile(_image)));
    print(imageUrls);
    return imageUrls;
  }

  Future<String> _uploadFile(File _image) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(
        'gallery/${_image.path.substring(_image.path.lastIndexOf('/'))}');
    UploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }
}
