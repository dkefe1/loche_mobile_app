import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leader.dart';
import 'package:flutter/material.dart';

Widget myMonthlyLeaderContainer({required MonthlyLeader contestor}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.1),
        border: Border.all(color: primaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(15)
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(contestor.rank.toString(), style: TextStyle(color: textBlackColor, fontSize: 13, fontWeight: FontWeight.w600),),
          SizedBox(width: 10,),
          Image.asset("images/leader.png", width: 36, height: 36, fit: BoxFit.fill,),
        ],
      ),
      title: Text("${contestor.first_name} ${contestor.last_name}", style: TextStyle(color: textBlackColor, fontSize: 14, fontWeight: FontWeight.w500),),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(contestor.total_fantasy_point.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textBlackColor),),
          Text("Pt", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: textColor),),
        ],
      ),
    ),
  );
}