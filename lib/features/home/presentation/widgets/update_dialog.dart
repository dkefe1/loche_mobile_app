import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget updateAppDialog({required BuildContext context, required VoidCallback onPressed}) {
  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10,),
          Text(
            "Exciting News! Update is now available. Get the latest version of our app to experience new features and improved performance. Update today!",
            textAlign: TextAlign.center,
            style:
            TextStyle(fontSize: textFontSize2, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 30,),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 10)
                ),
                onPressed: (){
                  onPressed();
                }, child: Text("Update", style: TextStyle(color: onPrimaryColor, fontSize: 16),)),
          )
        ],
      ),
    ),
  );
}
