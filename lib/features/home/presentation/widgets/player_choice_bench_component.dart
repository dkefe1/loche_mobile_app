import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/screens/player_choice_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget playerChoiceBenchComponent({required BuildContext context, required String position, required List<EntityPlayer?> players, required int value}) {

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

          return GestureDetector(
            onTap: (){

              if(data.substitutePlayers.contains(players[index])){
                data.removeBenchPlayer(players[index]!);
                return;
              }

              int maxGoalKeeper = 0;
              int maxForward = 0;
              int maxDefense = 0;
              int maxMidfield = 0;

              for(final player in data.substitutePlayers){
                if(player.position == "Forward"){
                  maxForward++;
                } else if(player.position == "Goalkeeper"){
                  maxGoalKeeper++;
                } else if(player.position == "Defender"){
                  maxDefense++;
                } else if(player.position == "Midfielder"){
                  maxMidfield++;
                }
              }

              if(data.substitutePlayers.length == 4){
                errorFlashBar(context: context, message: "Maximum of 4 players allowed in the bench");
                return;
              }

              if(data.substitutePlayers.length == 3 && maxGoalKeeper == 0 && players[index]!.position != "Goalkeeper"){
                errorFlashBar(context: context, message: "One goal keeper is required in the bench");
                return;
              }

              if(maxGoalKeeper == 1 && players[index]!.position == "Goalkeeper"){
                errorFlashBar(context: context, message: "Only one goal keeper allowed in benches");
                return;
              }

              if(maxForward == 2 && players[index]!.position == "Forward"){
                errorFlashBar(context: context, message: "Maximum two forwards allowed in benches");
                return;
              }

              if(maxDefense == 2 && players[index]!.position == "Defender"){
                errorFlashBar(context: context, message: "Maximum two defenders allowed in benches");
                return;
              }

              if(maxMidfield == 3 && players[index]!.position == "Midfielder"){
                errorFlashBar(context: context, message: "Maximum three midfielders allowed in benches");
                return;
              }


              data.addBenchPlayer(players[index]!);
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
                          color: data.substitutePlayers.contains(players[index]) ? Colors.greenAccent : Colors.transparent,
                            image: DecorationImage(
                                image: AssetImage(kit.getKit(team: players[index] == null ? "clubAbbr" : players[index]!.clubAbbr, position: position)),
                                fit: BoxFit.fill)),
                        child: players[index] == null ? Center(child: Icon(Icons.add, color: primaryColor),) : SizedBox(),
                      ),
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
                )
              ],
            ),
          );
        }),
  );
}