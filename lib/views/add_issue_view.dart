import 'package:cached_network_image/cached_network_image.dart';
import 'package:civic_issues_riktam_hackathon/untils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddIssue extends StatelessWidget {
  const AddIssue({super.key});

  

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      children: [
        vspace(20),
        TextField(
          autofocus: false,
          style: TextStyle(fontSize: 15.0, color: Colors.black),
          decoration: inputDecor("Issue Name"),
        ),
        vspace(20),
        TextField(
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
                onChanged: (date) {
              print('change $date');
            }, onConfirm: (date) {
              print('confirm $date');
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
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      "https://images.unsplash.com/photo-1604357209793-fca5dca89f97?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFwfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      "https://images.unsplash.com/photo-1604357209793-fca5dca89f97?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFwfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                    ),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 100, minHeight: 100),
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAlias,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.indigo,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo[100],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
            scrollDirection: Axis.horizontal,
          ),
        ),
        vspace(20),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.done_all_rounded),
            label: const Text("Submit"),
          ),
        )
      ],
    );
  }
}
