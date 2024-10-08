import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

Widget noDataWidget({required String icon, required String message, required double iconSize, required Color iconColor}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Iconify(icon, size: iconSize, color: iconColor,),
      SizedBox(height: 5,),
      Text(message, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 14),),
      SizedBox(height: 90,)
    ],
  );
}