import 'package:another_flushbar/flushbar.dart';
import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget errorFlashBar({required BuildContext context, required String message}) =>
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      message: message,
      duration: Duration(seconds: 3),
      mainButton: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.close, color: primaryColor,)),
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: primaryColor,
      ),
      leftBarIndicatorColor: primaryColor,
    )..show(context);