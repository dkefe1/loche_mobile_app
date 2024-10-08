import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget playerChoiceComponent({required String text, required List<EntityPlayer> players, required int playerIndex}) {

  Kit kit = Kit();

  return Consumer<SelectedPlayersProvider>(
      builder: (context, data, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Players ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
                Row(
                  children: [
                    Text("Points", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
                    SizedBox(width: 30,),
                    Text("Price ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
                  ],
                ),
              ],
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
                itemCount: players.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return data.allPlayers.any((player) => player?.pid == players[index].pid) ? SizedBox() : GestureDetector(
                    onTap: (){
                      bool isGkSelected = data.selectedPlayers.any((player) => player.position == "Goalkeeper");
                      bool isForSelected = data.selectedPlayers.any((player) => player.position == "Forward");
                      int maxGoalKeeper = 0;
                      int maxForward = 0;
                      int maxDefense = 0;
                      int maxMidfield = 0;

                      if(data.allPlayers[playerIndex] != null){
                        data.removePlayer(data.allPlayers[playerIndex]!);
                        data.increaseCredit(double.parse(data.allPlayers[playerIndex]!.price));
                      }

                      for(final player in data.selectedPlayers){
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

                      bool hasMoreThan3Players(List selectedClubs) {
                        Map<String, int> clubCount = {};

                        for (var club in selectedClubs) {
                          clubCount[club] = (clubCount[club] ?? 0) + 1;
                          if (clubCount[club]! > 2 && players[index].clubAbbr == club) {
                            return true;
                          }
                        }

                        return false;
                      }

                      if (data.selectedPlayers.length == 15) {
                        errorFlashBar(context: context, message: "Maximum of 15 players allowed");
                        return;
                      }

                      if (maxGoalKeeper > 1 && players[index].position == "Goalkeeper") {
                        errorFlashBar(context: context, message: "Maximum of 2 goalkeepers allowed");
                        return;
                      }

                      if (maxForward > 2 && players[index].position == "Forward") {
                        errorFlashBar(context: context, message: "Maximum of 3 forwards allowed");
                        return;
                      }

                      if (maxDefense > 4 && players[index].position == "Defender") {
                        errorFlashBar(context: context, message: "Maximum of 5 defenders allowed");
                        return;
                      }

                      if (maxMidfield > 4 && players[index].position == "Midfielder") {
                        errorFlashBar(context: context, message: "Maximum of 5 midfielders allowed");
                        return;
                      }

                      if (hasMoreThan3Players(data.selectedClubs)) {
                        errorFlashBar(context: context, message: "A maximum of 3 players from each team allowed");
                        return;
                      }

                      if (double.parse(players[index].price) > data.credit) {
                        errorFlashBar(context: context, message: "You don't have the credit to select this player");
                        return;
                      }

                      data.addPlayer(players[index]);
                      data.decreaseCredit(double.parse(players[index].price));
                      data.replacePlayer(playerIndex, players[index]);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        color: data.selectedPlayers.contains(players[index]) ? Color(0xFF1E727E).withOpacity(0.5) : Color(0xFF1E727E).withOpacity(0.04),
                        child: ListTile(
                          leading: Container(
                            width: 41.79,
                            height: 57.74,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage(kit.getKit(team: players[index].clubAbbr, position: players[index].position)), fit: BoxFit.fill)
                            ),
                          ),
                          title: Text(players[index].full_name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(players[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
                              players[index].transfer_radar ? Text("Player in loan/transfer radar", style: TextStyle(color: dangerColor2, fontSize: 10, fontWeight: FontWeight.w400),) : SizedBox(),
                              players[index].is_injuried || players[index].is_banned ? Text("Player in banned/injured list", style: TextStyle(color: dangerColor2, fontSize: 10, fontWeight: FontWeight.w400),) : SizedBox(),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(players[index].point.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
                              SizedBox(width: 20,),
                              SizedBox(
                                  width: 30,
                                  child: Text(players[index].price.toString(), textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
          ],
        );
      }
  );
}