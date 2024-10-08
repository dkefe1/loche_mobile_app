import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget appHeader3({required String title, required String budget, String? desc}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: TextStyle(color: onPrimaryColor, fontWeight: FontWeight.w700, fontSize: 16),)),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text("Budget : $budget", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),)),
          ],
        ),
        desc == null ? SizedBox() : Text(desc, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14),)
      ],
    ),
  );
}
