import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget logoutDialog({required BuildContext context, required VoidCallback onPressed}) {
  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: SizedBox(
      height: 142,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text(
              "Are you sure you want to logout?",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: textFontSize2, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD9D9D9)
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Cancel", style: TextStyle(color: textBlackColor),))),
                SizedBox(width: 15,),
                Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: dangerColor2
                    ),
                    onPressed: (){
                      onPressed();
                    }, child: Text("Logout", style: TextStyle(color: onPrimaryColor),))),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
