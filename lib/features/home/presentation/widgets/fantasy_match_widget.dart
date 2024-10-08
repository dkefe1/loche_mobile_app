import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget fantasyMatchWidget({required String club1Count, required String club2Count}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset("images/team1.png", width: 50, height: 50,)),
          SizedBox(height: 5,),
          Row(
            children: [
              Text("Man United", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
              Text("(${club1Count})", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColor),),
            ],
          )
        ],
      ),
      Column(
        children: [
          Text("June, 12, 16:00", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xFF1E727E).withOpacity(0.2)
            ),
            child: Row(
              children: [
                Text("4", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
                Text("d", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
                Text(" 7", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
                Text("h", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
                Text(" 30", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
                Text("m", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
              ],
            ),
          ),
        ],
      ),
      Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset("images/team2.png", width: 50, height: 50,)),
          SizedBox(height: 5,),
          Row(
            children: [
              Text("Man City", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
              Text("(${club2Count})", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColor),),
            ],
          )
        ],
      )
    ],
  );
}