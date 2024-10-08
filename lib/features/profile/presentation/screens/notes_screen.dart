import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/no_data_widget.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/data/models/notes.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/widgets/create_note_dialog.dart';
import 'package:fantasy/features/profile/presentation/widgets/delete_all_note_dialog.dart';
import 'package:fantasy/features/profile/presentation/widgets/notes_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  TextEditingController notesController = TextEditingController();
  TextEditingController createNoteController = TextEditingController();

  final prefs = PrefService();

  bool showFloatButton = true;

  @override
  void dispose() {
    notesController.dispose();
    createNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
    GestureDetector(
        onPanUpdate: (details) async {
          if (details.delta.dx > 30) {
            final getNotes = BlocProvider.of<NotesBloc>(context);
            getNotes.add(GetAllNotesEvent());
            Navigator.of(context).pop();
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: primaryScreen(),
        )
    )
        : WillPopScope(
      onWillPop: () async {
        final getNotes = BlocProvider.of<NotesBloc>(context);
        getNotes.add(GetAllNotesEvent());
        return true;
      },
      child: primaryScreen(),
    );
  }

  Widget primaryScreen(){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            AppHeader(
                title: "",
                desc:
                AppLocalizations.of(context)!.notes_g),
            Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BlocConsumer<NotesBloc, NotesState>(
                            listener: (_, state) async {
                              if(state is GetAllNotesFailedState){
                                setState(() {
                                  showFloatButton = false;
                                });
                                if(state.error == jwtExpired || state.error == doesNotExist){
                                  await prefs.signout();
                                  await prefs.removeToken();
                                  await prefs.removeCreatedTeam();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignInScreen()),
                                          (route) => false);
                                }
                              } else if(state is GetAllNotesSuccessfulState) {
                                setState(() {
                                  showFloatButton = true;
                                });
                              } else {
                                setState(() {
                                  showFloatButton = false;
                                });
                              }
                            },
                            builder: (_, state) {
                              if (state is GetAllNotesSuccessfulState) {
                                return state.notes.isEmpty ? Center(child: noDataWidget(icon: GameIcons.notebook, message: AppLocalizations.of(context)!.you_have_not_yet_created_a_note_g, iconSize: 120, iconColor: textColor)) : buildInitialInput(notes: state.notes);
                              } else if (state is GetAllNotesLoadingState) {
                                return notesLoading();
                              } else if (state is GetAllNotesFailedState) {
                                if(state.error == pinChangedMessage){
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 60.0),
                                    child: pinChangedErrorView(
                                        iconPath: state.error == socketErrorMessage
                                            ? "images/connection.png"
                                            : "images/error.png",
                                        title: "Ooops!",
                                        text: state.error,
                                        onPressed: () async {
                                          await prefs.signout();
                                          await prefs.removeToken();
                                          await prefs.removeCreatedTeam();
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SignInScreen()),
                                                  (route) => false);
                                        }),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 60.0),
                                  child: errorView(
                                      iconPath: state.error == socketErrorMessage
                                          ? "images/connection.png"
                                          : "images/error.png",
                                      title: "Ooops!",
                                      text: state.error,
                                      onPressed: () {
                                        final getAllNotes =
                                        BlocProvider.of<NotesBloc>(context);
                                        getAllNotes.add(GetAllNotesEvent());
                                      }),
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: showFloatButton ? Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10),
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: (){
            showDialog(context: context, barrierDismissible: false, builder: (context){
              return createNoteDialog(notesController: createNoteController, context: context);
            });
          },
          child: Icon(Icons.add),),
      ) : null,
    );
  }

  Widget buildInitialInput({required List<Notes> notes}){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.notes_g.toUpperCase(),
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w400,
                      fontSize: textFontSize),
                ),
                GestureDetector(
                  onTap: (){
                    showDialog(context: context, builder: (BuildContext context){
                      return deleteAllNoteDialog(context: context, content: AppLocalizations.of(context)!.are_you_sure_to_delete_notes);
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.delete_all.toUpperCase(),
                    style: TextStyle(
                        color: dangerColor2,
                        fontWeight: FontWeight.w400,
                        fontSize: textFontSize),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Divider(color: Color(0xFF1E727E).withOpacity(0.3), thickness: 1.0,),
          ListView.builder(
              itemCount: notes.length,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index){
                return BlocConsumer<PatchNoteBloc, PatchNoteState>(builder: (_, state){
                  return notesBox(context: context, note: notes[index], notesController: notesController, onPressed: (){
                    setState(() {
                      notesController.text = notes[index].note;
                      notes[index].isEdit = !notes[index].isEdit;
                    });
                  });
                }, listener: (_, state){
                  if (state is PatchNoteLoadingState) {
                    notes[index].isLoading = true;
                  } else if (state is PatchNoteSuccessfulState) {
                    notes[index].isLoading = false;
                    final getNotes = BlocProvider.of<NotesBloc>(context);
                    getNotes.add(GetAllNotesEvent());
                  } else if (state is PatchNoteFailedState) {
                    errorFlashBar(context: context, message: state.error);
                  }
                });
              }),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget notesLoading(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            BlinkContainer(width: 100, height: 30, borderRadius: 0),
            SizedBox(height: 10,),
            BlinkContainer(width: double.infinity, height: 100, borderRadius: 8),
            SizedBox(height: 20,),
            BlinkContainer(width: double.infinity, height: 150, borderRadius: 8),
            SizedBox(height: 20,),
            BlinkContainer(width: double.infinity, height: 200, borderRadius: 8),
            SizedBox(height: 20,),
            BlinkContainer(width: double.infinity, height: 200, borderRadius: 8),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

}
