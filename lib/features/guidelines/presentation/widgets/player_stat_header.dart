import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget playerStatHeader({required String title}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: onPrimaryColor, fontWeight: FontWeight.w700, fontSize: 16),),
      ],
    ),
  );
}
