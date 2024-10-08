import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/core/services/round_number.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/client_players.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/widgets/bottom_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

bool checkPlayer({required ClientPlayer selectedPlayer, required ClientPlayer player}){

  if(selectedPlayer.position == "Goalkeeper" && player.position != "Goalkeeper"){
    return true;
  }

  if(selectedPlayer.is_bench && player.is_bench){
    return true;
  } else if(!selectedPlayer.is_bench && !player.is_bench){
    return true;
  } else {
    return false;
  }
}

bool isGkCheck({required ClientPlayer selectedPlayer, required ClientPlayer player}){
  if(selectedPlayer.position != "Goalkeeper" && player.position == "Goalkeeper"){
    return true;
  } else {
    return false;
  }
}

Widget playerAvatar({required ClientPlayer player, required BuildContext context, required bool isSwitch}) {

  String fullName = player.full_name.trimRight();
  List<String> names = fullName.split(" ");
  String name = names.last;

  final showSwitch = Provider.of<ClientPlayersProvider>(context, listen: false);
  Kit kit = Kit();
  RoundNumber converter = RoundNumber();

  return GestureDetector(
    onTap: (){
      if(showSwitch.isSwitch){
        int maxForward = 0;
        int maxDefense = 0;
        int maxMidfield = 0;

        if(showSwitch.isSwitchSelected!.id == player.id){
          showSwitch.showSwitch();
          return;
        }

        if(showSwitch.selectedPlayers.contains(showSwitch.isSwitchSelected!) && showSwitch.selectedPlayers.contains(player)){
          showSwitch.showSwitch();
          return;
        }

        for(final player in showSwitch.selectedPlayers){
          if(player.position == "Forward"){
            maxForward++;
          } else if(player.position == "Defender"){
            maxDefense++;
          } else if(player.position == "Midfielder"){
            maxMidfield++;
          }
        }

        if (showSwitch.isSwitchSelected!.position == "Goalkeeper" && showSwitch.isSwitchSelected!.position != player.position) {
          errorFlashBar(context: context, message: "Can not switch a goal keeper with other positions");
          showSwitch.showSwitch();
          return;
        }

        if (player.position == "Goalkeeper" && showSwitch.isSwitchSelected!.position != player.position) {
          errorFlashBar(context: context, message: "Can not switch a goal keeper with other positions");
          showSwitch.showSwitch();
          return;
        }

        if (player.position == "Forward" && showSwitch.isSwitchSelected!.position != "Forward" && maxForward == 1 && !showSwitch.selectedPlayers.contains(showSwitch.isSwitchSelected!)) {
          errorFlashBar(context: context, message: "At least one forward is required");
          showSwitch.showSwitch();
          return;
        }

        if (player.position != "Forward" && showSwitch.isSwitchSelected!.position == "Forward" && maxForward == 1 && !showSwitch.selectedPlayers.contains(player)) {
          errorFlashBar(context: context, message: "At least one forward is required");
          showSwitch.showSwitch();
          return;
        }

        if(player.position == "Midfielder" && showSwitch.isSwitchSelected!.position != "Midfielder" && maxMidfield == 2 && !showSwitch.selectedPlayers.contains(showSwitch.isSwitchSelected!)){
          errorFlashBar(context: context, message: "At least two midfielders are required");
          showSwitch.showSwitch();
          return;
        }

        if(player.position != "Midfielder" && showSwitch.isSwitchSelected!.position == "Midfielder" && maxMidfield == 2 && !showSwitch.selectedPlayers.contains(player)){
          errorFlashBar(context: context, message: "At least two midfielders are required");
          showSwitch.showSwitch();
          return;
        }

        if(player.position == "Defender" && showSwitch.isSwitchSelected!.position != "Defender" && maxDefense == 3 && !showSwitch.selectedPlayers.contains(showSwitch.isSwitchSelected!)){
          errorFlashBar(context: context, message: "At least three defenders are required");
          showSwitch.showSwitch();
          return;
        }

        if(player.position != "Defender" && showSwitch.isSwitchSelected!.position == "Defender" && maxDefense == 3 && !showSwitch.selectedPlayers.contains(player)){
          errorFlashBar(context: context, message: "At least three defenders are required");
          showSwitch.showSwitch();
          return;
        }

        List<ClientPlayer> players = showSwitch.switchPlayers(showSwitch.isSwitchSelected!, player);
        final switchPlayers = BlocProvider.of<SwitchPlayerBloc>(context);
        switchPlayers.add(PatchSwitchPlayerEvent(players[0].pid, players[1].pid));
        showSwitch.showSwitch();
      } else {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context, builder: (BuildContext context){
          return playerModalSheet(player: player, context: context);
        });
      }
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
                width: 32.57,
                height: 45,
                decoration: BoxDecoration(
                  color: showSwitch.isSwitchSelected == player ? Colors.blueAccent : showSwitch.isSwitchSelected == null ? Colors.transparent : checkPlayer(selectedPlayer: showSwitch.isSwitchSelected!, player: player) ? Colors.transparent : isGkCheck(selectedPlayer: showSwitch.isSwitchSelected!, player: player) ? Colors.transparent : isSwitch ? Colors.greenAccent : Colors.transparent,
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
                  Text(converter.round(player.final_fantasy_point), style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),),
                ],
              ),
              player.is_vice_captain ? Column(
                children: [
                  Text(converter.round(player.final_fantasy_point), style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),),
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
                  Text(converter.round(player.final_fantasy_point), style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),),
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