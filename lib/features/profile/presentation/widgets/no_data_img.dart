import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

Widget noDataImageWidget({required String icon, required String message, required double iconWidth, required double iconHeight, required Color iconColor}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(icon, width: iconWidth, height: iconHeight, color: iconColor, fit: BoxFit.fill,),
      SizedBox(height: 5,),
      Text(message, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 14),),
      SizedBox(height: 90,)
    ],
  );
}