import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget otpTextFormField({required BuildContext context, required TextEditingController pinController}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: SizedBox(
      height: 60,
      child: TextFormField(
        controller: pinController,
        autofocus: true,
        onSaved: (value){},
        onChanged: (value){
          if(value.length == 1){
            FocusScope.of(context).nextFocus();
          }
        },
        style: TextStyle(
          color: textBlackColor,
          fontSize: 28
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        textAlign: TextAlign.center,
        // textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          filled: true,
          fillColor: textFormFieldBackgroundColor,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: textFormFieldBackgroundColor),
              borderRadius: BorderRadius.circular(textFormFieldRadius)),
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
      ),
    ),
  );
}