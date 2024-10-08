import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/screens/player_choice_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/player_choice_captain_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget playerChoiceCaptainsComponent({required BuildContext context, required String position, required List<EntityPlayer?> players, required int value}) {

  Kit kit = Kit();
  final data = Provider.of<SelectedPlayersProvider>(context, listen: false);

  return SizedBox(
    height: 90,
    child: ListView.builder(
        itemCount: players.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {

          String name = "";

          if(players[index] != null){
            String fullName = players[index]!.full_name.trimRight();
            List<String> names = fullName.split(" ");
            name = names.last;
          }

          return players[index]!.isBench == true ? SizedBox() : GestureDetector(
            onTap: (){
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context, builder: (BuildContext context){
                return playerChoiceCaptainModalSheet(player: players[index]!, context: context);
              });
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 43.43,
                        height: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(kit.getKit(team: players[index] == null ? "clubAbbr" : players[index]!.clubAbbr, position: position)),
                                fit: BoxFit.fill)),
                        child: players[index] == null ? Center(child: Icon(Icons.add, color: primaryColor),) : SizedBox(),
                      ),
                      players[index]!.isViceCaptain ? Container(
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
                      players[index]!.isCaptain ? Container(
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
                players[index] == null ? SizedBox() : Container(
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
                ),
              ],
            ),
          );
        }),
  );
}