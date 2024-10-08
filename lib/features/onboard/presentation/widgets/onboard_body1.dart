import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:flutter/material.dart';

Widget onBoardBody1({required double w, required double h}) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(defaultBorderRadius)),
          child: Image.asset("images/splash.png", width: w, height: h/2 + 60, fit: BoxFit.cover,)),
      Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: logoName(),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(15, 150, 15, 0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            Image.asset(
              "images/onboard1.png",
              width: 123.13,
              height: 147.49,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Craft Your Dream Team",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: textFontSize4, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Create your ultimate squad by selecting 15 real-world players from the English Premier League. Choose wisely with a maximum of 3 players per club. Customize your lineup, lead your team, and dominate the competition!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: textFontSize
              ),
            )
          ],
        ),
      ),
    ],
  );
}
