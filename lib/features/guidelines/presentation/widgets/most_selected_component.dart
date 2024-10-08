import 'package:fantasy/core/services/assign_kit.dart';
import 'package:flutter/material.dart';

Widget mostSelectedComponent({required String label, required String club, required String playerName, required String position}){

  Kit kit = Kit();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14), textAlign: TextAlign.center,),
      SizedBox(height: 5,),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            border: Border.all(color: Color(0xFF000000).withOpacity(0.2)),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          children: [
            Image.asset(kit.getKit(team: club, position: position), width: 60.61, height: 81, fit: BoxFit.fill,),
            SizedBox(height: 5,),
            SizedBox(
                width: double.infinity,
                child: Text(playerName, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w800, fontSize: 12),)),
          ],
        ),
      ),
    ],
  );
}