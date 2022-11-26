import 'dart:io';

import 'package:civic_issues_riktam_hackathon/models/issue_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AppDBService {
  Future<List<Issue>> getAllIssues(int offset) async {
    final ref = FirebaseFirestore.instance.collection("issues").withConverter(
          fromFirestore: Issue.fromFirestore,
          toFirestore: (Issue issue, _) => issue.toFirestore(),
        );
    final docSnap = await ref.get();
    final issues = docSnap.docs;
    List<Issue> allIssues = [];

    for (final iss in issues) {
      print(iss.data().title);
      allIssues.add(iss.data());
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
