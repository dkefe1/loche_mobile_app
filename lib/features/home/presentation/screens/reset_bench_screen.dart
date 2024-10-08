import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/app_header3.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/screens/reset_captains_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/player_choice_bench_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetTeamBenchScreen extends StatelessWidget {

  const ResetTeamBenchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
    GestureDetector(
        onPanUpdate: (details) async {
          if (details.delta.dx > 30) {
            final data = Provider.of<SelectedPlayersProvider>(context, listen: false);
            data.removeAllBenchPlayers();
            Navigator.of(context).pop();
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: buildInitialInput(),
        )
    )
        : WillPopScope(
      onWillPop: () async {
        final data = Provider.of<SelectedPlayersProvider>(context, listen: false);
        data.removeAllBenchPlayers();
        return true;
      },
      child: buildInitialInput(),
    );
  }

  Widget buildInitialInput(){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<SelectedPlayersProvider>(builder: (context, data, child) {

        List<EntityPlayer?> gkPlayers = data.allPlayers.getRange(0, 2).toList();
        List<EntityPlayer?> defPlayers = data.allPlayers.getRange(2, 7).toList();
        List<EntityPlayer?> midPlayers = data.allPlayers.getRange(7, 12).toList();
        List<EntityPlayer?> forPlayers = data.allPlayers.getRange(12, 15).toList();

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
          child: Column(
            children: [
              appHeader3(
                  title: "Select Your Bench",
                  budget:
                  data.credit.toStringAsFixed(1), desc: "Here is the preview of your team with the selected players."),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(defaultBorderRadius))),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/pitch.png"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 20,),
                          playerChoiceBenchComponent(context: context, players: gkPlayers, position: "Goalkeeper", value: 0),
                          playerChoiceBenchComponent(context: context, players: defPlayers, position: "Defender", value: 2),
                          playerChoiceBenchComponent(context: context, players: midPlayers, position: "Midfielder", value: 7),
                          playerChoiceBenchComponent(context: context, players: forPlayers, position: "Forward", value: 12),
                          SizedBox(height: 10,)
                        ],),
                    ),
                  )),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15, 20, 15, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: (){
                            final data = Provider.of<SelectedPlayersProvider>(context, listen: false);
                            data.removeAllBenchPlayers();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD9D9D9),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                            ),
                          ),
                          child: Text("Back", style: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.w500),)),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: data.substitutePlayers.length != 4 ? null : (){
                            if(data.substitutePlayers.length != 4) {
                              errorFlashBar(context: context, message: "Please select 4 bench players");
                              return;
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResetTeamCaptainsScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                            ),
                          ),
                          child: Text("Next", style: TextStyle(color: data.selectedPlayers.length != 15 ? Color(0xFFA7A7A7) : onPrimaryColor, fontSize: 18, fontWeight: FontWeight.w500),)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
