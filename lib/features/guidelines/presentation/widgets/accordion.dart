import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

Widget faqAccordionBox({required String question, required String answer, required bool expanded}) {
  return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Color(0xFF16A085).withOpacity(0.1),
          borderRadius: BorderRadius.circular(7)),
      child: ExpansionTile(
        initiallyExpanded: expanded,
        iconColor: primaryColor,
        collapsedIconColor: primaryColor,
        title: Text(
          question,
          style: TextStyle(
              fontSize: textFontSize, color: textBlackColor, fontWeight: FontWeight.w600),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Text(
              answer,
              style: TextStyle(
                  fontSize: textFontSize
              ),),
          )
        ],
      ));
}