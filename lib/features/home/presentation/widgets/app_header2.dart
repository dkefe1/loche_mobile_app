import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget appHeader2({required String title, required String desc}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: onPrimaryColor, fontWeight: FontWeight.w700, fontSize: 14),),
        desc.isEmpty ? SizedBox() : SizedBox(
          height: 10,
        ),
        desc.isEmpty ? SizedBox() : Text(
          desc,
          style: TextStyle(
              color: onPrimaryColor,
              fontWeight: FontWeight.w400,
              fontSize: textFontSize),
        )
      ],
    ),
  );
}
