import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/fixture/data/models/match_stat.dart';
import 'package:flutter/material.dart';

Widget statComponent({required String title, required MatchStat? matchStat}){
  return matchStat == null ? const SizedBox() : Column(
    children: [
      SizedBox(height: 5,),
      Divider(thickness: 1.0, color: primaryColor,),
      SizedBox(height: 5,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 13),
            decoration: BoxDecoration(
                color: matchStat.home >= matchStat.away ? primaryColor : surfaceColor,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Text("${matchStat.home}", textAlign: TextAlign.start, style: TextStyle(color: matchStat.home >= matchStat.away ? onPrimaryColor : Colors.black, fontWeight: FontWeight.w700),),
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 13),
            decoration: BoxDecoration(
                color: matchStat.home < matchStat.away ? primaryColor : surfaceColor,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Text("${matchStat.away}", textAlign: TextAlign.end, style: TextStyle(color: matchStat.home < matchStat.away ? onPrimaryColor : Colors.black, fontWeight: FontWeight.w700),),
          )
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          SizedBox(width: 50,),
          Expanded(
              flex: matchStat.home.toInt(),
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                    color: matchStat.home >= matchStat.away ? primaryColor : surfaceColor,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(15))
                ),
              )),
          Expanded(
              flex: matchStat.away.toInt(),
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                    color: matchStat.home < matchStat.away ? primaryColor : surfaceColor,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(15))
                ),
              )),
          SizedBox(width: 50,),
        ],
      )
    ],
  );
}