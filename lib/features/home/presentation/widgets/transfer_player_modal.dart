import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/screens/transfer_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/bottom_modal_component.dart';
import 'package:fantasy/features/home/presentation/widgets/clientPlayerDetailDialog.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget transferPlayerModalSheet({required ClientPlayer player, required BuildContext context, required List<String> myPlayersId, required String budget, required List<MatchModel> matches}) {

  String? against;
  String? spot;

  for(int i =0; i<matches.length; i++){
    if(matches[i].home.abbr == player.club){
      against = matches[i].away.abbr;
      spot = "H";
      break;
    } else if(matches[i].away.abbr == player.club){
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
            Navigator.pop(context);
            showDialog(context: context, builder: (context) {
              return clientPlayerDetailDialog(player: player, context: context);
            });
          }),
          SizedBox(height: 15,),
          bottomModalComponent(icon: Tabler.switch_horizontal, value: "Transfer", onPressed: (){
            final transfer = Provider.of<SelectedPlayersProvider>(context, listen: false);
            transfer.saveTransferredPlayer(player);
            int tab = 0;
            if(player.position == "Goalkeeper"){
              tab = 0;
            } else if(player.position == "Defender"){
              tab = 1;
            } else if(player.position == "Midfielder"){
              tab = 2;
            } else {
              tab = 3;
            }
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen(myPlayersId: myPlayersId, budget: budget, tab: tab, player: player, matches: matches,)));
          }),
          SizedBox(height: 15,),
        ],
      ),
    ),
  );
}