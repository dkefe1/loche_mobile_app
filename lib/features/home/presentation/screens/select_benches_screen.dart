import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/create_team_model.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/screens/create_captain_screen2.dart';
import 'package:fantasy/features/home/presentation/screens/team_preview_screen2.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/home/presentation/widgets/select_bench_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectBenchesScreen extends StatelessWidget {

  CreateTeamModel createTeamModel;
  SelectBenchesScreen({super.key, required this.createTeamModel});

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
      body: Consumer<SelectedPlayersProvider>(builder: (context, data, child) {
        List<EntityPlayer> gkPlayers = data.selectedPlayers
            .where((player) => player.position == "Goalkeeper")
            .toList();
        List<EntityPlayer> defPlayers = data.selectedPlayers
            .where((player) => player.position == "Defender")
            .toList();
        List<EntityPlayer> midPlayers = data.selectedPlayers
            .where((player) => player.position == "Midfielder")
            .toList();
        List<EntityPlayer> forPlayers = data.selectedPlayers
            .where((player) => player.position == "Forward")
            .toList();

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
          child: Column(
            children: [
              appHeader2(
                  title: "Select Benches",
                  desc:
                  "Pick your substitute players from the selected 15 players"),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(defaultBorderRadius))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Choose your substitute players",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textBlackColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          selectBenchComponent(
                              text: "Goalkeepers",
                              players: gkPlayers, context: context
                          ),
                          selectBenchComponent(
                              text: "Defenders",
                              players: defPlayers, context: context
                          ),
                          selectBenchComponent(
                              text: "Midfielders",
                              players: midPlayers, context: context
                          ),
                          selectBenchComponent(
                              text: "Attackers",
                              players: forPlayers, context: context
                          )
                        ],
                      ),
                    ),
                  )),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeamPreviewScreen2(createTeamModel: createTeamModel,)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            side: BorderSide(color: primaryColor, width: 1.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            "Team Preview",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if(data.substitutePlayers.length != 4) {
                              errorFlashBar(context: context, message: "Please select 4 bench players");
                              return;
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCaptainScreen2(createTeamModel: createTeamModel,)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            side: BorderSide(color: primaryColor, width: 1.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: onPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
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
