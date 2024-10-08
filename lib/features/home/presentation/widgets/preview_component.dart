import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/home/data/models/player.dart';
import 'package:flutter/material.dart';

Widget previewComponent({required List<Player> players, required double top}) {

  Kit kit = Kit();

  return Padding(
      padding: EdgeInsets.only(top: top),
      child: SizedBox(
        height: 66,
        child: ListView.builder(
            itemCount: players.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 27.08,
                          height: 24.83,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(kit.getKit(team: players[index].club, position: players[index].position)),
                                  fit: BoxFit.fill)),
                          child: Center(child: Text("7", style: TextStyle(color: Color(0xFF005FBC), fontSize: 10.42),),),
                        ),
                        players[index].name == "Beka" ? Container(
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
                        players[index].name == "Nebyu" ? Container(
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
                      players[index].name,
                      style: TextStyle(color: textBlackColor, fontSize: 10.42),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              );
            }),
      )
  );
}