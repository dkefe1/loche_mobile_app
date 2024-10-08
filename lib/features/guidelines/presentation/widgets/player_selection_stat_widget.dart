import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget clientPlayerSelectionComponent({required String label, required String value}){
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),)),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(value.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),),
          )),
        ],
      ),
      SizedBox(height: 5,),
      Divider(color: dividerColor, thickness: 1.0,),
      SizedBox(height: 10,),
    ],
  );
}