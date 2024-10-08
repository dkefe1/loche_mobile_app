import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/my_contests/presentation/widgets/contest_match_box.dart';
import 'package:flutter/material.dart';

Widget bestManagerWidget() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 15),
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Color(0xFF1E727E).withOpacity(0.1),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Color(0xFF1E727E).withOpacity(0.2), width: 1.0)
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: Row(
            children: [
              Image.asset("images/trophy.png", fit: BoxFit.cover, width: 70.59, height: 74,),
              SizedBox(width: 30,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name", style: TextStyle(fontSize: 12, color: textColor),),
                  Text("Amanueal Kebede", style: TextStyle(fontSize: 14, color: textBlackColor, fontWeight: FontWeight.w600),),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Point", style: TextStyle(fontSize: 12, color: textColor),),
                            Text("89", style: TextStyle(fontSize: 14, color: Color(0xFF1E727E).withOpacity(0.6), fontWeight: FontWeight.w700),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Prize", style: TextStyle(fontSize: 12, color: textColor),),
                            Row(
                              children: [
                                Text("10,000", style: TextStyle(fontSize: 14, color: Color(0xFF1E727E).withOpacity(0.6), fontWeight: FontWeight.w700),),
                                Text("Coin", style: TextStyle(fontSize: 10, color: Color(0xFF1E727E).withOpacity(0.6), fontWeight: FontWeight.w400),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
        SizedBox(height: 10,),
        Divider(color: Color(0xFF4B8E98).withOpacity(0.3), thickness: 1.0,),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Contest", style: TextStyle(fontSize: 12, color: textColor),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: contestMatchBox(iconHeight: 40, iconWidth: 40),
              )
            ],
          ),
        )
      ],
    ),
  );
}