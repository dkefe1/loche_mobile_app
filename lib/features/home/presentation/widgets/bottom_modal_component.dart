import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

Widget bottomModalComponent({required String icon, required String value, required VoidCallback onPressed}){
  return GestureDetector(
    onTap: (){
      onPressed();
    },
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(100)
            ),
            child: Center(child: icon == "C" || icon == "V" ? Text(icon, style: TextStyle(color: Colors.white, fontSize: 14),) : Iconify(icon, color: Colors.white, size: 22,))),
        SizedBox(width: 15,),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 16),)
      ],
    ),
  );
}