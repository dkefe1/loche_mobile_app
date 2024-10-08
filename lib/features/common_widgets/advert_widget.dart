import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget advertWidget({required double width, required double height}){
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: dangerColor
    ),
    child: Center(child: Text("AD HERE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),),
  );
}