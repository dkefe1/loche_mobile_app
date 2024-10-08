import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget logoutBox({required String label, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: (){
      onPressed();
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 18),
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
          color: lightPrimary,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Text(label, style: TextStyle(fontSize: 13, color: primaryColor, fontWeight: FontWeight.w600),),
    ),
  );
}