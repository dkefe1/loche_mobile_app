import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget contestMatchBox({required double iconHeight, required double iconWidth,}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset("images/team1.png", width: iconWidth, height: iconHeight,)),
          SizedBox(height: 5,),
          Text("Man United", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
        ],
      ),
      Column(
        children: [
          Text("June,12", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),),
          Text("VS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textBlackColor),),
        ],
      ),
      Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset("images/team2.png", width: iconWidth, height: iconHeight,)),
          SizedBox(height: 5,),
          Text("Man City", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
        ],
      )
    ],
  );
}