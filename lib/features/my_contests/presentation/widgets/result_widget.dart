import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget resultWidget({required String icon, required double iconWidth, required double iconHeight, required String msg}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Result:", style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w600),),
      SizedBox(height: 10,),
      Center(child: Image.asset(icon, width: iconWidth, height: iconHeight, fit: BoxFit.fill,)),
      SizedBox(height: 10,),
      Text(msg, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF000000).withOpacity(0.7), fontWeight: FontWeight.w400),),
    ],
  );
}