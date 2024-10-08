import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ep.dart';

Widget clipBoardWidget(
    {required TextEditingController controller, required VoidCallback onCopyPressed, required VoidCallback onSharePressed}) {
  return TextFormField(
    readOnly: true,
    controller: controller,
    style: TextStyle(color: primaryColor),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      filled: true,
      fillColor: textFormFieldBackgroundColor,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
          borderRadius: BorderRadius.circular(textFormFieldRadius)),
      suffixIcon: Row(
        children: [
          GestureDetector(
            onTap: (){
              onCopyPressed();
            },
            child: Iconify(Ep.copy_document, color: primaryColor,),
          ),
          SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              onSharePressed();
            },
            child: Iconify(Ep.share, color: primaryColor,),
          ),
          SizedBox(width: 10,)
        ],
      ),
      suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 70),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textFormFieldBackgroundColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textFormFieldBackgroundColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textFormFieldBackgroundColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textFormFieldBackgroundColor),
      ),
    ),
  );
}
