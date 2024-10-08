import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

Widget descriptionTextFormField(
    {required TextEditingController controller,
      required String hintText,
      String? icon, required VoidCallback onInteraction}) {
  return TextFormField(
    controller: controller,
    maxLines: 7,
    onChanged: (value){
      onInteraction();
    },
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      filled: true,
      fillColor: lightPrimary,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: textFontSize2,
        color: textColor,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(textFormFieldRadius),
        borderSide: BorderSide.none
      )
    ),
  );
}
