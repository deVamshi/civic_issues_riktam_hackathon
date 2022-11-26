import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

SizedBox vspace(double h) {
  return SizedBox(height: h);
}

SizedBox hspace(double w) {
  return SizedBox(width: w);
}

InputDecoration inputDecor(String hintText) {
  return InputDecoration(
    border: InputBorder.none,
    hintText: hintText,
    filled: true,
    fillColor: Colors.indigo[100],
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
