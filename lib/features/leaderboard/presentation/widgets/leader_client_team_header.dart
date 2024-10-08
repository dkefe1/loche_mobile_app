import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/home/presentation/widgets/joined_game_week_modal.dart';
import 'package:fantasy/features/leaderboard/data/models/leaderboard.dart';
import 'package:flutter/material.dart';

class LeaderClientTeamHeader extends StatelessWidget {

  Leaderboard contestor;
  LeaderClientTeamHeader({Key? key, required this.contestor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context, builder: (BuildContext context){
                    return joinedGameWeekModalSheet(context: context, gameWeekId: "");
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        logoName(),
                      ],
                    ),
                  ],
                ),
              ),
              Text("Total FP : ${contestor.total_fantasy_point}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),)
            ],
          ),
          SizedBox(height: 10,),
          Text("${contestor.client_id.full_name}'s Team", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),)
        ],
      ),
    );
  }
}
