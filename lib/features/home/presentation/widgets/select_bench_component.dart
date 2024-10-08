import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/widgets/player_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:provider/provider.dart';

Widget selectBenchComponent({required BuildContext context, required String text, required List<EntityPlayer> players}) {

  Kit kit = Kit();
  final data = Provider.of<SelectedPlayersProvider>(context, listen: false);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 12),),
      SizedBox(height: 5,),
      ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: players.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (context) {
                  return playerDetailDialog(player: players[index], context: context);
                });
              },
              child: Container(
                color: Color(0xFF1E727E).withOpacity(0.04),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 41.79,
                    height: 57.74,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(kit.getKit(team: players[index].clubAbbr, position: players[index].position)), fit: BoxFit.fill)
                    ),
                  ),
                  title: Text(players[index].full_name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
                  subtitle: Text(players[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      data.substitutePlayers.contains(players[index]) ? GestureDetector(
                        onTap: () {
                          data.removeBenchPlayer(players[index]);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Iconify(Ic.round_done_all, color: onPrimaryColor,),
                        ),
                      ) :  GestureDetector(
                        onTap: () {

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

                          if(data.substitutePlayers.length == 3 && maxGoalKeeper == 0 && players[index].position != "Goalkeeper"){
                            errorFlashBar(context: context, message: "One goal keeper is required in the bench");
                            return;
                          }

                          if(maxGoalKeeper == 1 && players[index].position == "Goalkeeper"){
                            errorFlashBar(context: context, message: "Only one goal keeper allowed in benches");
                            return;
                          }

                          if(maxForward == 2 && players[index].position == "Forward"){
                            errorFlashBar(context: context, message: "Maximum two forwards allowed in benches");
                            return;
                          }

                          if(maxDefense == 2 && players[index].position == "Defender"){
                            errorFlashBar(context: context, message: "Maximum two defenders allowed in benches");
                            return;
                          }

                          if(maxMidfield == 3 && players[index].position == "Midfielder"){
                            errorFlashBar(context: context, message: "Maximum three midfielders allowed in benches");
                            return;
                          }


                          data.addBenchPlayer(players[index]);
                        },
                        child: Iconify(MaterialSymbols.add_circle_outline_rounded, color: primaryColor, size: 30,),
                      ),
                      SizedBox(width: 5,)
                    ],
                  ),
                ),
              ),
            );
          })
    ],
  );
}