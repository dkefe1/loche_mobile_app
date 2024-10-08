import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/profile/data/models/notes.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/widgets/delete_note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ri.dart';

Widget notesBox({required BuildContext context, required Notes note, required TextEditingController notesController, required VoidCallback onPressed}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
    decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: Color(0xFF1E727E).withOpacity(0.3), width: 1.0))
    ),
    child: note.isEdit ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
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
        ),
        SizedBox(height: 5,),
        Align(
            alignment: Alignment.topRight,
            child: note.isLoading ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2.0,)) : GestureDetector(
                onTap: (){
                  final patchNote = BlocProvider.of<PatchNoteBloc>(context);
                  patchNote.add(UpdateNoteEvent(note.id, notesController.text));
                },
                child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Center(child: Iconify(Ic.sharp_done, color: Colors.white, size: 20,))))),
      ],
    ) : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            note.note,
            style: TextStyle(
              color: textBlackColor,
              fontSize: textFontSize2,
            ),
          ),
        ),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: (){
                  onPressed();
                },
                child: Iconify(Ri.edit_box_line, color: primaryColor, size: 20,)),
            SizedBox(width: 10,),
            GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return deleteNoteDialog(context: context, onPressed: (){
                      final deleteNote = BlocProvider.of<DeleteNoteBloc>(context);
                      deleteNote.add(RemoveNoteEvent(note.id));
                    }, content: "Are you sure you want to delete this note?");
                  });
                },
                child: Iconify(Ic.baseline_delete_outline, color: dangerColor2, size: 20,))
          ],
        ),
      ],
    ),
  );
}
