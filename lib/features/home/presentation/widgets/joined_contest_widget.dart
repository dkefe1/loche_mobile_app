import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:flutter/material.dart';

Widget joinedContestWidget() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage("images/splash.png"), fit: BoxFit.fill),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Color(0xFFFFFFFF).withOpacity(0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You have joined this week's contest, Good luck !!!",
            style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}