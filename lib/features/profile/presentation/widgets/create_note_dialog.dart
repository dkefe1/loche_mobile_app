import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget createNoteDialog({required TextEditingController notesController, required BuildContext context}) {
  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: BlocConsumer<PostNoteBloc, PostNoteState>(
        listener: (_, state){
          if (state is PostNoteLoadingState) {

          } else if (state is PostNoteSuccessfulState) {
            final getNotes = BlocProvider.of<NotesBloc>(context);
            getNotes.add(GetAllNotesEvent());
            Navigator.pop(context);
          } else if (state is PostNoteFailedState) {
            errorFlashBar(context: context, message: state.error);
          }
        }, builder: (_, state) {
          if(state is PostNoteLoadingState){
            return createNoteBody(notesController: notesController, context: context, isLoading: true);
          } else {
            return createNoteBody(notesController: notesController, context: context, isLoading: false);
          }
    }),
  );
}

Widget createNoteBody({required TextEditingController notesController, required BuildContext context, required bool isLoading}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.close)),
        ),
        SizedBox(height: 10,),
        Text(
          AppLocalizations.of(context)!.create_a_note.toUpperCase(),
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w400,
              fontSize: textFontSize),
        ),
        SizedBox(height: 10,),
        TextFormField(
          controller: notesController,
          maxLines: 7,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              filled: true,
              fillColor: lightPrimary,
              hintStyle: TextStyle(
                fontSize: textFontSize2,
                color: textColor,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(textFormFieldRadius),
                  borderSide: BorderSide.none
              )
          ),
        ),
        SizedBox(height: 30,),
        isLoading ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                onPressed: (){},
                child: SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0,)))) : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                onPressed: (){
                  if(notesController.text.isEmpty){
                    errorFlashBar(context: context, message: "Note can not be empty");
                    return;
                  }
                  if(notesController.text.length < 2){
                    errorFlashBar(context: context, message: "Note must be at least 2 characters long");
                    return;
                  }
                  final postNote = BlocProvider.of<PostNoteBloc>(context);
                  postNote.add(CreateNoteEvent(notesController.text));
                  notesController.clear();
                },
                child: Text(AppLocalizations.of(context)!.add_note, style: TextStyle(color: Colors.white),))),
        SizedBox(height: 20,),
      ],
    ),
  );
}