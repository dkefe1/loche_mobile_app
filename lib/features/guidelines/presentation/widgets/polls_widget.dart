import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/guidelines/data/models/poll_model.dart';
import 'package:fantasy/features/guidelines/data/models/user_poll.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

String calculatePercent(num totalSelection, num selectedAmount){
  num percent = (selectedAmount/totalSelection) * 100;
  if(totalSelection == 0){
    return "0%";
  }
  return "${percent.toStringAsFixed(1)}%";
}

double percentInDouble(num totalSelection, num selectedAmount){
  if(totalSelection == 0){
    return 0;
  }
  double percent = (selectedAmount/totalSelection);
  return percent;
}

Widget pollsWidget({required PollModel poll, required List<UserPoll> userPolls}){

  num totalSelection = 0;
  for(int i = 0; i<poll.pollChoice.length; i++){
    totalSelection += poll.pollChoice[i].selected_by;
  }

  bool isClicked = false;
  for(int i=0; i<userPolls.length; i++){
    if(userPolls[i].pol_id == poll.id){
      isClicked = true;
    }
  }

  return Container(
    padding: EdgeInsets.all(15),
    margin: EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
        color: lightPrimary,
        borderRadius: BorderRadius.circular(20)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
                color: poll.status == "Open" ? Colors.greenAccent : surfaceColor,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(poll.status == "Open" ? "Open" : "Closed"),
          ),
        ),
        SizedBox(height: 10,),
        Text(
          poll.question,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        SizedBox(height: 15,),
        poll.status == "Open" ? ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: poll.pollChoice.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index){

              bool isChosen = false;
              for(int i=0; i<userPolls.length; i++){
                if(userPolls[i].choice_id == poll.pollChoice[index].id){
                  isChosen = true;
                  break;
                }
              }

              return GestureDetector(
                onTap: isClicked ? null : (){
                  final patchPoll = BlocProvider.of<PatchPollsBloc>(context);
                  patchPoll.add(ChoosePollsEvent(poll.id, poll.pollChoice[index].id));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  margin: EdgeInsets.only(bottom: 13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor, width: 1.5)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: primaryColor, width: 1.0)
                                ),
                                child: Center(child: isClicked ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: isChosen ? primaryColor : Colors.grey,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ) : SizedBox(),),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                poll.pollChoice[index].choice,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ],
                          ),
                          isClicked ? Text(
                            calculatePercent(totalSelection, poll.pollChoice[index].selected_by),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ) : SizedBox(),
                        ],),
                      isClicked ? SizedBox(height: 15,) : SizedBox(),
                      isClicked ? totalSelection == poll.pollChoice[index].selected_by ? Container(
                        height: 7,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15)
                        ),
                      ) : Row(
                        children: [
                          Expanded(
                            child: new LinearPercentIndicator(
                              animation: true,
                              lineHeight: 7.0,
                              animationDuration: 2000,
                              percent: percentInDouble(totalSelection, poll.pollChoice[index].selected_by),
                              barRadius: Radius.circular(15),
                              progressColor: primaryColor,
                            ),
                          ),
                        ],
                      ) : SizedBox()
                    ],
                  ),
                ),
              );
            }) : ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: poll.pollChoice.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index){

              bool isChosen = false;
              for(int i=0; i<userPolls.length; i++){
                if(userPolls[i].choice_id == poll.pollChoice[index].id){
                  isChosen = true;
                  break;
                }
              }

              return GestureDetector(
                onTap: poll.status == "Closed" ? null : (){
                  final patchPoll = BlocProvider.of<PatchPollsBloc>(context);
                  patchPoll.add(ChoosePollsEvent(poll.id, poll.pollChoice[index].id));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  margin: EdgeInsets.only(bottom: 13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor, width: 1.5)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: primaryColor, width: 1.0)
                                ),
                                child: Center(child: isClicked ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: isChosen ? primaryColor : Colors.grey,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ) : SizedBox(),),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                poll.pollChoice[index].choice,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ],
                          ),
                          Text(
                            calculatePercent(totalSelection, poll.pollChoice[index].selected_by),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],),
                      SizedBox(height: 15,),
                      totalSelection == poll.pollChoice[index].selected_by ? Container(
                        height: 7,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15)
                        ),
                      ) : Row(
                        children: [
                          Expanded(
                            child: new LinearPercentIndicator(
                              animation: true,
                              lineHeight: 7.0,
                              animationDuration: 2000,
                              percent: percentInDouble(totalSelection, poll.pollChoice[index].selected_by),
                              barRadius: Radius.circular(15),
                              progressColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        Align(
            alignment: Alignment.bottomRight,
            child: Text("${totalSelection} votes"))
      ],
    ),
  );
}