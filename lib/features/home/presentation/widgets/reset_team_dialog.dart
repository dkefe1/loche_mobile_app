import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/screens/reset_team_build_screen.dart';
import 'package:flutter/material.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget resetTeamDialog({required BuildContext context, required VoidCallback onPressed}) {

  bool isLoading = false;

  return BlocConsumer<ResetTeamBloc, ResetTeamState>(builder: (_, state){
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("Reset Team", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Color(0xFF23262F)),)),
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
            SizedBox(height: 20,),
            Text(
              "Are you sure you want to reset your team?",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: textFontSize2, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD9D9D9)
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Cancel", style: TextStyle(color: textBlackColor),))),
                SizedBox(width: 15,),
                Expanded(child: isLoading ? loadingButton() : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: dangerColor2
                    ),
                    onPressed: (){
                      onPressed();
                    }, child: Text("Reset", style: TextStyle(color: onPrimaryColor),))),
              ],
            )
          ],
        ),
      ),
    );
  }, listener: (_, state) async {
    isLoading = false;
    if(state is ResetTeamLoadingState){
      isLoading = true;
    } else if(state is ResetTeamSuccessfulState){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ResetTeamBuildScreen()), (route) => false);
    } else if(state is ResetTeamFailedState){
      errorFlashBar(context: context, message: state.error);
      return;
    }
  });
}
