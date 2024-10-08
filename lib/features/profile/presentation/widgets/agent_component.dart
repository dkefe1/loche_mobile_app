import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/profile/data/models/agents.dart';
import 'package:flutter/material.dart';

Widget agentsComponent({required Agents agent, required int index}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(15)
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${index+1}.", style: TextStyle(color: textBlackColor, fontSize: 13, fontWeight: FontWeight.w600),),
          SizedBox(width: 7,),
          Image.asset("images/leader.png", width: 36, height: 36, fit: BoxFit.fill,),
        ],
      ),
      title: Text(agent.full_name, style: TextStyle(color: textBlackColor, fontSize: 14, fontWeight: FontWeight.w500),),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(agent.amount.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textBlackColor),),
          Text("Coin", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: textColor),),
        ],
      ),
    ),
  );
}