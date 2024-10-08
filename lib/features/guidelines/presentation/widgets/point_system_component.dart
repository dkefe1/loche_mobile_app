import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/guidelines/data/models/point_system_model.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget pointSystemComponent({required String title, required List<PointSystemModel> contents, required VoidCallback onPressed}) {
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
                iconColor: primaryColor,
                collapsedIconColor: primaryColor,
                onExpansionChanged: (value) {
                  contents[index].isExpanded = !contents[index].isExpanded;
                  onPressed();
                },
                title: Text(
                  contents[index].name,
                  style: TextStyle(
                      fontSize: textFontSize, color: textBlackColor, fontWeight: FontWeight.w600),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${title == AppLocalizations.of(context)!.negative_points ? "-" : "+"}${contents[index].point}pt", style: TextStyle(color: title == AppLocalizations.of(context)!.negative_points ? Color(0xFFFF3232) : Color(0xFF00BC35), fontWeight: FontWeight.w700, fontSize: 13),),
                    SizedBox(width: 10,),
                    contents[index].isExpanded ? Iconify(MaterialSymbols.keyboard_arrow_up, color: primaryColor, size: 25,) : Iconify(MaterialSymbols.keyboard_arrow_down, color: primaryColor, size: 25,),
                  ],
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                    ),
                    child: Text(
                      contents[index].value,
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