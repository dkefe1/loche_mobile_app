import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/my_contests/presentation/widgets/contest_match_box.dart';
import 'package:fantasy/features/profile/data/models/awards.dart';
import 'package:flutter/material.dart';

Widget awardComponent2({required Awards contestor, required int index}){
  return Container(
    padding: EdgeInsets.only(top: 5, bottom: 10),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: lightPrimary,
        borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${index + 1}.", style: TextStyle(color: textBlackColor, fontSize: 13, fontWeight: FontWeight.w600),),
                SizedBox(width: 10,),
                Image.asset("images/leader.png", width: 36, height: 36, fit: BoxFit.fill,),
              ],
            ),
            title: Text(contestor.client_id.full_name, style: TextStyle(color: textBlackColor, fontSize: 14, fontWeight: FontWeight.w500),),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Prize: ", style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600),),
                Text(contestor.prize.toString(), style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w600),),
                Text("(Coin)", style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w600),),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(contestor.total_fantasy_point.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textBlackColor),),
                Text("Pt", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: textColor),),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}