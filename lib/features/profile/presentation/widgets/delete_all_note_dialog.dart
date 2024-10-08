import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget deleteAllNoteDialog({required BuildContext context, required String content}) {
  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: BlocConsumer<DeleteAllNoteBloc, DeleteAllNoteState>(
        listener: (_, state){
          if (state is DeleteAllNoteLoadingState) {

          } else if (state is DeleteAllNoteSuccessfulState) {
            final getNotes = BlocProvider.of<NotesBloc>(context);
            getNotes.add(GetAllNotesEvent());
            Navigator.pop(context);
          } else if (state is DeleteAllNoteFailedState) {
            errorFlashBar(context: context, message: state.error);
          }
        }, builder: (_, state) {
      if(state is DeleteAllNoteLoadingState){
        return deleteAllNotesBody(context: context, content: content, isLoading: true);
      } else {
        return deleteAllNotesBody(context: context, content: content, isLoading: false);
      }
    }),
  );
}

Widget deleteAllNotesBody({required BuildContext context, required String content, required bool isLoading}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10,),
        Text(
          content,
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
            Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: dangerColor2
                ),
                onPressed: (){
                  final deleteAllNotes = BlocProvider.of<DeleteAllNoteBloc>(context);
                  deleteAllNotes.add(RemoveAllNoteEvent());
                }, child: isLoading ? SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(color: onPrimaryColor, strokeWidth: 2.0,),) : Text("Delete", style: TextStyle(color: onPrimaryColor),))),
          ],
        )
      ],
    ),
  );
}
