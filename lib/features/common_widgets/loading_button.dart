import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget loadingButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius)
          )
      ),
      child: SizedBox(
        height: buttonFontSize,
        width: buttonFontSize,
        child: CircularProgressIndicator(color: onPrimaryColor,),
      ),
    ),
  );
}