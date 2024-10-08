import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget deadlinePassedWidget() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage("images/splash.png"), fit: BoxFit.fill),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Color(0xFFFFFFFF).withOpacity(0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "We're sorry, but the deadline to join the contest has now passed. Make yourself ready for the next one!",
            style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: primaryColor, width: 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonRadius)
                  ),
                ),
                child: Text("Join now", style: TextStyle(color: onPrimaryColor, fontSize: buttonFontSize),),
              )),
          SizedBox(height: 10,)
        ],
      ),
    ),
  );
}