import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/success_flashbar.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/home/data/models/client_players.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/data/models/transfer_player.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/widgets/bottom_modal_component.dart';
import 'package:fantasy/features/home/presentation/widgets/check_transfer_dialog.dart';
import 'package:fantasy/features/home/presentation/widgets/player_detail_dialog.dart';
import 'package:fantasy/features/profile/data/models/scout.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:provider/provider.dart';

Widget transferModalSheet({required EntityPlayer player, required BuildContext context, required num budget, required List<MatchModel> matches}) {

  String? against;
  String? spot;

  for(int i =0; i<matches.length; i++){
    if(matches[i].home.abbr == player.clubAbbr){
      against = matches[i].away.abbr;
      spot = "H";
      break;
    } else if(matches[i].away.abbr == player.clubAbbr){
      against = matches[i].home.abbr;
      spot = "A";
      break;
    }
  }

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
          bottomModalComponent(icon: Ion.md_information, value: "Player Information", onPressed: (){
            showDialog(context: context, builder: (context) {
              return playerDetailDialog(player: player, context: context);
            });
          }),
          SizedBox(height: 15,),
          BlocConsumer<PostScoutBloc, PostScoutState>(builder: (_, state){
            if(state is PostScoutLoadingState){
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white,),
                  ),
                  SizedBox(width: 15,),
                  Text("Add To Scout", style: TextStyle(color: Colors.white, fontSize: 16),)
                ],
              );
            }
            return bottomModalComponent(icon: GameIcons.binoculars, value: "Add To Scout", onPressed: (){
              final postScout = BlocProvider.of<PostScoutBloc>(context);
              postScout.add(CreateScoutEvent(Scout(player_id: player.pid.toString(), player_name: player.full_name, player_number: player.pid.toString(), position: player.position, team: player.clubAbbr, club_logo: player.club_logo)));
            });
          }, listener: (_, state){
            if (state is PostScoutSuccessfulState) {
              final getScouts = BlocProvider.of<ScoutsBloc>(context);
              getScouts.add(GetAllScoutsEvent());
              successFlashBar(context: context, message: "Successfully added player to scouts");
            } else if (state is PostScoutFailedState) {
              errorFlashBar(context: context, message: state.error);
            }
          }),
          SizedBox(height: 15,),
          bottomModalComponent(icon: Tabler.switch_horizontal, value: "Transfer", onPressed: (){
            final transfer = Provider.of<SelectedPlayersProvider>(context, listen: false);
            final transferClient = Provider.of<ClientPlayersProvider>(context, listen: false);
            if(transfer.transferredPlayer!.position != player.position){
              errorFlashBar(context: context, message: "Can not transfer players of different positions");
              return;
            }

            if(num.parse((num.parse(player.price) - transfer.transferredPlayer!.price).toStringAsFixed(1)) > budget){
              errorFlashBar(context: context, message: "You don't have enough credit");
              return;
            }

            List hasMoreThan3Players() {
              Map<String, int> clubOccurrences = {};

              if(transfer.transferredPlayer!.club == player.clubAbbr){
                return [];
              }

              for (var player in transferClient.allPlayers) {
                clubOccurrences[player.club] = (clubOccurrences[player.club] ?? 0) + 1;
              }

              List exceededClubList = [];

              clubOccurrences.forEach((key, value) {
                if(value >= 3){
                  exceededClubList.add(key);
                }
              });

              print("DDDDDDDDDDDDDDDD");
              print(exceededClubList);

              return exceededClubList;
            }

            if (hasMoreThan3Players().contains(player.clubAbbr)) {
              errorFlashBar(context: context, message: "A maximum of 3 players from each team allowed");
              return;
            }

            List<String> allPlayersId = [];
            for(int i=0; i<transferClient.allPlayers.length; i++){
              allPlayersId.add(transferClient.allPlayers[i].pid);
            }

            if(allPlayersId.contains(player.pid)){
              errorFlashBar(context: context, message: "Player already in the team");
              return;
            }

            // if(transfer.deleteLater){
            //   showDialog(context: context, builder: (BuildContext context){
            //     return deductPointDialog(context: context, onPressed: (){
            //       print("deduct a point");
            //       showDialog(context: context, builder: (BuildContext context){
            //         return checkTransferDialog(context: context, onPressed: (){
            //           transfer.transferPlayers(player);
            //           transfer.deleteLaterFunction();
            //           Navigator.pop(context);
            //           Navigator.pop(context);
            //           Navigator.pop(context);
            //         }, playerIn: player, playerOut: transfer.transferredPlayer!);
            //       });
            //     });
            //   });
            // } else {
            //   showDialog(context: context, builder: (BuildContext context){
            //     return checkTransferDialog(context: context, onPressed: (){
            //       transfer.transferPlayers(player);
            //       transfer.deleteLaterFunction();
            //       Navigator.pop(context);
            //       Navigator.pop(context);
            //       Navigator.pop(context);
            //     }, playerIn: player, playerOut: transfer.transferredPlayer!);
            //   });
            // }

            showDialog(context: context, builder: (BuildContext context){
              return checkTransferDialog(context: context, onPressed: (){
                // transfer.transferPlayers(player);
                final transferPlayers = BlocProvider.of<TransferPlayerBloc>(context);
                transferPlayers.add(PatchTransferPlayerEvent(transfer.transferredPlayer!.pid, TransferPlayerModel(pid: player.pid, price: num.parse(player.price), position: player.position, club: player.clubAbbr, full_name: player.full_name, club_logo: player.club_logo)));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }, playerIn: player, playerOut: transfer.transferredPlayer!);
            });
          }),
          SizedBox(height: 15,),
        ],
      ),
    ),
  );
}