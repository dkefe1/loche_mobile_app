import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/no_data_widget.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/data/models/scout.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/screens/add_scout_screen.dart';
import 'package:fantasy/features/profile/presentation/widgets/scout_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoutsScreen extends StatefulWidget {
  const ScoutsScreen({super.key});

  @override
  State<ScoutsScreen> createState() => _ScoutsScreenState();
}

class _ScoutsScreenState extends State<ScoutsScreen> {

  final prefs = PrefService();

  bool showFloatButton = true;

  List<String> scouts = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            AppHeader(
                title: "",
                desc:
                AppLocalizations.of(context)!.scout),
            Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BlocConsumer<ScoutsBloc, ScoutsState>(
                            listener: (_, state) async {
                              if(state is GetAllScoutsFailedState){
                                setState(() {
                                  showFloatButton = false;
                                });
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
                              } else if(state is GetAllScoutsSuccessfulState) {
                                scouts = [];
                                for(int i = 0; i< state.scouts.length; i++){
                                  scouts.add(state.scouts[i].player_id);
                                }
                                setState(() {
                                  showFloatButton = true;
                                });
                              } else {
                                setState(() {
                                  showFloatButton = false;
                                });
                              }
                            },
                            builder: (_, state) {
                              if (state is GetAllScoutsSuccessfulState) {
                                return state.scouts.isEmpty ? Center(child: noDataWidget(icon: GameIcons.binoculars, message: AppLocalizations.of(context)!.you_have_not_added_to_watch_list, iconSize: 120, iconColor: textColor)) : buildInitialInput(scouts: state.scouts);
                              } else if (state is GetAllScoutsLoadingState) {
                                return scoutsLoading();
                              } else if (state is GetAllScoutsFailedState) {
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
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 60.0),
                                  child: errorView(
                                      iconPath: state.error == socketErrorMessage
                                          ? "images/connection.png"
                                          : "images/error.png",
                                      title: "Ooops!",
                                      text: state.error,
                                      onPressed: () {
                                        final getAllNotes =
                                        BlocProvider.of<ScoutsBloc>(context);
                                        getAllNotes.add(GetAllScoutsEvent());
                                      }),
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: showFloatButton ? Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10),
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddScoutScreen(scouts: scouts,)));
          },
          child: Icon(Icons.add),),
      ) : null,
    );
  }

  Widget buildInitialInput({required List<Scout> scouts}) {

    List<Scout> gkPlayers =
    scouts.where((player) => player.position == "Goalkeeper").toList();
    List<Scout> defPlayers =
    scouts.where((player) => player.position == "Defender").toList();
    List<Scout> midPlayers =
    scouts.where((player) => player.position == "Midfielder").toList();
    List<Scout> forPlayers =
    scouts.where((player) => player.position == "Forward").toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Text(
            AppLocalizations.of(context)!.players.toUpperCase(),
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
                fontSize: textFontSize),
          ),
          SizedBox(height: 10,),
          scoutComponent(text: AppLocalizations.of(context)!.goalkeepers, players: gkPlayers),
          scoutComponent(text: AppLocalizations.of(context)!.defenders, players: defPlayers),
          scoutComponent(text: AppLocalizations.of(context)!.midfielders, players: midPlayers),
          scoutComponent(text: AppLocalizations.of(context)!.attackers, players: forPlayers),
        ],
      ),
    );
  }

  Widget scoutsLoading(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          BlinkContainer(width: 120, height: 30, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
