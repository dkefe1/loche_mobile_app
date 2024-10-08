import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:flutter/material.dart';
import 'package:fantasy/core/constants.dart';

Widget onBoardBody3({required double w, required double h}) {
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
              height: 80,
            ),
            Image.asset(
              "images/onboard3.png",
              width: 151.56,
              height: 151.56,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Battle for Rewards",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: textFontSize4, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Engage in thrilling contests, challenge fellow users, and seize the chance to win valuable prizes. The ultimate glory awaits!",
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
