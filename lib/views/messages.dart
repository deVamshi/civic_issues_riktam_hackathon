import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../untils.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: ListView.builder(
          itemCount: 6,
          itemBuilder: (item, ind) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              title: Text(
                'Generally, the developer should be concerned with removing controllers from memory. With GetX this is not necessary because resources are removed from memory when they are not used by default.  ',
              ),
              subtitle: Text("\nPosted by Fvvao 34:3:3423"),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cGVyc29ufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
              ),
            );
          }),
      bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: false,
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  decoration: inputDecor("Add Comment"),
                ),
              ),
              hspace(5),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
