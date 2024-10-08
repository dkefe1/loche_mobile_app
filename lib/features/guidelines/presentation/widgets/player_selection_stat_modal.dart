import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/screens/player_selection_stat_screen.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget playerSelectionStatModalSheet({required BuildContext context, required String? gameWeekId}) {

  final prefs = PrefService();

  return BlocConsumer<DoneGameWeekBloc, DoneGameWeekState>(
      listener: (_, state) async {
        if(state is GetGameWeekFailedState){
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
        } else if(state is GetGameWeekSuccessfulState) {

        }
      },
      builder: (_, state) {
        if (state is GetGameWeekSuccessfulState) {
          return state.gameWeeks.isEmpty ? notDoneGameWeek() : gameWeekModalBody(doneGameWeeks: state.gameWeeks, gameWeekId: gameWeekId);
        } else if (state is GetGameWeekLoadingState) {
          return doneGameWeekLoading();
        } else if (state is GetGameWeekFailedState) {
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
                  final doneGameWeek =
                  BlocProvider.of<DoneGameWeekBloc>(context);
                  doneGameWeek.add(GetDoneGameWeekEvent());
                }),
          );
        } else {
          return SizedBox();
        }
      });
}

Widget gameWeekModalBody({required List<GameWeek> doneGameWeeks, required String? gameWeekId}) {

  List<GameWeek> gameWeeks = [GameWeek(id: "all", game_week: "All", transfer_deadline: "", is_done: true)];
  gameWeeks.addAll(doneGameWeeks);

  return Container(
    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
    decoration: BoxDecoration(
        color: modalBottomColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(60))
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: SizedBox(width: 80, child: Divider(color: Colors.white, thickness: 3.0,),),),
          SizedBox(height: 15,),
          Center(child: Text("Select a Gameweek", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),),
          SizedBox(height: 20,),
          GridView.builder(
              itemCount: gameWeeks.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 50, crossAxisSpacing: 9, mainAxisSpacing: 9),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if(gameWeeks[index].id == "all"){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerSelectionStatScreen(gameWeek: null,)));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerSelectionStatScreen(gameWeek: gameWeeks[index],)));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              gameWeeks[index].id == "all" ? "All" : "GW ${gameWeeks[index].game_week}",
                              style: TextStyle(color: primaryColor, fontSize: 12), overflow: TextOverflow.ellipsis,
                            ),
                            gameWeekId == gameWeeks[index].id ? Row(
                              children: [
                                Icon(
                                  Icons.done,
                                  color: primaryColor,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "current",
                                  style:
                                  TextStyle(color: primaryColor, fontSize: 8),
                                ),
                              ],
                            ) : SizedBox(),
                          ],
                        )),
                  ),
                );
              }),
          SizedBox(height: 20,),
        ],
      ),
    ),
  );
}

Widget doneGameWeekLoading(){
  return Container(
    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
    decoration: BoxDecoration(
        color: modalBottomColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(60))
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: SizedBox(width: 80, child: Divider(color: Colors.white, thickness: 3.0,),),),
          SizedBox(height: 15,),
          BlinkContainer(width: 150, height: 30, borderRadius: 0),
          SizedBox(height: 20,),
          GridView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 40, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index){
                return BlinkContainer(width: 30, height: 50, borderRadius: 15);
              }),
          SizedBox(height: 20,),
        ],
      ),
    ),
  );
}

Widget notDoneGameWeek() {
  return Container(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      decoration: BoxDecoration(
          color: modalBottomColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(60))
      ),
      child: Text("No game week available", style: TextStyle(color: Colors.white, fontSize: 16),));
}