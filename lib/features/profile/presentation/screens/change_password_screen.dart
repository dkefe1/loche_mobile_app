import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/password_textformfield.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/data/models/update_pin.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  TextEditingController olderPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordDifferent = false;
  bool isLoading = false;
  bool isOlderPinEmpty = false;
  bool isNewPinEmpty = false;
  bool isConfirmPinEmpty = false;
  bool isOlderPinInValid = false;
  bool isNewPinInValid = false;

  final prefs = PrefService();

  @override
  void dispose() {
    olderPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UpdatePinBloc, UpdatePinState>(
          builder: (_, state) {
            return buildInitialInput();
          }, listener: (_, state) async {
        if (state is UpdatePinLoadingState) {
          isLoading = true;
        } else if (state is UpdatePinSuccessfulState) {
          isLoading = false;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()), (route) => false);
        } else if (state is UpdatePinFailedState) {
          isLoading = false;
          if(state.error == jwtExpired || state.error == doesNotExist){
            await prefs.signout();
            await prefs.removeToken();
            await prefs.removeCreatedTeam();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => SignInScreen()),
                    (route) => false);
          } else {
            errorFlashBar(context: context, message: state.error);
          }
        }
      }),
    );
  }

  Widget buildInitialInput() {
    return Container(
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
              "Take control of your profile, rewards, and credits - unleash the power of customization and enjoy the full experience!"),
          Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(defaultBorderRadius))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40,),
                      Text(
                        "Change Pin".toUpperCase(),
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: textFontSize),
                      ),
                      SizedBox(height: 15,),
                      PasswordTextFormField(
                          passwordController: olderPasswordController,
                          hintText: "Older Pin",
                          autoFocus: true, onInteraction: (){
                        setState(() {
                          isOlderPinEmpty = false;
                        });
                      }
                      ),
                      isOlderPinEmpty
                          ? Text(
                        "Value can not be empty",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      isOlderPinInValid
                          ? Text(
                        "Pin can not be less than 4 characters",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      SizedBox(height: 15,),
                      PasswordTextFormField(
                          passwordController: newPasswordController,
                          hintText: "New Pin",
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isNewPinEmpty = false;
                        });
                      }
                      ),
                      isNewPinEmpty
                          ? Text(
                        "Value can not be empty",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      isNewPinInValid
                          ? Text(
                        "Pin can not be less than 4 characters",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 15,
                      ),
                      PasswordTextFormField(
                          passwordController: confirmPasswordController,
                          hintText: "Confirm Pin",
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isConfirmPinEmpty = false;
                        });
                      }
                      ),
                      isConfirmPinEmpty
                          ? Text(
                        "Value can not be empty",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      isPasswordDifferent
                          ? Text(
                        "Both pins must be the same",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 50,
                      ),
                      isLoading ? loadingButton() : SizedBox(
                          width: double.infinity,
                          child: submitButton(
                              onPressed: () {
                                if(olderPasswordController.text.isEmpty){
                                  return setState(() {
                                    isOlderPinEmpty = true;
                                  });
                                }
                                if(newPasswordController.text.isEmpty){
                                  return setState(() {
                                    isNewPinEmpty = true;
                                  });
                                }
                                if(confirmPasswordController.text.isEmpty){
                                  return setState(() {
                                    isConfirmPinEmpty = true;
                                  });
                                }

                                if(olderPasswordController.text.length < 4){
                                  return setState(() {
                                    isOlderPinInValid = true;
                                  });
                                } else {
                                  setState(() {
                                    isOlderPinInValid = false;
                                  });
                                }

                                if(newPasswordController.text.length < 4){
                                  return setState(() {
                                    isNewPinInValid = true;
                                  });
                                } else {
                                  setState(() {
                                    isNewPinInValid = false;
                                  });
                                }
                                if (newPasswordController.text == confirmPasswordController.text) {
                                  setState(() {
                                    isPasswordDifferent = false;
                                  });
                                } else {
                                  return setState(() {
                                    isPasswordDifferent = true;
                                  });
                                }
                                final updatePin = BlocProvider.of<UpdatePinBloc>(context);
                                updatePin.add(PatchPinEvent(UpdatePin(current_pin: olderPasswordController.text, pin: newPasswordController.text, pin_confirm: confirmPasswordController.text)));
                              },
                              text: "Save",
                              disabled: false)),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
