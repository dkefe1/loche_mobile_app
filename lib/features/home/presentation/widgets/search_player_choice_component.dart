import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/widgets/player_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:provider/provider.dart';

Widget playerChoiceSearchWidget({required List<EntityPlayer> searchedPlayers, required int playerIndex}) {

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
                    Text("Price ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
                    Text("(${data.credit.toStringAsFixed(1)} LC)", style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w400),),
                  ],
                ),
              ],
            ),
            ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: searchedPlayers.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return data.allPlayers.any((player) => player?.pid == searchedPlayers[index].pid) ? SizedBox() : GestureDetector(
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
                          if (clubCount[club]! > 2 && searchedPlayers[index].clubAbbr == club) {
                            return true;
                          }
                        }

                        return false;
                      }

                      if (data.selectedPlayers.length == 15) {
                        errorFlashBar(context: context, message: "Maximum of 15 players allowed");
                        return;
                      }

                      if (maxGoalKeeper > 1 && searchedPlayers[index].position == "Goalkeeper") {
                        errorFlashBar(context: context, message: "Maximum of 2 goalkeepers allowed");
                        return;
                      }

                      if (maxForward > 2 && searchedPlayers[index].position == "Forward") {
                        errorFlashBar(context: context, message: "Maximum of 3 forwards allowed");
                        return;
                      }

                      if (maxDefense > 4 && searchedPlayers[index].position == "Defender") {
                        errorFlashBar(context: context, message: "Maximum of 5 defenders allowed");
                        return;
                      }

                      if (maxMidfield > 4 && searchedPlayers[index].position == "Midfielder") {
                        errorFlashBar(context: context, message: "Maximum of 5 midfielders allowed");
                        return;
                      }

                      if (hasMoreThan3Players(data.selectedClubs)) {
                        errorFlashBar(context: context, message: "A maximum of 3 players from each team allowed");
                        return;
                      }

                      if (double.parse(searchedPlayers[index].price) > data.credit) {
                        errorFlashBar(context: context, message: "You don't have the credit to select this player");
                        return;
                      }

                      print(playerIndex);
                      data.addPlayer(searchedPlayers[index]);
                      data.decreaseCredit(double.parse(searchedPlayers[index].price));
                      data.replacePlayer(playerIndex, searchedPlayers[index]);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        color: data.selectedPlayers.contains(searchedPlayers[index]) ? Color(0xFF1E727E).withOpacity(0.5) : Color(0xFF1E727E).withOpacity(0.04),
                        child: ListTile(
                          leading: Container(
                            width: 41.79,
                            height: 57.74,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage(kit.getKit(team: searchedPlayers[index].clubAbbr, position: searchedPlayers[index].position)), fit: BoxFit.fill)
                            ),
                          ),
                          title: Text(searchedPlayers[index].full_name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(searchedPlayers[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
                              searchedPlayers[index].transfer_radar ? Text("Player in loan/transfer radar", style: TextStyle(color: dangerColor2, fontSize: 10, fontWeight: FontWeight.w400),) : SizedBox(),
                              searchedPlayers[index].is_injuried || searchedPlayers[index].is_banned ? Text("Player in banned/injured list", style: TextStyle(color: dangerColor2, fontSize: 10, fontWeight: FontWeight.w400),) : SizedBox(),
                            ],
                          ),
                          trailing: Text(searchedPlayers[index].price.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
                        ),
                      ),
                    ),
                  );
                })
          ],
        );
      }
  );;
}