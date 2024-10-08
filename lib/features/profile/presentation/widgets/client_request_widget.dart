import 'package:flutter/material.dart';

Widget clientRequestWidget({required String label, required Color labelColor}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
    margin: EdgeInsets.only(bottom: 6),
    decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.07),
        borderRadius: BorderRadius.circular(10)
    ),
    child: Text(label, style: TextStyle(fontSize: 13, color: labelColor, fontWeight: FontWeight.w600),),
  );
}