import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/leaderboard/data/models/winner.dart';
import 'package:fantasy/features/my_contests/presentation/widgets/contest_match_box.dart';
import 'package:flutter/material.dart';

Widget bestManagerWidget2({required int index, required Winner winner}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 15),
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFF1E727E).withOpacity(0.2), width: 1.0)
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: Row(
            children: [
              Image.asset("images/trophy.png", fit: BoxFit.cover, width: 70.59, height: 74, color: index == 0 ? bestManagerColor : primaryColor,),
              SizedBox(width: 30,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name", style: TextStyle(fontSize: 12, color: textColor),),
                  Text(winner.client_id.full_name, style: TextStyle(fontSize: 14, color: textBlackColor, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Point", style: TextStyle(fontSize: 12, color: textColor),),
                            Text(winner.total_fantasy_point.toString(), style: TextStyle(fontSize: 14, color: index == 0 ? bestManagerColor : Color(0xFF1E727E).withOpacity(0.6), fontWeight: FontWeight.w700),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Prize", style: TextStyle(fontSize: 12, color: textColor),),
                            Row(
                              children: [
                                Text(winner.prize.toString(), style: TextStyle(fontSize: 14, color: index == 0 ? bestManagerColor : Color(0xFF1E727E).withOpacity(0.6), fontWeight: FontWeight.w700),),
                                Text("Coin", style: TextStyle(fontSize: 10, color: index == 0 ? bestManagerColor : Color(0xFF1E727E).withOpacity(0.6), fontWeight: FontWeight.w400),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ],
    ),
  );
}