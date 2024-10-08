import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/guidelines/data/models/player_selected_model.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/most_selected_component.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/player_selected_stat_header.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/player_selection_stat_widget.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerSelectionStatScreen extends StatefulWidget {

  GameWeek? gameWeek;
  PlayerSelectionStatScreen({super.key, required this.gameWeek});

  @override
  State<PlayerSelectionStatScreen> createState() => _PlayerSelectionStatScreenState();
}

class _PlayerSelectionStatScreenState extends State<PlayerSelectionStatScreen> {

  final prefs = PrefService();

  @override
  void initState() {
    if(widget.gameWeek == null){
      final getPlayerSelectedStat = BlocProvider.of<PlayerSelectedStatBloc>(context);
      getPlayerSelectedStat.add(GetPlayerSelectedStatEvent(null));
    } else {
      final getPlayerSelectedStat = BlocProvider.of<PlayerSelectedStatBloc>(context);
      getPlayerSelectedStat.add(GetPlayerSelectedStatEvent(widget.gameWeek!.id));
    }
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
            PlayerSelectedStatHeader(title: "", gameWeek: widget.gameWeek,),
            Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: SingleChildScrollView(
                    child: BlocConsumer<PlayerSelectedStatBloc, PlayerSelectedStatState>(builder: (_, state){
                      if(state is GetPlayerSelectedStatSuccessfulState){
                        return buildInitialInput(stat: state.stat);
                      } else if(state is GetPlayerSelectedStatLoadingState){
                        return statLoadingWidget();
                      } else if(state is GetPlayerSelectedStatFailedState){
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
                              final getPlayerSelectedStat = BlocProvider.of<PlayerSelectedStatBloc>(context);
                              getPlayerSelectedStat.add(GetPlayerSelectedStatEvent(null));
                            });
                      } else {
                        return SizedBox();
                      }
                    }, listener: (_, state) async {
                      if(state is GetPlayerSelectedStatFailedState){
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
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput({required PlayerSelectedStat stat}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(child: Text(widget.gameWeek == null ? AppLocalizations.of(context)!.all_time_summary : "${AppLocalizations.of(context)!.game_week} ${widget.gameWeek!.game_week} ${AppLocalizations.of(context)!.summary}", style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w800, fontSize: 16),)),
          ],
        ),
        SizedBox(height: 5,),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: BoxDecoration(
              color: lightPrimary,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: mostSelectedComponent(label: AppLocalizations.of(context)!.most_selected_player, club: stat.mostSelectedPlayer.club, playerName: stat.mostSelectedPlayer.full_name, position: stat.mostSelectedPlayer.position)),
                  SizedBox(width: 10,),
                  Expanded(child: mostSelectedComponent(label: AppLocalizations.of(context)!.most_captained_player, club: stat.mostCaptainedPlayer.club, playerName: stat.mostCaptainedPlayer.full_name, position: stat.mostCaptainedPlayer.position)),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child: mostSelectedComponent(label: AppLocalizations.of(context)!.most_vice_captained_player, club: stat.mostViceCaptainedPlayer.club, playerName: stat.mostViceCaptainedPlayer.full_name, position: stat.mostViceCaptainedPlayer.position)),
                  SizedBox(width: 10,),
                  stat.transferStat == null ? Expanded(child: SizedBox()) : Expanded(child: mostSelectedComponent(label: AppLocalizations.of(context)!.most_bought_player, club: stat.transferStat!.boughtStat.club, playerName: stat.transferStat!.boughtStat.full_name, position: "Forward")),
                ],
              ),
              stat.transferStat == null ? SizedBox() : SizedBox(height: 20,),
              Row(
                children: [
                  stat.transferStat == null ? Expanded(child: SizedBox()) : Expanded(child: mostSelectedComponent(label: AppLocalizations.of(context)!.most_sold_player, club: stat.transferStat!.soldStat.club, playerName: stat.transferStat!.soldStat.full_name, position: "Forward")),
                  SizedBox(width: 10,),
                  Expanded(child: SizedBox())
                ],
              ),
              stat.transferStat == null ? SizedBox() : SizedBox(height: 20,),
              stat.transferStat == null ? SizedBox() : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.transfers_made, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14),),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Color(0xFF000000).withOpacity(0.2))
                    ),
                    child: Text(formatNumber(stat.transferStat!.transfers.toInt()), style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w800, fontSize: 14),),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }

  Widget statLoadingWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
              color: lightPrimary,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        BlinkContainer(width: 160, height: 25, borderRadius: 0),
                        SizedBox(height: 5,),
                        BlinkContainer(width: double.infinity, height: 200, borderRadius: 15)
                      ],
                    ),
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Column(
                      children: [
                        BlinkContainer(width: 160, height: 25, borderRadius: 0),
                        SizedBox(height: 5,),
                        BlinkContainer(width: double.infinity, height: 200, borderRadius: 15)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        BlinkContainer(width: 160, height: 25, borderRadius: 0),
                        SizedBox(height: 5,),
                        BlinkContainer(width: double.infinity, height: 200, borderRadius: 15)
                      ],
                    ),
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Column(
                      children: [
                        BlinkContainer(width: 160, height: 25, borderRadius: 0),
                        SizedBox(height: 5,),
                        BlinkContainer(width: double.infinity, height: 200, borderRadius: 15)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        BlinkContainer(width: 160, height: 25, borderRadius: 0),
                        SizedBox(height: 5,),
                        BlinkContainer(width: double.infinity, height: 200, borderRadius: 15)
                      ],
                    ),
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Column(
                      children: [
                        BlinkContainer(width: 160, height: 25, borderRadius: 0),
                        SizedBox(height: 5,),
                        BlinkContainer(width: double.infinity, height: 200, borderRadius: 15)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

}
