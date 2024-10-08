import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget submitButton({required VoidCallback onPressed, required String text, required bool disabled}) {
  return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius)
        )
      ),
      child: Text(text, style: TextStyle(color: onPrimaryColor, fontSize: buttonFontSize),),
  );
}
