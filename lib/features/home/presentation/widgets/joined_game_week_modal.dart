import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/data/models/ClientGameWeekTeam.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/screens/joined_game_week_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget joinedGameWeekModalSheet({required BuildContext context, required String gameWeekId}) {

  final prefs = PrefService();

  return BlocConsumer<JoinedGameWeekBloc, JoinedGameWeekState>(
      listener: (_, state) async {
        if(state is GetJoinedGameWeekFailedState){
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
        } else if(state is GetJoinedGameWeekSuccessfulState) {

        }
      },
      builder: (_, state) {
        if (state is GetJoinedGameWeekSuccessfulState) {
          return state.joinedGameWeeks.isEmpty ? notJoinedGameWeek() : gameWeekModalBody(joinedGameWeeks: state.joinedGameWeeks, gameWeekId: gameWeekId);
        } else if (state is GetJoinedGameWeekLoadingState) {
          return joinedGameWeekLoading();
        } else if (state is GetJoinedGameWeekFailedState) {
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
                  final joinedGameWeek =
                  BlocProvider.of<JoinedGameWeekBloc>(context);
                  joinedGameWeek.add(GetJoinedGameWeekEvent());
                }),
          );
        } else {
          return SizedBox();
        }
      });
}

Widget gameWeekModalBody({required List<ClientGameWeekTeam> joinedGameWeeks, required String gameWeekId}) {
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
              itemCount: joinedGameWeeks.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 50, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => JoinedGameWeekScreen(gameWeekId: joinedGameWeeks[index].game_week_id.id,)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("GW ${joinedGameWeeks[index].game_week_id.game_week}", style: TextStyle(color: primaryColor, fontSize: 12),),
                        gameWeekId == joinedGameWeeks[index].game_week_id.id ? Row(
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

Widget joinedGameWeekLoading(){
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

Widget notJoinedGameWeek() {
  return Container(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      decoration: BoxDecoration(
          color: modalBottomColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(60))
      ),
      child: Text("You have not joined any game week", style: TextStyle(color: Colors.white, fontSize: 16),));
}