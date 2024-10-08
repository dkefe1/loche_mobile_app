import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget creditBox({required String iconPath, required String value, required String desc}){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor, width: 0.5)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Image.asset(
            iconPath,
            width: 20,
            height: 20,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          value,
          style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
        Text(
          " $desc",
          style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
      ],
    ),
  );
}