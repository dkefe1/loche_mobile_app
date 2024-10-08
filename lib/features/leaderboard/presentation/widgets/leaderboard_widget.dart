import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/leaderboard/data/models/leaderboard.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/leader_container.dart';
import 'package:flutter/material.dart';

Widget leaderBoardWidget({required List<Leaderboard> leaderBoard, required String gameWeekId, required bool hasMore, required ScrollController controller, required bool hasStarted}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListView.builder(
        controller: controller,
        padding: EdgeInsets.zero,
          itemCount: leaderBoard.length + 1,
          shrinkWrap: true,
          itemBuilder: (context, index){
          if(index < leaderBoard.length){
            return leaderContainer(contestor: leaderBoard[index], context: context, gameWeekId: gameWeekId, hasStarted: hasStarted);
          } else {
            return hasMore ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,)),
              ),
            ) : Center(child: Text("Total number of contestants reached", style: TextStyle(color: primaryColor),));
          }
      }),
    ],
  );
}