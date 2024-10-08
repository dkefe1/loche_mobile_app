import 'package:fantasy/features/home/data/models/joined_game_week_team.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget joinGameWeekButton({required JoinedGameWeekTeam joinedGameWeekTeam, required BuildContext context}){
  if(!joinedGameWeekTeam.activeGameWeekAvailable){
    // No Active Game Week
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xFFBC0000),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      child: Center(
        child: Tab(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "No Active",
                  style:
                  GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                ),
                Text(
                  "Gameweek",
                  textAlign: TextAlign.center,
                  style:
                  GoogleFonts.poppins(color: Colors.white, fontSize: 15, decorationColor: Colors.black),
                ),
              ],
            )),
      ),
    );
  }
  if(joinedGameWeekTeam.clientGameWeekTeam == null){
    if(joinedGameWeekTeam.deadlinePassed){
      // DEADLINE PASSED
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFFBC0000),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        child: Center(
          child: Tab(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.deadline_home,
                    style:
                    GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    AppLocalizations.of(context)!.passed,
                    textAlign: TextAlign.center,
                    style:
                    GoogleFonts.poppins(color: Colors.white, fontSize: 15, decoration: TextDecoration.lineThrough, decorationColor: Colors.black),
                  ),
                ],
              )),
        ),
      );
    }
  } else if(joinedGameWeekTeam.clientGameWeekTeam != null){
    // JOINED
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xFF82B4C9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      child: Center(
        child: Tab(
            child: Text(
              AppLocalizations.of(context)!.joined,
              style:
              GoogleFonts.poppins(color: Colors.white, fontSize: 15),
            )),
      ),
    );
  }
  // NOT JOINED
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        color: Color(0xFF00DC8D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
    ),
    child: Center(
      child: Tab(
          child: Text(
            AppLocalizations.of(context)!.join_now,
            style:
            GoogleFonts.poppins(color: Colors.white, fontSize: 15),
          )),
    ),
  );
}