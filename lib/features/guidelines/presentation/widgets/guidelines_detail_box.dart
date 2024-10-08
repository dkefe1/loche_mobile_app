import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

Widget guidelinesDetailBox({required String label, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: (){
      onPressed();
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.07),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: primaryColor, fontWeight: FontWeight.w600),),
          Iconify(MaterialSymbols.chevron_right, color: primaryColor,)
        ],
      ),
    ),
  );
}