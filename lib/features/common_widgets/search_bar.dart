import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class SearchBarWidget extends StatefulWidget {

  TextEditingController controller;
  String hintText, icon;
  VoidCallback onChanged;
  VoidCallback clear;

  SearchBarWidget({super.key, required this.controller, required this.hintText, required this.icon, required this.onChanged, required this.clear});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {

  bool isValueEmpty = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value){
        widget.onChanged();
        if(value.isEmpty) {
          setState(() {
            isValueEmpty = true;
          });
        } else {
          setState(() {
            isValueEmpty = false;
          });
        }
      },
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
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(searchBarRadius)),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 20, right: 10),
          child: Iconify(
            widget.icon,
            color: primaryColor,
          ),
        ),
        prefixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 60),
        suffixIcon: isValueEmpty ? SizedBox() :  GestureDetector(
          onTap: (){
            widget.clear();
            setState(() {
              isValueEmpty = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.close, color: primaryColor,),
          ),
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 40),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
            borderRadius: BorderRadius.circular(searchBarRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(searchBarRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(searchBarRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
          borderRadius: BorderRadius.circular(searchBarRadius),
        ),
      ),
    );
  }
}
