import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/home/data/models/player.dart';
import 'package:fantasy/features/home/presentation/widgets/check_transfer_dialog.dart';
import 'package:flutter/material.dart';

Widget deductPointDialog({required BuildContext context, required VoidCallback onPressed}) {
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
            "4 points are going to be deducted from your total fantasy point, Are you sure you want to transfer players?",
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
                  }, child: Text("No", style: TextStyle(color: textBlackColor),))),
              SizedBox(width: 15,),
              Expanded(child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: dangerColor2
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                    onPressed();
                  }, child: Text("Yes", style: TextStyle(color: onPrimaryColor),))),
            ],
          )
        ],
      ),
    ),
  );
}
