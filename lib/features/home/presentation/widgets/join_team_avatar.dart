import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/join_team_modal.dart';
import 'package:flutter/material.dart';

Widget joinTeamPlayerAvatar({required ClientPlayer player, required BuildContext context}) {

  Kit kit = Kit();

  String fullName = player.full_name.trimRight();
  List<String> names = fullName.split(" ");
  String name = names.last;

  return GestureDetector(
    onTap: (){
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context, builder: (BuildContext context){
          return joinTeamModalSheet(player: player, context: context);
        });
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 39.81,
                height: 55,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(kit.getKit(team: player.club, position: player.position)),
                        fit: BoxFit.fill)),
                child: true ? SizedBox() : Center(child: Text("7", style: TextStyle(color: Color(0xFF005FBC), fontSize: 10.42),),),
              ),
              player.is_vice_captain ? Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  "V",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      color: Colors.black),
                ),
              ) : SizedBox(),
              player.is_captain ? Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  "C",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      color: Colors.black),
                ),
              ) : SizedBox(),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          decoration: BoxDecoration(
              color: previewTextBg,
              borderRadius: BorderRadius.circular(5.21)
          ),
          child: Text(
            name,
            style: TextStyle(color: textBlackColor, fontSize: 10.42),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    ),
  );
}