import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget teamRemovalAlert({required BuildContext context, required VoidCallback onPressed}) {
  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: SizedBox(
      height: 162,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text(
              "Your data will be lost, Are you sure you want to go back ?",
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
                    }, child: Text("Yes", style: TextStyle(color: onPrimaryColor),))),
              ],
            )
          ],
        ),
      ),
    ),
  );
}