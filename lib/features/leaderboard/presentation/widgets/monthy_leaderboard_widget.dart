import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leader.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/monthly_container.dart';
import 'package:flutter/material.dart';

Widget monthlyLeaderBoardWidget({required List<MonthlyLeader> leaderBoard, required bool hasMore, required ScrollController controller}) {
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
              return monthlyLeaderContainer(contestor: leaderBoard[index], context: context);
            } else {
              return hasMore ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,)),
                ),
              ) : Text("Total number of contestants reached");
            }
          }),
    ],
  );
}