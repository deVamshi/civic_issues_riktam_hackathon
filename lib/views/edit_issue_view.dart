import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:civic_issues_riktam_hackathon/controllers/app_state_controller.dart';
import 'package:civic_issues_riktam_hackathon/models/issue_model.dart';
import 'package:civic_issues_riktam_hackathon/services/app_db_service.dart';
import 'package:civic_issues_riktam_hackathon/untils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditIssue extends StatefulWidget {
  EditIssue({super.key, required this.issue});

  Issue issue;

  @override
  State<EditIssue> createState() => _EditIssueState();
}

class _EditIssueState extends State<EditIssue> {
  @override
  void initState() {
    currentIssue = widget.issue;
    titleCtrl.text = currentIssue.title ?? "";
    descCtrl.text = currentIssue.desc ?? "";
    prevImages = currentIssue.images ?? [];

    super.initState();
  }

  final titleCtrl = TextEditingController();

  final descCtrl = TextEditingController();

  late Issue currentIssue;

  List<String?> prevImages = [];

  List<File> newSelectImages = [];

  void _handleOnSubmit() async {
    if (titleCtrl.text.isEmpty || descCtrl.text.isEmpty) {
      EasyLoading.showError("Please fill all the required details");
      return;
    }

    EasyLoading.show(status: "Saving, Please wait");

    final db = AppDBService();

    if (newSelectImages.isNotEmpty) {
      currentIssue.images?.addAll(await db.uploadFiles(newSelectImages));
    }

    final appStateCtrl = Get.find<AppStateController>();
    currentIssue.title = titleCtrl.text.trim();
    currentIssue.desc = descCtrl.text.trim();

    await db.editIssue(currentIssue.id ?? "", currentIssue);
    EasyLoading.dismiss();
    EasyLoading.showSuccess("Issue edited successfully");
    titleCtrl.clear();
    descCtrl.clear();
    newSelectImages = [];
    Get.back();
    appStateCtrl.fetchIssues(onlyOwner: false);
  }

  Widget imageWidgetNetwork(String url) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 100,
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(url),
        ),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          currentIssue.images?.removeWhere((element) => element == url);
          setState(() {});
        },
      ),
    );
  }

  Widget addPhotoWidget() {
    return GestureDetector(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);

        if (image != null) newSelectImages.add(File(image.path));
        setState(() {});
        print(newSelectImages);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Issue"),
      ),
      body: ListView(
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
                ...prevImages.map((img) => imageWidgetNetwork(img ?? "")),
                ...newSelectImages.map((file) => imageWidgetLocal(file)),
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
              label: const Text("Save Edit"),
            ),
          )
        ],
      ),
    );
  }
}
