import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/fixture/data/models/match_info.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

Widget eventComponent({required MatchInfo matchInfo}){
  if(matchInfo.type == "card"){
    if(matchInfo.team == "home"){
      if(matchInfo.card == "yellowred"){
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: surfaceColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(matchInfo.pname == null ? "" : matchInfo.pname!)),
              SizedBox(width: 10,),
              Container(height: 24, width: 20, child: Row(
                children: [
                  Expanded(child: Container(color: Colors.yellow,)),
                  Expanded(child: Container(color: Colors.red,)),
                ],
              ),),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: surfaceColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(matchInfo.pname == null ? "" : matchInfo.pname!)),
            SizedBox(width: 10,),
            matchInfo.card == "red" ? Container(height: 24, width: 20, color: dangerColor,) : Container(height: 24, width: 20, color: Colors.yellow,)
          ],
        ),
      );
    } else {
      if(matchInfo.card == "yellowred"){
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: surfaceColor)
          ),
          child: Row(
            children: [
              Container(height: 24, width: 20, child: Row(
                children: [
                  Expanded(child: Container(color: Colors.yellow,)),
                  Expanded(child: Container(color: Colors.red,)),
                ],
              ),),
              SizedBox(width: 10,),
              Flexible(child: Text(matchInfo.pname == null ? "" : matchInfo.pname!)),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: surfaceColor)
        ),
        child: Row(
          children: [
            matchInfo.card == "red" ? Container(height: 24, width: 20, color: dangerColor,) : Container(height: 24, width: 20, color: Colors.yellow,),
            SizedBox(width: 10,),
            Flexible(child: Text(matchInfo.pname == null ? "" : matchInfo.pname!)),
          ],
        ),
      );
    }
  } else if(matchInfo.type == "substitution") {
    if(matchInfo.team == "home"){
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: surfaceColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(matchInfo.player_out_name == null ? "" : matchInfo.player_out_name!)),
                SizedBox(width: 10,),
                Image.asset("images/player_out.png", width: 24, height: 24, fit: BoxFit.fill,),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(matchInfo.player_in_name == null ? "" : matchInfo.player_in_name!)),
                SizedBox(width: 10,),
                Image.asset("images/player_in.png", width: 24, height: 24, fit: BoxFit.fill,),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: surfaceColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("images/player_out.png", width: 24, height: 24, fit: BoxFit.fill,),
                SizedBox(width: 10,),
                Flexible(child: Text(matchInfo.player_out_name == null ? "" : matchInfo.player_out_name!)),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Image.asset("images/player_in.png", width: 24, height: 24, fit: BoxFit.fill,),
                SizedBox(width: 10,),
                Flexible(child: Text(matchInfo.player_in_name == null ? "" : matchInfo.player_in_name!)),
              ],
            ),
          ],
        ),
      );
    }
  } else if(matchInfo.type == "goal"){
    if(matchInfo.team == "home"){
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: surfaceColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(matchInfo.pname == null ? "" : matchInfo.pname!)),
                SizedBox(width: 10,),
                matchInfo.goaltype == "penalty" ? Image.asset("images/goal_pen.png", width: 24, height: 24, fit: BoxFit.fill,) : Iconify(Ph.soccer_ball, color: matchInfo.goaltype == "owngoal" ? dangerColor : primaryColor,)
              ],
            ),
            matchInfo.assistPName == null ? SizedBox() : SizedBox(height: 5,),
            matchInfo.assistPName == null ? SizedBox() : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(matchInfo.assistPName == null ? "null" : matchInfo.assistPName!["pname"])),
                SizedBox(width: 10,),
                Image.asset("images/assist.png", width: 24, height: 17, color: primaryColor, fit: BoxFit.fill,),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: surfaceColor)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                matchInfo.goaltype == "penalty" ? Image.asset("images/goal_pen.png", width: 24, height: 24, fit: BoxFit.fill,) : Iconify(Ph.soccer_ball, color: matchInfo.goaltype == "owngoal" ? dangerColor : primaryColor,),
                SizedBox(width: 10,),
                Flexible(child: Text(matchInfo.pname == null ? "" : matchInfo.pname!)),
              ],
            ),
            matchInfo.assistPName == null ? SizedBox() : Row(
              children: [
                Image.asset("images/assist.png", width: 24, height: 17, color: primaryColor, fit: BoxFit.fill,),
                SizedBox(width: 10,),
                Flexible(child: Text(matchInfo.assistPName == null ? "null" : matchInfo.assistPName!["pname"])),
              ],
            ),
          ],
        ),
      );
    }
  }
  return SizedBox();
}