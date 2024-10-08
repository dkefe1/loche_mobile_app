import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

Widget numberTextFormField(
    {required TextEditingController controller,
      required String hintText,
      required String icon,
      String? iconPath,
      required bool autoFocus, required VoidCallback onInteraction}) {
  return TextFormField(
    autofocus: autoFocus,
    controller: controller,
    onChanged: (value){
      onInteraction();
    },
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      filled: true,
      fillColor: textFormFieldBackgroundColor,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: textFontSize2,
        color: textColor,
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
          borderRadius: BorderRadius.circular(textFormFieldRadius)),
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: iconPath == null ? Iconify(
          icon,
          color: textColor,
        ) : Image.asset(iconPath, width: 30, height: 30, fit: BoxFit.fill, color: Colors.grey,),
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
        borderSide: BorderSide(color: textFormFieldBackgroundColor),
      ),
    ),
  );
}
