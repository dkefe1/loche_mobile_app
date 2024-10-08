import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/guidelines/data/models/faq_model.dart';
import 'package:flutter/material.dart';

Widget faqComponent({required String title, required List<FAQModel> contents}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 12),
      ),
      SizedBox(height: 10,),
      ListView.builder(
          itemCount: contents.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index){
            return Container(
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                    color: Color(0xFF1E727E).withOpacity(0.07),
                    borderRadius: BorderRadius.circular(7)),
                child: Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: index == 0,
                    iconColor: primaryColor,
                    collapsedIconColor: primaryColor,
                    title: Text(
                      contents[index].title,
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
                          contents[index].content,
                          style: TextStyle(
                              fontSize: textFontSize
                          ),),
                      )
                    ],
                  ),
                ));
          })
    ],
  );
}