import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/core/services/time_convert.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/fixture/data/models/match_info.dart';
import 'package:fantasy/features/fixture/data/models/match_stat.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_bloc.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_event.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_state.dart';
import 'package:fantasy/features/fixture/presentation/widgets/event_component.dart';
import 'package:fantasy/features/fixture/presentation/widgets/match_info_component.dart';
import 'package:fantasy/features/fixture/presentation/widgets/stat_component.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class MatchDetailScreen extends StatefulWidget {

  final String matchId, formattedDate;
  final MatchModel matches;
  MatchDetailScreen({super.key, required this.matchId, required this.matches, required this.formattedDate});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {

  String gameWeekStartFormattedDate = "";

  TimeConvert timeConvert = TimeConvert();

  final prefs = PrefService();

  @override
  void initState() {
    final getMatchInfo = BlocProvider.of<MatchInfoBloc>(context);
    getMatchInfo.add(GetMatchInfoEvent(widget.matchId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            AppHeader(title: "", desc: "Match Details"),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
                child: RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () async {
                    final getMatchInfo = BlocProvider.of<MatchInfoBloc>(context);
                    getMatchInfo.add(GetMatchInfoEvent(widget.matchId));
                    return await Future.delayed(Duration(seconds: 2));
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocConsumer<MatchInfoBloc, MatchInfoState>(builder: (_, state){
                          if (state is GetMatchInfoSuccessfulState) {
                            return buildInitialInput(matchInfo: state.matchInfo.matchInfo, matchStat: state.matchInfo.matchStat);
                          } else if (state is GetMatchInfoLoadingState) {
                            return MatchInfoLoading();
                          } else if (state is GetMatchInfoFailedState) {
                            if(state.error == pinChangedMessage){
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 60.0),
                                child: pinChangedErrorView(
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
                                    }),
                              );
                            }
                            return errorView(
                                iconPath: state.error == socketErrorMessage
                                    ? "images/connection.png"
                                    : "images/error.png",
                                title: "Ooops!",
                                text: state.error,
                                onPressed: () {
                                  final getMatchInfo = BlocProvider.of<MatchInfoBloc>(context);
                                  getMatchInfo.add(GetMatchInfoEvent(widget.matchId));
                                });
                          } else {
                            return SizedBox();
                          }
                        }, listener: (_, state) async {
                          if(state is GetMatchInfoSuccessfulState){
                          } else if(state is GetMatchInfoFailedState){
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
                        }),
                        SizedBox(height: 30,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput({required List<MatchInfo> matchInfo, required List<MatchStat?> matchStat}) {

    matchInfo.sort((a, b) => (num.parse(b.time)+num.parse(b.injurytime)).compareTo((num.parse(a.time)+num.parse(a.injurytime))));
    MatchStat? ballPossession = matchStat.firstWhere((element) => element!.name == "Ball possession", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? totalShots = matchStat.firstWhere((element) => element!.name == "Total shots", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? shotOnTarget = matchStat.firstWhere((element) => element!.name == "Shots on target", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? shotsOffTarget = matchStat.firstWhere((element) => element!.name == "Shots off target", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? shotsBlocked = matchStat.firstWhere((element) => element!.name == "shots Blocked", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? cornerKicks = matchStat.firstWhere((element) => element!.name == "Corner kicks", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? offSides = matchStat.firstWhere((element) => element!.name == "Offsides", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? fouls = matchStat.firstWhere((element) => element!.name == "Fouls", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? yellowCards = matchStat.firstWhere((element) => element!.name == "Yellow cards", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? redCards = matchStat.firstWhere((element) => element!.name == "Red cards", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? freeKicks = matchStat.firstWhere((element) => element!.name == "Free kicks", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? bigChances = matchStat.firstWhere((element) => element!.name == "Big chances", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? goalKeeperSaves = matchStat.firstWhere((element) => element!.name == "Goalkeeper saves", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? passes = matchStat.firstWhere((element) => element!.name == "Passes", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? accuratePasses = matchStat.firstWhere((element) => element!.name == "Accurate passes", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? tackles = matchStat.firstWhere((element) => element!.name == "Tackles", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? interceptions = matchStat.firstWhere((element) => element!.name == "Interceptions", orElse: (() => MatchStat(name: "", home: 0, away: 0)));
    MatchStat? clearances = matchStat.firstWhere((element) => element!.name == "Clearances", orElse: (() => MatchStat(name: "", home: 0, away: 0)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        matchInfoComponent(formattedDate: widget.formattedDate, matches: widget.matches),
        matchInfo.isEmpty ? SizedBox() : Column(
          children: [
            SizedBox(height: 5,),
            Center(child: Iconify(Mdi.whistle, color: primaryColor,),),
            SizedBox(height: 10,),
            Center(child: Container(height: 20, width: 20, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),)),
            ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: matchInfo.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: matchInfo[index].team == "home" ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: eventComponent(matchInfo: matchInfo[index]),
                          ) : SizedBox(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(child: Container(color: primaryColor, width: 3,)),
                              Container(
                                  width: 27,
                                  height: 27,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(child: Text("${num.parse(matchInfo[index].time)+num.parse(matchInfo[index].injurytime)}'", style: TextStyle(fontSize: 10, color: onPrimaryColor, fontWeight: FontWeight.w900),)))
                            ],
                          ),
                        ),
                        Expanded(
                          child: matchInfo[index].team == "away" ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0,),
                            child: eventComponent(matchInfo: matchInfo[index]),
                          ) : SizedBox(),
                        ),
                      ],
                    ),
                  );
                }),
            Center(child: Container(height: 20, width: 20, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),)),
            SizedBox(height: 10,),
            Center(child: Iconify(Mdi.whistle, color: primaryColor,),),
          ],
        ),
        SizedBox(height: 10,),
        ballPossession == null ? SizedBox() : Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: lightPrimary,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Match Statistics".toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Divider(thickness: 1.0, color: primaryColor,),
              Center(child: Text(
                "General".toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),),
              Divider(thickness: 1.0, color: primaryColor,),
              Center(child: Text(
                "Ball Possession",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),),
              SizedBox(height: 5,),
              Row(
                children: [
                  Expanded(
                      flex: (ballPossession.home.toInt() == 0 && ballPossession.away.toInt() == 0) ? 1 : ballPossession.home.toInt(),
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: ballPossession.home >= ballPossession.away ? primaryColor : surfaceColor,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(15))
                        ),
                        child: Text("${ballPossession.home}%", textAlign: TextAlign.start, style: TextStyle(color: ballPossession.home >= ballPossession.away ? onPrimaryColor : Colors.black, fontWeight: FontWeight.w700),),
                  )),
                  Expanded(
                      flex: (ballPossession.home.toInt() == 0 && ballPossession.away.toInt() == 0) ? 1 : ballPossession.away.toInt(),
                      child: Container(
                        padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: ballPossession.home < ballPossession.away ? primaryColor : surfaceColor,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(15))
                        ),
                        child: Text("${ballPossession.away}%", textAlign: TextAlign.end, style: TextStyle(color: ballPossession.home < ballPossession.away ? onPrimaryColor : Colors.black, fontWeight: FontWeight.w700),),
                  ))
                ],
              ),
              statComponent(title: "Total shots", matchStat: totalShots),
              statComponent(title: "Shots on target", matchStat: shotOnTarget),
              statComponent(title: "Shots off target", matchStat: shotsOffTarget),
              statComponent(title: "Shots blocked", matchStat: shotsBlocked),
              statComponent(title: "Corner kicks", matchStat: cornerKicks),
              statComponent(title: "Free kicks", matchStat: freeKicks),
              statComponent(title: "Offsides", matchStat: offSides),
              statComponent(title: "Fouls", matchStat: fouls),
              statComponent(title: "Yellow cards", matchStat: yellowCards),
              statComponent(title: "Red cards", matchStat: redCards),
              statComponent(title: "Big chances", matchStat: bigChances),
              statComponent(title: "Goalkeeper saves", matchStat: goalKeeperSaves),
              statComponent(title: "Passes", matchStat: passes),
              statComponent(title: "Accurate Passes", matchStat: accuratePasses),
              statComponent(title: "Tackles", matchStat: tackles),
              statComponent(title: "Interceptions", matchStat: interceptions),
              statComponent(title: "Clearances", matchStat: clearances),
            ],
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }

  Widget MatchInfoLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        BlinkContainer(width: double.infinity, height: 110, borderRadius: 15),
        SizedBox(height: 20,),
        BlinkContainer(width: double.infinity, height: MediaQuery.of(context).size.height, borderRadius: 15),
        SizedBox(height: 20,),
      ],
    );
  }

}
