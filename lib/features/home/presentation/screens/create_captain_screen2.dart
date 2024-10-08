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
import 'package:fantasy/features/home/presentation/screens/team_preview_screen2.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/home/presentation/widgets/create_captain_component.dart';
import 'package:fantasy/features/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CreateCaptainScreen2 extends StatefulWidget {
  CreateTeamModel createTeamModel;

  CreateCaptainScreen2({super.key, required this.createTeamModel});

  @override
  State<CreateCaptainScreen2> createState() => _CreateCaptainScreen2State();
}

class _CreateCaptainScreen2State extends State<CreateCaptainScreen2> {

  bool isLoading = false;

  final prefs = PrefService();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        final data = Provider.of<SelectedPlayersProvider>(context, listen: false);
        data.removeCaptainAndViceCaptain();
        return true;
      },
      child: Scaffold(
        body: Consumer<SelectedPlayersProvider>(builder: (context, data, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
            child: Column(
              children: [
                appHeader2(
                    title: "Create Team",
                    desc: "Assemble your winning squad by choosing players."),
                Expanded(
                    child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: BlocConsumer<CreateTeamBloc, CreateTeamState>(
                      builder: (_, state) {
                    return buildInitialInput(context: context, data: data);
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: isLoading ? null : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TeamPreviewScreen2(createTeamModel: widget.createTeamModel,)));
                            },
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.white,
                              disabledForegroundColor: primaryColor,
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
                            onPressed: isLoading ? null : () {
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
                            },
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: primaryColor,
                              disabledForegroundColor: Colors.white,
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              side: BorderSide(color: primaryColor, width: 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child:  isLoading
                                ? Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ))
                                : Text(
                              "Create Team",
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
      ),
    );
  }

  Widget buildInitialInput(
      {required BuildContext context, required SelectedPlayersProvider data}) {
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          Text(
            "Choose your Captain and Vice Captain",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xFF1E727E).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "C",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Captain",
                        style: TextStyle(
                            color: textBlackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Text(
                            "Gets ",
                            style: TextStyle(
                                color: Color(0xFF000000).withOpacity(0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "2x ",
                            style: TextStyle(
                                color: Color(0xFF000000).withOpacity(0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Points",
                            style: TextStyle(
                                color: Color(0xFF000000).withOpacity(0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xFF1E727E).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "v",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vice Captain",
                        style: TextStyle(
                            color: textBlackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Select Players",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Players",
              style: TextStyle(
                  color: textBlackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Captain",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "V.Captain",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
          ),
          createCaptainComponent(
            text: "Goalkeepers",
            players: gkPlayers,
            onTapCaptain: (id, isAddButton, isPlayerViceCaptain) {
              if (isAddButton) {
                if (isPlayerViceCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                          "Player can not be both captain and vice captain");
                  return;
                }
                if (data.isCaptainSelected) {
                  errorFlashBar(
                      context: context,
                      message: "You can only select one captain");
                  return;
                }
              }
              data.selectCaptain(id: id);
            },
            onTapVice: (id, isAddButton, isPlayerCaptain) {
              if (isAddButton) {
                if (isPlayerCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                          "Player can not be both captain and vice captain");
                  return;
                }
                if (data.isViceCaptainSelected) {
                  errorFlashBar(
                      context: context,
                      message: "You can only select one vice captain");
                  return;
                }
              }
              data.selectViceCaptain(id: id);
            },
          ),
          createCaptainComponent(
            text: "Defenders",
            players: defPlayers,
            onTapCaptain: (id, isAddButton, isPlayerViceCaptain) {
              if (isAddButton) {
                if (isPlayerViceCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                          "Player can not be both captain and vice captain");
                  return;
                }
                if (data.isCaptainSelected) {
                  errorFlashBar(
                      context: context,
                      message: "You can only select one captain");
                  return;
                }
              }
              data.selectCaptain(id: id);
            },
            onTapVice: (id, isAddButton, isPlayerCaptain) {
              if (isAddButton) {
                if (isPlayerCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                          "Player can not be both captain and vice captain");
                  return;
                }
                if (data.isViceCaptainSelected) {
                  errorFlashBar(
                      context: context,
                      message: "You can only select one vice captain");
                  return;
                }
              }
              data.selectViceCaptain(id: id);
            },
          ),
          createCaptainComponent(
            text: "Midfielders",
            players: midPlayers,
            onTapCaptain: (id, isAddButton, isPlayerViceCaptain) {
              if (isAddButton) {
                if (isPlayerViceCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                          "Player can not be both captain and vice captain");
                  return;
                }
                if (data.isCaptainSelected) {
                  errorFlashBar(
                      context: context,
                      message: "You can only select one captain");
                  return;
                }
              }
              data.selectCaptain(id: id);
            },
            onTapVice: (id, isAddButton, isPlayerCaptain) {
              if (isAddButton) {
                if (isPlayerCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                          "Player can not be both captain and vice captain");
                  return;
                }
                if (data.isViceCaptainSelected) {
                  errorFlashBar(
                      context: context,
                      message: "You can only select one vice captain");
                  return;
                }
              }
              data.selectViceCaptain(id: id);
            },
          ),
          createCaptainComponent(
            text: "Attackers",
            players: forPlayers,
            onTapCaptain: (id, isAddButton, isPlayerViceCaptain) {
              if (isAddButton) {
                if (isPlayerViceCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                          "Player can not be both captain and vice captain");
                  return;
                }
                if (data.isCaptainSelected) {
                  errorFlashBar(
                      context: context,
                      message: "You can only select one captain");
                  return;
                }
              }
              data.selectCaptain(id: id);
            },
            onTapVice: (id, isAddButton, isPlayerCaptain) {
              if (isAddButton) {
                if (isPlayerCaptain) {
                  errorFlashBar(
                      context: context,
                      message:
                          "Player can not be both captain and vice captain");
                  return;
                }
                if (data.isViceCaptainSelected) {
                  errorFlashBar(
                      context: context,
                      message: "You can only select one vice captain");
                  return;
                }
              }
              data.selectViceCaptain(id: id);
            },
          )
        ],
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
