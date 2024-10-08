import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget joinedGameweekDialog({required BuildContext context}) {

  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Already joined the gameweek", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Color(0xFF23262F)),)),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Color(0xFFDFDFE6))
                    ),
                    child: Center(
                      child: Icon(Icons.close, size: 15, color: textBlackColor,),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 25,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/already_joined_icon.png", height: 24, width: 24, fit: BoxFit.fill, color: Colors.green,),
              SizedBox(width: 10,),
              Expanded(child: Text("You have already joined this week's gameweek", textAlign: TextAlign.left, style: TextStyle(color: Colors.green, fontSize: 14),)),
            ],
          ),
          SizedBox(height: 20,),
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset("images/already_joined.png", fit: BoxFit.fill, width: double.infinity, height: 150,)),
        ],
      ),
    ),
  );
}