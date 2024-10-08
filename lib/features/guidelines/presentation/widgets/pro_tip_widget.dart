import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget proTipWidget({required String value, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor)),
    child: RichText(
        text: TextSpan(
            text: AppLocalizations.of(context)!.pro_tip,
            style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14, wordSpacing: 1.5), children: [
                  TextSpan(text: value, style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w400, fontSize: 14, wordSpacing: 1.5))
        ])),
  );
}
