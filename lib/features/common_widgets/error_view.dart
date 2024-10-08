import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:flutter/material.dart';

Widget errorView({required String iconPath, required String title, required String text, required VoidCallback onPressed}){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: backgroundColor,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(iconPath, width: 105.01, height: 84.1, fit: BoxFit.fill,),
        SizedBox(height: 40,),
        Text(title, textAlign: TextAlign.center, style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w700),),
        SizedBox(height: 10,),
        Text(text, textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF000000).withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w400),),
        SizedBox(height: 40,),
        SizedBox(
            width: double.infinity,
            child: submitButton(onPressed: () {
              onPressed();
            }, text: "Try Again", disabled: false)),
      ],
    ),
  );
}