import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/core/services/round_number.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/joined_player_modal.dart';
import 'package:flutter/material.dart';

Widget joinedPlayerAvatar({required ClientPlayer player, required BuildContext context}) {

  String fullName = player.full_name.trimRight();
  List<String> names = fullName.split(" ");
  String name = names.last;

  Kit kit = Kit();
  RoundNumber converter = RoundNumber();

  return GestureDetector(
    onTap: (){
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context, builder: (BuildContext context){
        return joinedPlayerModalSheet(player: player, context: context);
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
                    color: Colors.transparent,
                    image: DecorationImage(
                        image: AssetImage(kit.getKit(team: player.club, position: player.position)),
                        fit: BoxFit.fill)),
              ),
              (player.is_vice_captain || player.is_captain) ? SizedBox() : Column(
                children: [
                  player.is_switched ? Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3)),
                    child: Image.asset("images/switch.png", width: 17, height: 17, fit: BoxFit.fill,),
                  ) : SizedBox(),
                  Text(converter.round(player.final_fantasy_point), style: TextStyle(color: Colors.white),),
                ],
              ),
              player.is_vice_captain ? Column(
                children: [
                  Text(converter.round(player.final_fantasy_point), style: TextStyle(color: Colors.white),),
                  Container(
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
                  ),
                ],
              ) : SizedBox(),
              player.is_captain ? Column(
                children: [
                  Text(converter.round(player.final_fantasy_point), style: TextStyle(color: Colors.white),),
                  Container(
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
                  ),
                ],
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