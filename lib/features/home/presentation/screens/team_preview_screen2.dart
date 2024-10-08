import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/create_player_model.dart';
import 'package:fantasy/features/home/data/models/create_team_model.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/home/presentation/widgets/preview_component3.dart';
import 'package:fantasy/features/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TeamPreviewScreen2 extends StatefulWidget {

  CreateTeamModel createTeamModel;

  TeamPreviewScreen2({super.key, required this.createTeamModel});

  @override
  State<TeamPreviewScreen2> createState() => _TeamPreviewScreen2State();
}

class _TeamPreviewScreen2State extends State<TeamPreviewScreen2> {

  bool isLoading = false;

  final prefs = PrefService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SelectedPlayersProvider>(
          builder: (context, data, child) {

            List<EntityPlayer> gkPlayers = data.selectedPlayers.where((player) => player.position == "Goalkeeper").toList();
            List<EntityPlayer> defPlayers = data.selectedPlayers.where((player) => player.position == "Defender").toList();
            List<EntityPlayer> midPlayers = data.selectedPlayers.where((player) => player.position == "Midfielder").toList();
            List<EntityPlayer> forPlayers = data.selectedPlayers.where((player) => player.position == "Forward").toList();

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
              child: Column(children: [
                appHeader2(
                    title: "Team Preview",
                    desc:
                    "Here is the preview of your team with the selected players."),
                Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(defaultBorderRadius))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Number of selected players ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: textColor),
                                          ),
                                          Text(
                                            "(${data.selectedPlayers.length}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: textColor),
                                          ),
                                          Text(
                                            "/",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: textBlackColor),
                                          ),
                                          Text(
                                            "15)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: textColor),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Team Preview ", style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w600),),
                                          Row(
                                            children: [
                                              Text("Price ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
                                              Text("(${data.credit.toStringAsFixed(1)} LC)", style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w400),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(image: AssetImage("images/pitch.png"), fit: BoxFit.fill)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: 20,),
                                        previewComponent3(players: gkPlayers),
                                        previewComponent3(players: defPlayers),
                                        previewComponent3(players: midPlayers),
                                        previewComponent3(players: forPlayers),
                                        SizedBox(height: 10,)
                                      ],),
                                  ),
                                ),
                                SizedBox(height: 15,),
                              ],
                            ),
                          ),
                          BlocConsumer<CreateTeamBloc, CreateTeamState>(
                              builder: (_, state) {
                                return SizedBox();
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ElevatedButton(
                                      onPressed: isLoading ? null : (){
                                        if(data.selectedPlayers.length != 15){
                                          errorFlashBar(context: context, message: "Please select 15 players");
                                          return;
                                        }
                                        if(data.isCaptainSelected && data.isViceCaptainSelected){
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
                                          errorFlashBar(context: context, message: "Please select one captain and one vice captain");
                                          return;
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        disabledBackgroundColor: primaryColor,
                                        disabledForegroundColor: Colors.white,
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                                        side: BorderSide(color: primaryColor, width: 1.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                      ),
                                      child: isLoading
                                          ? Center(
                                          child: SizedBox(
                                            height: 14,
                                            width: 14,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          ))
                                          : Text("Create Team", style: TextStyle(color: onPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500),)),
                                ),
                                SizedBox(height: 10,),
                                Center(child: Text("Here is the preview of your team with the selected players. Good Luck!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: textColor, fontSize: 12),)),
                                SizedBox(height: 15,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ]),
            );
          }
      ),
    );
  }

  String getPosition({required String positionType}) {
    if(positionType == "Goalkeeper"){
      return "GK";
    } else if(positionType == "Defender"){
      return "DEF";
    } else if(positionType == "Midfielder"){
      return "MID";
    } else {
      return "FOR";
    }
  }

}
