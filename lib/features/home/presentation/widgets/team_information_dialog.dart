import 'package:cached_network_image/cached_network_image.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/home/data/models/client_team_model.dart';
import 'package:fantasy/features/home/data/models/coach.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/screens/edit_team_info_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/team_info_detail_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget teamInfoDialog({required BuildContext context, required ClientTeam clientTeam}) {

  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: BlocBuilder<MyCoachBloc, MyCoachState>(builder: (_, state) {
        if (state is GetMyCoachSuccessfulState) {
          return teamInfoBody(coach: state.coach, clientTeam: clientTeam, context: context);
        } else if (state is GetMyCoachLoadingState) {
          return teamInfoLoading(context: context);
        } else if (state is GetMyCoachFailedState) {
          return errorView(
              iconPath: state.error == socketErrorMessage
                  ? "images/connection.png"
                  : "images/error.png",
              title: "Ooops!",
              text: state.error,
              onPressed: () {
                final getMyCoach =
                BlocProvider.of<MyCoachBloc>(context);
                getMyCoach.add(GetMyCoachEvent(clientTeam.favorite_coach, true));
              });
        } else {
          return SizedBox();
        }
      }),
    ),
  );
}

Widget teamInfoBody({required Coach coach, required ClientTeam clientTeam, required BuildContext context}){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Team Info", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close, size: 25, color: textBlackColor,))
          ],
        ),
      ),
      Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: (){
              final getCoaches = BlocProvider.of<CoachBloc>(context);
              getCoaches.add(GetCoachEvent());
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditTeamInfoScreen(teamName: clientTeam.team_name, coach: coach, tacticalStyle: clientTeam.favorite_tactic, teamId: clientTeam.id,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text("Edit", style: TextStyle(color: primaryColor, decoration: TextDecoration.underline, fontWeight: FontWeight.w700),),
            ),
          )),
      SizedBox(height: 10,),
      ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          imageUrl: coach.image_secure_url,
          placeholder: (context, url) => BlinkContainer(width: 100, height: 100, borderRadius: 50),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      SizedBox(height: 10,),
      Text(coach.coach_name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textBlackColor),),
      SizedBox(height: 20,),
      teamInfoDetailComponent(key: "Team:", value: clientTeam.team_name, iconImage: "images/team.png", isNetwork: false),
      SizedBox(height: 10,),
      teamInfoDetailComponent(key: "Tactical Style:", value: clientTeam.favorite_tactic, iconImage: "images/points.png", isNetwork: false),
      SizedBox(height: 10,),
      teamInfoDetailComponent(key: "Budget:", value: "${clientTeam.budget.toStringAsFixed(1)} LC", iconImage: "images/total_points.png", isNetwork: false),
      SizedBox(height: 20,),
    ],
  );
}

Widget teamInfoLoading({required BuildContext context}){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Team Info", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close, size: 25, color: textBlackColor,))
          ],
        ),
      ),
      SizedBox(height: 10,),
      BlinkContainer(width: 100, height: 100, borderRadius: 100),
      SizedBox(height: 5,),
      BlinkContainer(width: 100, height: 25, borderRadius: 0),
      SizedBox(height: 10,),
      BlinkContainer(width: double.infinity, height: 25, borderRadius: 5),
      SizedBox(height: 10,),
      BlinkContainer(width: double.infinity, height: 25, borderRadius: 5),
      SizedBox(height: 10,),
      BlinkContainer(width: double.infinity, height: 25, borderRadius: 5),
      SizedBox(height: 20,),
    ],
  );
}