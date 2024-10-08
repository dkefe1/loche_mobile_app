import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget matchComponent({required VoidCallback onPressed}) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 20),
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(15)
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("images/team1.png", width: 50, height: 50,)),
                SizedBox(height: 5,),
                Text("Man United", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
              ],
            ),
            Column(
              children: [
                Text("June,12 16:00", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),),
                Text("VS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textBlackColor),),
                Row(
                  children: [
                    Text("4", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
                    Text("d", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
                    Text(" 7", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
                    Text("h", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
                    Text(" 30", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
                    Text("m", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("images/team2.png", width: 50, height: 50,)),
                SizedBox(height: 5,),
                Text("Man City", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
              ],
            )
          ],
        ),
        SizedBox(height: 10,),
        Divider(color: primaryColor3, thickness: 1.0,),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset("images/reward.png", fit: BoxFit.cover, width: 15, height: 20,),
                SizedBox(width: 5,),
                Text("10,000", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor3),),
                Text("Coin", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: primaryColor3),),
              ],
            ),
            ElevatedButton(
              onPressed: (){
                onPressed();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonRadius2)
                  )
              ),
              child: Text("Create Team", style: TextStyle(color: onPrimaryColor, fontSize: 14),),
            )
          ],
        ),
        SizedBox(height: 25,),
        Center(child: Text("Powered by:", style: TextStyle(color: textColor, fontSize: 10),),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/powered.png", fit: BoxFit.fill, width: 40, height: 40,),
            SizedBox(width: 5,),
            Text("Zemen Bank", style: TextStyle(color: Color(0xFF000000).withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600),)
          ],
        )
      ],
    ),
  );
}