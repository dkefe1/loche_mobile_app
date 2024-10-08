import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget aboutUsComponent({required String title, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 12),
      ),
      SizedBox(height: 10,),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: lightPrimary,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(value, textAlign: TextAlign.start, style: TextStyle(
          fontSize: 12, color: Color(0xFF000000).withOpacity(0.7)
        ),),
      )
    ],
  );
}