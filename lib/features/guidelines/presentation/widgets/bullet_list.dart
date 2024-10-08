import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget bulletList({required String text}){
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, bottom: 15),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 5.0,
          width: 5.0,
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: textBlackColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10,),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: textBlackColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}