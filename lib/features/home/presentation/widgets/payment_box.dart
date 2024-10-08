import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget paymentBox({required String title, required double iconHeight, required double iconWidth, required String icon, required bool isSelected, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: (){
      onPressed();
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(icon, fit: BoxFit.fill, width: iconWidth, height: iconHeight,),
                SizedBox(width: 10,),
                Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF000000).withOpacity(0.6)),))
              ],
            ),
          ),
          isSelected ? Container(
            width: 18,
            height: 18,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: primaryColor, width: 1.0),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20)
              ),
            ),
          ) : Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(20)
            )
          )
        ],
      ),
    ),
  );
}