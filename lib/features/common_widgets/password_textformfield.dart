import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

class PasswordTextFormField extends StatefulWidget {

  TextEditingController passwordController;
  String hintText;
  bool autoFocus;
  VoidCallback onInteraction;
  PasswordTextFormField({required this.passwordController, required this.hintText, required this.autoFocus, required this.onInteraction});

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {

  bool _secureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus,
      controller: widget.passwordController,
      onChanged: (value) {
        widget.onInteraction();
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(4),
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        filled: true,
        fillColor: textFormFieldBackgroundColor,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: textFontSize2,
          color: textColor,
        ),
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
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  _secureText = !_secureText;
                });
              },
              child: Iconify(
                  _secureText == true ? Ph.eye : Ph.eye_slash,
                  color: textColor,
                ),
            ),
          ),
        suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 40),
      ),
      obscureText: _secureText,
    );
  }
}