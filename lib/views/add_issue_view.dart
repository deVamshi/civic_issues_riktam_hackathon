import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:civic_issues_riktam_hackathon/controllers/app_state_controller.dart';
import 'package:civic_issues_riktam_hackathon/models/issue_model.dart';
import 'package:civic_issues_riktam_hackathon/services/app_db_service.dart';
import 'package:civic_issues_riktam_hackathon/untils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddIssue extends StatefulWidget {
  AddIssue({super.key});

  @override
  State<AddIssue> createState() => _AddIssueState();
}

class _AddIssueState extends State<AddIssue> {
  @override
  void initState() {
    super.initState();
  }

  final titleCtrl = TextEditingController();

  final descCtrl = TextEditingController();

  Issue currentIssue = Issue(time: DateTime.now().toIso8601String());

  List<File> selectedImages = [];

  void _handleOnSubmit() async {
    if (titleCtrl.text.isEmpty ||
        descCtrl.text.isEmpty ||
        selectedImages.isEmpty) {
      EasyLoading.showError("Please fill all the required details");
      return;
    }

    EasyLoading.show(status: "Uploading files, Please wait");

    final db = AppDBService();
    currentIssue.images = await db.uploadFiles(selectedImages);
    final appStateCtrl = Get.find<AppStateController>();
    currentIssue.title = titleCtrl.text.trim();
    currentIssue.desc = descCtrl.text.trim();
    currentIssue.email =
        FirebaseAuth.instance.currentUser?.email ?? "bugging@gmail.com";

    await db.addIssue(currentIssue);
    EasyLoading.dismiss();
    EasyLoading.showSuccess("Issue created successfully");
    titleCtrl.clear();
    descCtrl.clear();
    selectedImages = [];
    appStateCtrl.updateIndex(0);
  }

  Widget imageWidgetLocal(File file) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 100,
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(file),
        ),
      ),
    );
  }

  Widget addPhotoWidget() {
    return GestureDetector(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? image =
            await _picker.pickImage(source: ImageSource.camera);

        if (image != null) selectedImages.add(File(image.path));
        setState(() {});
        print(selectedImages);
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
        width: 100,
        height: 100,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.indigo[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.indigo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      children: [
        vspace(20),
        TextField(
          controller: titleCtrl,
          autofocus: false,
          style: TextStyle(fontSize: 15.0, color: Colors.black),
          decoration: inputDecor("Issue Name"),
        ),
        vspace(20),
        TextField(
          controller: descCtrl,
          maxLines: 8,
          autofocus: false,
          style: TextStyle(fontSize: 15.0, color: Colors.black),
          decoration: inputDecor("Description."),
        ),
        vspace(15),
        OutlinedButton.icon(
          icon: const Icon(Icons.date_range_rounded),
          onPressed: () {
            DatePicker.showDateTimePicker(context, showTitleActions: true,
                onConfirm: (date) {
              print('confirm $date');
              currentIssue.time = date.toIso8601String();
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          label: const Text(
            'Add Date & Time',
          ),
        ),
        vspace(20),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...selectedImages.map((img) => imageWidgetLocal(img)),
              addPhotoWidget(),
            ],
          ),
        ),
        vspace(20),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _handleOnSubmit,
            icon: const Icon(Icons.done_all_rounded),
            label: const Text("Submit"),
          ),
        )
      ],
    );
  }
}
