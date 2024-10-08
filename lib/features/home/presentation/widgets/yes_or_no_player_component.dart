import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget yesOrNoClientPlayerComponent({required String label, required num value}){
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),)),
          Expanded(child: Text(value == 1 ? "Yes" : "No", textAlign: TextAlign.center, style: TextStyle(color: value < 0 ? dangerColor2 : value == 0 ? Colors.black : Colors.green, fontWeight: FontWeight.w600, fontSize: 12),)),
        ],
      ),
      SizedBox(height: 5,),
      Divider(color: dividerColor, thickness: 1.0,),
      SizedBox(height: 10,),
    ],
  );
}