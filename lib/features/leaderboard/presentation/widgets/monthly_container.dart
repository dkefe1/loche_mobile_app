import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leader.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_bloc.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_event.dart';
import 'package:fantasy/features/leaderboard/presentation/screens/monthly_client_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget monthlyLeaderContainer({required MonthlyLeader contestor, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(15)
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(contestor.rank.toString(), style: TextStyle(color: textBlackColor, fontSize: 13, fontWeight: FontWeight.w600),),
          SizedBox(width: 10,),
          Image.asset("images/leader.png", width: 36, height: 36, fit: BoxFit.fill,),
        ],
      ),
      title: Text("${contestor.first_name} ${contestor.last_name}", style: TextStyle(color: textBlackColor, fontSize: 14, fontWeight: FontWeight.w500),),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(contestor.total_fantasy_point.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textBlackColor),),
          Text("Pt", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: textColor),),
          // SizedBox(width: 10,),
          // GestureDetector(
          //   onTap: (){
          //     final getLeaderClientTeam = BlocProvider.of<OtherClientTeamBloc>(context);
          //     getLeaderClientTeam.add(GetOtherClientTeamEvent(contestor.id));
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => MonthlyClientTeamScreen(contestor: contestor)));
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          //     decoration: BoxDecoration(
          //         color: primaryColor,
          //         borderRadius: BorderRadius.circular(3)
          //     ),
          //     child: Text("Team", style: TextStyle(color: Colors.white, fontSize: 12),),),
          // ),
        ],
      ),
    ),
  );
}