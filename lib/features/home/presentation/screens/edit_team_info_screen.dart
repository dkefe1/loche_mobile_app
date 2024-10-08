import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/data/models/coach.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/home/presentation/widgets/coach_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/pajamas.dart';
import 'package:iconify_flutter/icons/ri.dart';

class EditTeamInfoScreen extends StatefulWidget {

  String teamName, tacticalStyle, teamId;
  Coach coach;

  EditTeamInfoScreen({super.key, required this.teamName, required this.coach, required this.tacticalStyle, required this.teamId});

  @override
  State<EditTeamInfoScreen> createState() => _EditTeamInfoScreenState();
}

class _EditTeamInfoScreenState extends State<EditTeamInfoScreen> {

  TextEditingController teamNameController = TextEditingController();
  TextEditingController tacticNameController = TextEditingController();

  bool isTeamNameEmpty = false;
  bool isTacticNameEmpty = false;
  bool isTacticalStyleEmpty = false;
  bool isCoachEmpty = false;
  bool isOther = false;
  bool autoFocusTextFormField = false;
  bool isTeamNameAvailable = true;
  bool isTeamNameLoading = false;

  final FocusNode _focusNode = FocusNode();
  bool _isFieldFocused = false;

  String? tacticalValue;
  List<String> tacticalStyles = ["Tiki-Taka", "Gegenpressing", "Parking The Bus", "Catenaccio", "Rush", "Other"];

  Coach? coachValue;
  List<Coach> coaches = [];

  bool isLoading = false;

  final prefs = PrefService();

  @override
  void initState() {
    teamNameController.text = widget.teamName;
    tacticNameController.text = widget.tacticalStyle;
    tacticalValue = widget.tacticalStyle;
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    setState(() {
      _isFieldFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    teamNameController.dispose();
    tacticNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          final checkAvailability = BlocProvider.of<TeamNameBloc>(context);
          checkAvailability.add(CheckTeamNameEvent(teamNameController.text));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<PatchTeamBloc, PatchTeamState>(builder: (_, state){
          return editInfoBody();
        }, listener: (_, state){
          if(state is PatchTeamSuccessfulState){
            isLoading = false;
            Navigator.pop(context);
            Navigator.pop(context);
            final getMyCoach = BlocProvider.of<MyCoachBloc>(context);
            getMyCoach.add(GetMyCoachEvent(coachValue!.id, false));
            final getClientTeam =
            BlocProvider.of<ClientTeamBloc>(context);
            getClientTeam.add(GetClientTeamEvent());
          } else if(state is PatchTeamFailedState){
            isLoading = false;
            errorFlashBar(context: context, message: state.error);
            return;
          } else if(state is PatchTeamLoadingState){
            isLoading = true;
          }
        }),
      ),
    );
  }

  Widget editInfoBody(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
      child: BlocConsumer<CoachBloc, CoachState>(
          listener: (_, state) async {
            if(state is GetCoachSuccessfulState){
              coaches = state.coaches;
              for(int i = 0; i<coaches.length; i++){
                if(coaches[i].id == widget.coach.id){
                  coachValue = coaches[i];
                  return;
                }
              }
            } else if(state is GetCoachFailedState){
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
            }
          },
          builder: (_, state) {
            if(state is GetCoachSuccessfulState) {
              return catgeoryBody();
            } else if(state is GetCoachLoadingState) {
              return categoriesLoading();
            } else if (state is GetCoachFailedState) {
              if(state.error == pinChangedMessage){
                return pinChangedErrorView(
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
                    });
              }
              return errorView(
                  iconPath: state.error == socketErrorMessage
                      ? "images/connection.png"
                      : "images/error.png",
                  title: "Ooops!",
                  text: state.error,
                  onPressed: () {
                    final getCoaches = BlocProvider.of<CoachBloc>(context);
                    getCoaches.add(GetCoachEvent());
                  });
            } else {
              return SizedBox();
            }
          }),);
  }

  Widget catgeoryBody(){
    return Column(
        children: [
          appHeader2(
              title: "Edit Preference",
              desc:
              "Edit your favourite football manager and tactical style"),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(defaultBorderRadius))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Informations",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<TeamNameBloc, TeamNameState>(builder: (_, state){
                      return teamNameWidget();
                    }, listener: (_, state) async {
                      isTeamNameLoading = false;
                      if(state is TeamNameSuccessfulState){
                        if(state.isAvailable){

                        } else {
                          isTeamNameAvailable = false;
                          setState(() {});
                        }
                      }

                      if(state is TeamNameLoadingState){
                        isTeamNameLoading = true;
                      } else if(state is TeamNameFailedState){
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
                      }
                    }),
                    isTeamNameEmpty
                        ? Text(
                      "Value can not be empty",
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    isTeamNameAvailable ? SizedBox() : Text(
                      "Team name already exists, please change the name!",
                      style: TextStyle(
                          color: dangerColor, fontSize: 12),
                    ),
                    SizedBox(height: 20,),
                    BlocConsumer<CoachBloc, CoachState>(
                        listener: (_, state) async {
                          if(state is GetCoachSuccessfulState){
                            coaches = state.coaches;
                          } else if(state is GetCoachFailedState){
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
                          }
                        },
                        builder: (_, state) {
                          if(state is GetCoachSuccessfulState) {
                            return buildInitialInput();
                          } else if(state is GetCoachLoadingState) {
                            return categoriesLoading();
                          } else if(state is GetCoachFailedState) {
                            if(state.error == pinChangedMessage){
                              return categoriesFailed(
                                  error: state.error,
                                  onPressed: () async {
                                    await prefs.signout();
                                    await prefs.removeToken();
                                    await prefs.removeCreatedTeam();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignInScreen()),
                                            (route) => false);
                                  });
                            }
                            return categoriesFailed(error: state.error, onPressed: (){
                              final getCoaches = BlocProvider.of<CoachBloc>(context);
                              getCoaches.add(GetCoachEvent());
                            });
                          } else {
                            return SizedBox();
                          }
                        }),
                    isCoachEmpty
                        ? Text(
                      "Value can not be empty",
                      style: TextStyle(
                          color: dangerColor, fontSize: 12),
                    )
                        : SizedBox(),
                    SizedBox(height: 20,),
                    isOther ? TextFormField(
                      autofocus: autoFocusTextFormField,
                      controller: tacticNameController,
                      onChanged: (value){
                        setState(() {
                          isTacticNameEmpty = false;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        filled: true,
                        fillColor: textFormFieldBackgroundColor,
                        hintText: "Your tactic style",
                        hintStyle: TextStyle(
                          fontSize: textFontSize2,
                          color: textColor,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius: BorderRadius.circular(textFormFieldRadius)),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              isOther = false;
                              tacticalValue = null;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Iconify(
                              Pajamas.retry,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 40),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textFormFieldBackgroundColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textFormFieldBackgroundColor),
                        ),
                      ),
                    ) : Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: textFormFieldBackgroundColor,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            value: tacticalValue,
                            isExpanded: true,
                            onTap: (){
                              if (_focusNode.hasFocus) {
                                _focusNode.unfocus();
                                final checkAvailability = BlocProvider.of<TeamNameBloc>(context);
                                checkAvailability.add(CheckTeamNameEvent(teamNameController.text));
                              }
                            },
                            hint: Text("Tactical Styles", style: TextStyle(
                                color: textColor,
                                fontSize: textFontSize2,
                                fontWeight: FontWeight.w500),),
                            items: tacticalStyles.map(buildMenuTacticalStyles).toList(),
                            icon: Iconify(
                              MaterialSymbols.arrow_drop_down_rounded,
                              color: primaryColor,
                              size: 30,
                            ),
                            onChanged: (value) {
                              setState(() {
                                if(value == "Other"){
                                  setState(() {
                                    isOther = true;
                                    autoFocusTextFormField = true;
                                  });
                                } else {
                                  tacticNameController.text = value!;
                                }
                                this.tacticalValue = value;
                                isTacticalStyleEmpty = false;
                              });
                            }),
                      ),
                    ),
                    isTacticNameEmpty
                        ? Text(
                      "Value can not be empty",
                      style: TextStyle(
                          color: dangerColor, fontSize: 12),
                    )
                        : SizedBox(),
                    isTacticalStyleEmpty
                        ? Text(
                      "Value can not be empty",
                      style: TextStyle(
                          color: dangerColor, fontSize: 12),
                    )
                        : SizedBox(),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: ElevatedButton(
                onPressed: isTeamNameLoading ? null : (){
                  if(teamNameController.text.isEmpty){
                    return setState(() {
                      isTeamNameEmpty = true;
                    });
                  }
                  if(coachValue == null){
                    return setState(() {
                      isCoachEmpty = true;
                    });
                  }
                  if(tacticalValue == null){
                    return setState(() {
                      isTacticalStyleEmpty = true;
                    });
                  }
                  if(tacticNameController.text.isEmpty){
                    return setState(() {
                      isTacticNameEmpty = true;
                    });
                  }

                  if(isOther){
                    final patchTeam = BlocProvider.of<PatchTeamBloc>(context);
                    patchTeam.add(UpdateTeamEvent(coachValue!.id, tacticNameController.text, widget.teamId));
                  } else {
                    final patchTeam = BlocProvider.of<PatchTeamBloc>(context);
                    patchTeam.add(UpdateTeamEvent(coachValue!.id, tacticalValue!, widget.teamId));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  side: BorderSide(color: primaryColor, width: 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                child: isLoading ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(color: onPrimaryColor,)) : Text("Edit", style: TextStyle(color: onPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500),)),
          ),
        ]);
  }

  DropdownMenuItem<String> buildMenuTacticalStyles(String tactic) =>
      DropdownMenuItem(
          value: tactic,
          child: Text(
            tactic,
            style: TextStyle(
                color: primaryColor,
                fontSize: textFontSize2,
                fontWeight: FontWeight.w500),
          ));

  DropdownMenuItem<Coach> buildMenuCoaches(Coach coach) =>
      DropdownMenuItem(
          value: coach,
          child: Padding(
            padding: EdgeInsets.only(bottom: coachValue != null ? coachValue! == coach ? 0 : 10.0 : 10.0),
            child: coachWidget(imagePath: coach.image_secure_url, name: coach.coach_name),
          ));

  Widget categoriesLoading(){
    return Column(
        children: [
          appHeader2(
              title: "Create Preference",
              desc:
              "Choose your favourite football manager, tactical style and name your team"),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(defaultBorderRadius))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    BlinkContainer(width: 150, height: 30, borderRadius: 0),
                    SizedBox(
                      height: 20,
                    ),
                    BlinkContainer(width: double.infinity, height: 60, borderRadius: 10),
                    SizedBox(height: 20,),
                    BlinkContainer(width: double.infinity, height: 60, borderRadius: 10),
                    SizedBox(height: 20,),
                    BlinkContainer(width: double.infinity, height: 60, borderRadius: 10),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: BlinkContainer(width: double.infinity, height: 50, borderRadius: 10),
          ),
        ]);
  }

  Widget categoriesFailed({required String error, required VoidCallback onPressed}){
    return Container(
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: lightPrimary,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Expanded(child: Text(error, style: TextStyle(color: dangerColor, fontSize: 14),)),
          SizedBox(width: 10,),
          GestureDetector(
              onTap: (){
                onPressed();
              },
              child: Iconify(Mdi.reload, color: primaryColor, size: 20,)),
        ],
      ),
    );
  }

  Widget buildInitialInput(){
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: textFormFieldBackgroundColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Coach>(
            itemHeight: null,
            padding: EdgeInsets.zero,
            value: coachValue,
            onTap: (){
              if (_focusNode.hasFocus) {
                _focusNode.unfocus();
                final checkAvailability = BlocProvider.of<TeamNameBloc>(context);
                checkAvailability.add(CheckTeamNameEvent(teamNameController.text));
              }
            },
            isDense: true,
            isExpanded: true,
            hint: Container(
              height: 50,
              color: Color(0xFF1E727E).withOpacity(0.04),
              child: Row(
                children: [
                  SizedBox(width: 10,),
                  Image.asset("images/leader.png", width: 40, height: 40, fit: BoxFit.cover,),
                  SizedBox(width: 10,),
                  Text("Select Your Favourite Coach", style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            items: coaches.map(buildMenuCoaches).toList(),
            icon: Iconify(
              MaterialSymbols.arrow_drop_down_rounded,
              color: primaryColor,
              size: 30,
            ),
            onChanged: (value) {
              setState(() {
                coachValue = value;
                isCoachEmpty = false;
                print(value);
              });
            }),
      ),
    );
  }

  Widget teamNameWidget() {
    return TextFormField(
      enabled: false,
      autofocus: false,
      focusNode: _focusNode,
      controller: teamNameController,
      onChanged: (value){
        setState(() {
          isTeamNameEmpty = false;
          isTeamNameAvailable = true;
        });
      },
      onFieldSubmitted: (value){
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          final checkAvailability = BlocProvider.of<TeamNameBloc>(context);
          checkAvailability.add(CheckTeamNameEvent(teamNameController.text));
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        filled: true,
        fillColor: textFormFieldBackgroundColor,
        hintText: "Team Name",
        hintStyle: TextStyle(
          fontSize: textFontSize2,
          color: textColor,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(textFormFieldRadius)),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: isTeamNameLoading ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,),) : Iconify(
            Ri.team_fill,
            color: textColor,
          ),
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 40),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
        ),
      ),
    );
  }

}
