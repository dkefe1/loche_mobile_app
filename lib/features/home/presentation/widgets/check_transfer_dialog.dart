import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/player.dart';
import 'package:fantasy/features/home/presentation/widgets/check_transfer_component.dart';
import 'package:fantasy/features/home/presentation/widgets/check_transfer_component_out.dart';
import 'package:flutter/material.dart';

Widget checkTransferDialog({required BuildContext context, required VoidCallback onPressed, required EntityPlayer playerIn, required ClientPlayer playerOut }) {
  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Flexible(child: checkTransferComponent(playerIn: playerIn, playerOut: playerOut, titleIn: "Player In", titleOut: "Player Out")),
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
                  }, child: Text("Confirm", textAlign: TextAlign.center, style: TextStyle(color: onPrimaryColor),))),
            ],
          )
        ],
      ),
    ),
  );
}
