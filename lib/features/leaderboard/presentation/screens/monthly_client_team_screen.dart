import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/joined_game_week_preview.dart';
import 'package:fantasy/features/home/presentation/widgets/joined_player_avatar.dart';
import 'package:fantasy/features/home/presentation/widgets/loading_shirt.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leader.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_bloc.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_event.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_state.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/monthly_client_team_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthlyClientTeamScreen extends StatefulWidget {

  MonthlyLeader contestor;
  MonthlyClientTeamScreen({super.key, required this.contestor});

  @override
  State<MonthlyClientTeamScreen> createState() => _MonthlyClientTeamScreenState();
}

class _MonthlyClientTeamScreenState extends State<MonthlyClientTeamScreen> {

  final prefs = PrefService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: BlocConsumer<OtherClientTeamBloc, OtherClientTeamState>(
            listener: (_, state) async {
              if(state is GetOtherClientTeamSuccessfulState){
              }

              if(state is GetOtherClientTeamFailedState){
                if(state.error == jwtExpired || state.error == doesNotExist){
                  await prefs.signout();
                  await prefs.removeToken();
                  await prefs.removeCreatedTeam();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignInScreen()),
                          (route) => false);
                }
              }
              setState(() {});
            },
            builder: (_, state) {
              if (state is GetOtherClientTeamSuccessfulState) {
                return buildInitialInput(clientPlayers: state.players);
              } else if (state is GetOtherClientTeamLoadingState) {
                return teamLoading();
              } else if (state is GetOtherClientTeamFailedState) {
                if(state.error == pinChangedMessage || state.error == notCreatedATeam){
                  return pinChangedErrorView(
                      iconPath: state.error == socketErrorMessage
                          ? "images/connection.png"
                          : "images/error.png",
                      title: "Ooops!",
                      text: state.error,
                      onPressed: () async {
                        await prefs.signout();
                        await prefs.removeToken();
                        await prefs.removeCreatedTeam();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                                (route) => false);
                      });
                }
                return errorView(
                    iconPath: state.error == socketErrorMessage
                        ? "images/connection.png"
                        : "images/error.png",
                    title: "Ooops!",
                    text: state.error,
                    onPressed: () {
                      final getPlayers =
                      BlocProvider.of<OtherClientTeamBloc>(context);
                      getPlayers.add(GetOtherClientTeamEvent(widget.contestor.id));
                    });
              } else {
                return SizedBox();
              }
            }),
      ),
    );
  }

  Widget buildInitialInput({required List<ClientPlayer> clientPlayers}){

    List<ClientPlayer> selectedGkPlayers = clientPlayers.
    where((player) => player.position == "Goalkeeper" && player.is_bench == false)
        .toList();
    List<ClientPlayer> selectedDefPlayers = clientPlayers.
    where((player) => player.position == "Defender" && player.is_bench == false)
        .toList();
    List<ClientPlayer> selectedMidPlayers = clientPlayers.
    where((player) => player.position == "Midfielder" && player.is_bench == false)
        .toList();
    List<ClientPlayer> selectedForPlayers = clientPlayers.
    where((player) => player.position == "Forward" && player.is_bench == false)
        .toList();

    List<ClientPlayer> substituteGkPlayers = clientPlayers.
    where((player) => player.position == "Goalkeeper" && player.is_bench == true)
        .toList();
    List<ClientPlayer> substituteDefPlayers = clientPlayers.
    where((player) => player.position == "Defender" && player.is_bench == true)
        .toList();
    List<ClientPlayer> substituteMidPlayers = clientPlayers.
    where((player) => player.position == "Midfielder" && player.is_bench == true)
        .toList();
    List<ClientPlayer> substituteForPlayers = clientPlayers.
    where((player) => player.position == "Forward" && player.is_bench == true)
        .toList();

    return Column(
      children: [
        MonthlyClientTeamHeader(contestor: widget.contestor),
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
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/pitch.png"),
                              fit: BoxFit.cover)),
                      child: LayoutBuilder(
                          builder: (context, constraint) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(height: 10,),
                                      joinedGameWeekPreview(
                                          players: selectedGkPlayers),
                                      joinedGameWeekPreview(
                                          players: selectedDefPlayers),
                                      joinedGameWeekPreview(
                                          players: selectedMidPlayers),
                                      joinedGameWeekPreview(
                                          players: selectedForPlayers),
                                      SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/splash.png"), fit: BoxFit.fill),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      color: Color(0xFF000000).withOpacity(0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Substitutes",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: substituteGkPlayers
                                    .map((player) => joinedPlayerAvatar(
                                    player: player, context: context))
                                    .toList(),
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: substituteDefPlayers
                                        .map((player) => joinedPlayerAvatar(
                                        player: player, context: context))
                                        .toList(),
                                  ),
                                  Row(
                                    children: substituteMidPlayers
                                        .map((player) => joinedPlayerAvatar(
                                        player: player, context: context))
                                        .toList(),
                                  ),
                                  Row(
                                    children: substituteForPlayers
                                        .map((player) => joinedPlayerAvatar(
                                        player: player, context: context))
                                        .toList(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  Widget teamLoading() {
    return Column(
      children: [
        MonthlyClientTeamHeader(contestor: widget.contestor,),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
            child: Column(
              children: [
                Expanded(
                  child: Builder(builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/pitch.png"),
                                    fit: BoxFit.cover)),
                            child: LayoutBuilder(
                                builder: (context, constraint) {
                                  return SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minHeight: constraint.maxHeight),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(height: 10,),
                                          Center(child: BlinkShirt(width: 39.81, height: 55)),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              BlinkShirt(width: 39.81, height: 55),
                                              SizedBox(width: 15,),
                                              BlinkShirt(width: 39.81, height: 55),
                                              SizedBox(width: 15,),
                                              BlinkShirt(width: 39.81, height: 55),
                                              SizedBox(width: 15,),
                                              BlinkShirt(width: 39.81, height: 55),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              BlinkShirt(width: 39.81, height: 55),
                                              SizedBox(width: 15,),
                                              BlinkShirt(width: 39.81, height: 55),
                                              SizedBox(width: 15,),
                                              BlinkShirt(width: 39.81, height: 55),
                                              SizedBox(width: 15,),
                                              BlinkShirt(width: 39.81, height: 55),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              BlinkShirt(width: 39.81, height: 55),
                                              SizedBox(width: 15,),
                                              BlinkShirt(width: 39.81, height: 55),
                                            ],
                                          ),
                                          SizedBox(),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/splash.png"), fit: BoxFit.fill),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            color: Color(0xFF000000).withOpacity(0.2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Substitutes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BlinkShirt(width: 39.81, height: 55),
                                    Row(
                                      children: [
                                        BlinkShirt(width: 39.81, height: 55),
                                        SizedBox(width: 15,),
                                        BlinkShirt(width: 39.81, height: 55),
                                        SizedBox(width: 15,),
                                        BlinkShirt(width: 39.81, height: 55),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

}
