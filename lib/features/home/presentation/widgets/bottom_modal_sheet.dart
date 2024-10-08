import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/client_players.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/widgets/bottom_modal_component.dart';
import 'package:fantasy/features/home/presentation/widgets/clientPlayerDetailDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget playerModalSheet({required ClientPlayer player, required BuildContext context}) {

  String? against;
  String? spot;

  // for(int i =0; i<matches.length; i++){
  //   if(matches[i].home.abbr == player.club){
  //     against = matches[i].away.abbr;
  //     spot = "H";
  //     break;
  //   } else if(matches[i].away.abbr == player.club){
  //     against = matches[i].home.abbr;
  //     spot = "A";
  //     break;
  //   }
  // }

  return IntrinsicHeight(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: modalBottomColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(60))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: SizedBox(width: 80, child: Divider(color: Colors.white, thickness: 3.0,),),),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(60)
                ),
                child: Text(player.position == "Goalkeeper" ? "GK" : player.position.substring(0, 3).toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
              ),
              SizedBox(width: 10,),
              Flexible(child: Text(player.full_name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16, overflow: TextOverflow.ellipsis),)),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(player.price.toString(), style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600, fontSize: 14),),
              ),
              SizedBox(width: 10,),
              (against == null || spot == null) ? SizedBox() : Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(60)
                ),
                child: Text("$against($spot)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12),),
              ),
            ],
          ),
          SizedBox(height: 20,),
          bottomModalComponent(icon: Ion.md_information, value: AppLocalizations.of(context)!.player_information, onPressed: (){
            Navigator.pop(context);
            showDialog(context: context, builder: (context) {
              return clientPlayerDetailDialog(player: player, context: context);
            });
          }),
          SizedBox(height: 15,),
          bottomModalComponent(icon: Tabler.switch_horizontal, value: AppLocalizations.of(context)!.switch_player, onPressed: (){
            final showSwitch = Provider.of<ClientPlayersProvider>(context, listen: false);
            showSwitch.showSwitch();
            showSwitch.showSwitchSelectedPlayer(player);
            Navigator.pop(context);
          }),
          player.is_bench ? SizedBox() : player.is_captain ? SizedBox() : SizedBox(height: 15,),
          player.is_bench ? SizedBox() : player.is_captain ? SizedBox() : bottomModalComponent(icon: "C", value: AppLocalizations.of(context)!.make_captain, onPressed: (){
            final swapProvider = Provider.of<ClientPlayersProvider>(context, listen: false);
            if(player.is_bench){
              errorFlashBar(context: context, message: "Bench player can not be a captain");
              return;
            }
            ClientPlayer? playerToBeOut;
            for(int i =0; i<swapProvider.allPlayers.length; i++){
              if(swapProvider.allPlayers[i].is_captain){
                playerToBeOut = swapProvider.allPlayers[i];
                break;
              }
            }
            final swapPlayers = BlocProvider.of<SwapPlayerBloc>(context);
            swapPlayers.add(PatchSwapPlayerEvent(player.pid, playerToBeOut!.pid));
            Navigator.pop(context);
          }),
          SizedBox(height: 15,),
          player.is_bench ? SizedBox() : player.is_vice_captain ? SizedBox() : bottomModalComponent(icon: "V", value: AppLocalizations.of(context)!.make_vice_captain, onPressed: (){
            final swapProvider = Provider.of<ClientPlayersProvider>(context, listen: false);
            if(player.is_bench){
              errorFlashBar(context: context, message: "Bench player can not be a vice captain");
              return;
            }
            ClientPlayer? playerToBeOut;
            for(int i =0; i<swapProvider.allPlayers.length; i++){
              if(swapProvider.allPlayers[i].is_vice_captain){
                playerToBeOut = swapProvider.allPlayers[i];
                break;
              }
            }
            final swapPlayers = BlocProvider.of<SwapPlayerBloc>(context);
            swapPlayers.add(PatchSwapPlayerEvent(player.pid, playerToBeOut!.pid));
            Navigator.pop(context);
          }),
          player.is_bench ? SizedBox() : player.is_vice_captain ? SizedBox() : SizedBox(height: 15,),
        ],
      ),
    ),
  );
}