import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

Widget phoneTextFormField(
    {required TextEditingController controller,
    required String hintText,
    required String icon,
    required bool autoFocus, required VoidCallback onInteraction, required bool isEnabled}) {
  return Row(
    children: [
      Container(
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: textFormFieldBackgroundColor,
            border: Border.all(color: textFormFieldBackgroundColor),
            borderRadius: BorderRadius.circular(textFormFieldRadius),
        ),
        child: Text(
          "+251",
          style: TextStyle(
            fontSize: textFontSize2,
            fontWeight: FontWeight.bold,
            color: textBlackColor,
          ),
        ),
      ),
      Expanded(
        child: TextFormField(
          enabled: isEnabled,
          autofocus: autoFocus,
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            LengthLimitingTextInputFormatter(9),
          ],
          onChanged: (value){
            onInteraction();
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            filled: true,
            fillColor: textFormFieldBackgroundColor,
            hintText: "${hintText}",
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
    ],
  );
}
