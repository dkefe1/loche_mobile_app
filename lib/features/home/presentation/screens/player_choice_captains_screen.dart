import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/common_widgets/app_header3.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/create_player_model.dart';
import 'package:fantasy/features/home/data/models/create_team_model.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/widgets/player_choice_captains_component.dart';
import 'package:fantasy/features/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PlayerChoiceCaptainsScreen extends StatefulWidget {

  CreateTeamModel createTeamModel;
  PlayerChoiceCaptainsScreen({required this.createTeamModel});

  @override
  State<PlayerChoiceCaptainsScreen> createState() => _PlayerChoiceCaptainsScreenState();
}

class _PlayerChoiceCaptainsScreenState extends State<PlayerChoiceCaptainsScreen> {

  bool isLoading = false;

  final prefs = PrefService();

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
    GestureDetector(
        onPanUpdate: (details) async {
          if (details.delta.dx > 30) {
            final data = Provider.of<SelectedPlayersProvider>(context, listen: false);
            data.removeCaptainAndViceCaptain();
            Navigator.of(context).pop();
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: primaryScreen(),
        )
    )
        : WillPopScope(
      onWillPop: () async {
        final data = Provider.of<SelectedPlayersProvider>(context, listen: false);
        data.removeCaptainAndViceCaptain();
        return true;
      },
      child: primaryScreen(),
    );
  }

  Widget primaryScreen(){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<SelectedPlayersProvider>(builder: (context, data, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
          child: Column(
            children: [
              appHeader3(
                  title: "Select Your Captains",
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
                    child: BlocConsumer<CreateTeamBloc, CreateTeamState>(
                        builder: (_, state) {
                          return buildInitialInput(data: data);
                        }, listener: (_, state) {
                      if (state is CreateTeamLoadingState) {
                        isLoading = true;
                        setState(() {});
                      } else if (state is CreateTeamSuccessfulState) {
                        isLoading = false;
                        prefs.createTeam("hasATeam");
                        setState(() {});
                        final getClientTeam = BlocProvider.of<ClientTeamBloc>(context);
                        getClientTeam.add(GetClientTeamEvent());
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IndexScreen(
                                  pageIndex: 0,
                                )),
                                (route) => false);
                        data.removeAllPlayers();
                      } else if (state is CreateTeamFailedState) {
                        isLoading = false;
                        setState(() {});
                        errorFlashBar(context: context, message: state.error);
                      }
                    }),
                  )),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15, 20, 15, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: isLoading ? null : (){
                            final data = Provider.of<SelectedPlayersProvider>(context, listen: false);
                            data.removeCaptainAndViceCaptain();
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
                          onPressed: (data.isViceCaptainSelected && data.isCaptainSelected) ? (){
                            if(!isLoading){
                              if (data.isViceCaptainSelected &&
                                  data.isCaptainSelected) {

                                List<EntityPlayer> ads = data.selectedPlayers;
                                List<CreatePlayerModel> players =
                                ads.map((player) {
                                  return CreatePlayerModel(
                                      pid: player.pid,
                                      full_name: player.full_name,
                                      price: num.parse(player.price),
                                      position: player.position,
                                      club: player.clubAbbr,
                                      club_logo: player.club_logo,
                                      is_bench: player.isBench,
                                      is_captain: player.isCaptain,
                                      is_vice_captain: player.isViceCaptain);
                                }).toList();

                                final postTeam =
                                BlocProvider.of<CreateTeamBloc>(context);
                                postTeam.add(PostTeamEvent(CreateTeamModel(
                                    competition: "competition",
                                    team_name: widget.createTeamModel.team_name,
                                    favorite_coach:
                                    widget.createTeamModel.favorite_coach,
                                    favorite_tactic:
                                    widget.createTeamModel.favorite_tactic,
                                    players: players)));
                              } else {
                                errorFlashBar(
                                    context: context,
                                    message:
                                    "Please select one captain and one vice captain");
                                return;
                              }
                            }
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                            ),
                          ),
                          child: isLoading
                              ? Center(
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ))
                              : Text("Finish", style: TextStyle(color: data.selectedPlayers.length != 15 ? Color(0xFFA7A7A7) : onPrimaryColor, fontSize: 18, fontWeight: FontWeight.w500),)),
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

  Widget buildInitialInput({required SelectedPlayersProvider data}){

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
      width: double.infinity,
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
            playerChoiceCaptainsComponent(context: context, players: gkPlayers, position: "Goalkeeper", value: 0),
            playerChoiceCaptainsComponent(context: context, players: defPlayers, position: "Defender", value: 2),
            playerChoiceCaptainsComponent(context: context, players: midPlayers, position: "Midfielder", value: 7),
            playerChoiceCaptainsComponent(context: context, players: forPlayers, position: "Forward", value: 12),
            SizedBox(height: 10,)
          ],),
      ),
    );
  }

}
