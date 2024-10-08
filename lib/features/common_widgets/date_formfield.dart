import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

Widget dateFormField({required TextEditingController controller, required String hintText, required String icon, required VoidCallback onPressed, required VoidCallback onInteraction}) {
  return GestureDetector(
    onTap: (){
      onPressed();
      onInteraction();
    },
    child: Theme(
      data: ThemeData().copyWith(disabledColor: textBlackColor),
      child: TextFormField(
        controller: controller,
        enabled: false,
        onChanged: (value){
          onInteraction();
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          filled: true,
          fillColor: textFormFieldBackgroundColor,
          hintText: "${hintText}",
          labelStyle: TextStyle(color: textBlackColor, fontSize: textFontSize2),
          hintStyle: TextStyle(
            fontSize: textFontSize2,
            color: textColor,
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: textFormFieldBackgroundColor),
              borderRadius: BorderRadius.circular(textFormFieldRadius)),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Iconify(
              icon,
              color: textColor,
            ),
          ),
          suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 40),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textFormFieldBackgroundColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textFormFieldBackgroundColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dangerColor),
          ),
        ),
      ),
    ),
  );
}