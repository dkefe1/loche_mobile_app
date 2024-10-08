import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget howToPlayComponent({required String title, required String description, required String iconPath, required double iconHeight, required double iconWidth}) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: iconWidth, height: iconHeight, fit: BoxFit.fill,),
          SizedBox(width: 10,),
          Text(title, style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 12),)
        ],
      ),
      SizedBox(height: 10,),
      Text(description, style: TextStyle(color: Color(0xFF000000).withOpacity(0.7), fontWeight: FontWeight.w400, fontSize: 12, letterSpacing: 1),)
    ],
  );
}