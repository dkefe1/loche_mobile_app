import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget creditBox2({required String iconPath, required String desc, required VoidCallback onPressed, required double width, required double height}){
  return GestureDetector(
    onTap: (){
      onPressed();
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: Color(0xFF1E727E).withOpacity(0.25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor, width: 0.5)),
      child: Image.asset(
        iconPath,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    ),
  );
}