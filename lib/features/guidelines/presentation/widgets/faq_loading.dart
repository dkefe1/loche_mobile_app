import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:flutter/material.dart';

Widget faqLoading() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      BlinkContainer(width: 100, height: 20, borderRadius: 0),
      SizedBox(
        height: 10,
      ),
      BlinkContainer(width: 300, height: 20, borderRadius: 0),
      SizedBox(
        height: 30,
      ),
      BlinkContainer(width: double.infinity, height: 50, borderRadius: 7),
      SizedBox(height: 10,),
      BlinkContainer(width: double.infinity, height: 50, borderRadius: 7),
      SizedBox(height: 10,),
      BlinkContainer(width: double.infinity, height: 50, borderRadius: 7),
      SizedBox(height: 10,),
      BlinkContainer(width: double.infinity, height: 50, borderRadius: 7),
      SizedBox(height: 10,),
      BlinkContainer(width: double.infinity, height: 50, borderRadius: 7),
      SizedBox(height: 10,),
      BlinkContainer(width: double.infinity, height: 50, borderRadius: 7),
      SizedBox(height: 10,),
    ],
  );
}