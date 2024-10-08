import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/profile/presentation/screens/package_choice_screen.dart';
import 'package:flutter/material.dart';

Widget joinDepositDialog({required BuildContext context, required VoidCallback onPressed, required String phoneNumber}) {

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
                Expanded(child: Text("Don’t miss out this week", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Color(0xFF23262F)),)),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset("images/danger.png", height: 24, width: 24, fit: BoxFit.fill,),
              Text("You don’t have enough credits", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFFF5C5C), fontSize: 14),),
            ],
          ),
          SizedBox(height: 20,),
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset("images/join_dialog.png", fit: BoxFit.fill, width: double.infinity, height: 150,)),
          SizedBox(height: 20,),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      )
                  ),
                  onPressed: (){
                    onPressed();
                  }, child: Text("Deposit", style: TextStyle(color: Colors.white),))),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("want to save some money ?", style: TextStyle(color: Color(0xFF23262F), fontSize: 12),),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PackageChoiceScreen(autoJoin: true, phoneNumber: phoneNumber,)));
                  },
                  child: Text(" Buy Package", style: TextStyle(color: Color(0xFF3772FF), fontSize: 12),)),
            ],
          )
        ],
      ),
    ),
  );
}