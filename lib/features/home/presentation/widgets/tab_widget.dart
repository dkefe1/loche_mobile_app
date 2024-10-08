import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget tabWidget({required String position, required int count}) {
  return Row(
    children: [
      Text(
        position,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primaryColor),
      ),
      Text(
        "(${count})",
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor),
      ),
    ],
  );
}