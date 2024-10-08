import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/player.dart';
import 'package:flutter/material.dart';

Widget previewComponent3({required List<EntityPlayer> players}) {

  Kit kit = Kit();

  return SizedBox(
    height: 74,
    child: ListView.builder(
        itemCount: players.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {

          String fullName = players[index].full_name.trimRight();
          List<String> names = fullName.split(" ");
          String name = names.last;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 32.8,
                      height: 45,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(kit.getKit(team: players[index].clubAbbr, position: players[index].position)),
                              fit: BoxFit.fill)),
                    ),
                    players[index].isViceCaptain ? Container(
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
                    players[index].isCaptain ? Container(
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
          );
        }),
  );
}