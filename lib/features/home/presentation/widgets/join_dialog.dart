import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/profile/presentation/screens/package_choice_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget joinDialog({required BuildContext context, required bool isFree, required VoidCallback onPressed, required String phoneNumber}) {
  return BlocConsumer<JoinGameWeekTeamBloc, JoinGameWeekTeamState>(builder: (_, state){
    if(state is PostJoinGameWeekTeamLoadingState){
      return joinDialogBody(context: context, isFree: isFree, onPressed: onPressed, isLoading: true, phoneNumber: phoneNumber);
    } else {
      return joinDialogBody(context: context, isFree: isFree, onPressed: onPressed, isLoading: false, phoneNumber: phoneNumber);
    }
  }, listener: (_, state){
    if(state is PostJoinGameWeekTeamSuccessfulState){
      final getClientTeam = BlocProvider.of<ClientTeamBloc>(context);
      getClientTeam.add(GetClientTeamEvent());
      Navigator.pop(context);
    }
  });
}

Widget joinDialogBody({required BuildContext context, required bool isFree, required VoidCallback onPressed, required bool isLoading, required String phoneNumber}){
  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Don’t miss out this week", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Color(0xFF23262F)),)),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Color(0xFFDFDFE6))
                    ),
                    child: Center(
                      child: Icon(Icons.close, size: 15, color: textBlackColor,),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15,),
          Text("Embark on a week of adventure seize the magic, join the game week, and let the epic journey unfold!⚽️", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF87898E), fontSize: 14),),
          SizedBox(height: 10,),
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset("images/join_dialog.png", fit: BoxFit.fill, width: double.infinity, height: 150,)),
          SizedBox(height: 20,),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      )
                  ),
                  onPressed: (){
                    onPressed();
                  }, child: isLoading ? SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(color: Colors.white,)) : Text(isFree ? "Join For Free" : "Join", style: TextStyle(color: Colors.white),))),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("want to save some money ?", style: TextStyle(color: Color(0xFF23262F), fontSize: 12),),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PackageChoiceScreen(autoJoin: true, phoneNumber: phoneNumber,)));
                  },
                  child: Text(" Buy Package", style: TextStyle(color: Color(0xFF3772FF), fontSize: 12),)),
            ],
          )
        ],
      ),
    ),
  );
}