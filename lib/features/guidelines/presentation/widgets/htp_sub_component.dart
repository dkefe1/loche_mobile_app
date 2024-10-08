import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget htpSubComponent({required String title, required String description}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w700, fontSize: 13),),
      SizedBox(height: 5,),
      Text(description, style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w400, fontSize: 12, letterSpacing: 1),)
    ],
  );
}