import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_bloc.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_event.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_state.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/reset_success_screen.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/common_widgets/password_textformfield.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPinScreen extends StatefulWidget {

  final String phoneNumber;
  ResetPinScreen({super.key, required this.phoneNumber});

  @override
  State<ResetPinScreen> createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final changePinFormkey = GlobalKey<FormState>();

  bool isPasswordDifferent = false;
  bool isLoading = false;
  bool isPinEmpty = false;
  bool isConfirmPinEmpty = false;
  bool isPinInValid = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
          builder: (_, state) {
            return buildInitialInput();
          },
          listener: (_, state) {
            if (state is ResetPinLoadingState) {
              isLoading = true;
            } else if (state is ResetPinSuccessfulState) {
              isLoading = false;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResetSuccessScreen()));
            } else if (state is ResetPinFailedState) {
              isLoading = false;
              errorFlashBar(context: context, message: state.error);
            }
          }),
    );
  }

  Widget buildInitialInput() {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Form(
      key: changePinFormkey,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(defaultBorderRadius)),
                child: Image.asset("images/splash.png", width: w, height: h/2 + 60, fit: BoxFit.cover,)),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: logoName(),
              ),
            ),
            Container(
              height: h / 1.2,
              width: w,
              margin: EdgeInsets.fromLTRB(15, 150, 15, 0),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(defaultBorderRadius))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.change_password,
                      style: TextStyle(
                          color: headerColor,
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      AppLocalizations.of(context)!.please_create_and_confirm,
                      style: TextStyle(
                          color: textColor, fontSize: textFontSize),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    PasswordTextFormField(
                        passwordController: passwordController,
                        hintText: AppLocalizations.of(context)!.pin,
                        autoFocus: true, onInteraction: (){
                      setState(() {
                        isPinEmpty = false;
                      });
                    }
                    ),
                    isPinEmpty
                        ? Text(
                      AppLocalizations.of(context)!.value_can_not_be_empty,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    isPinInValid
                        ? Text(
                      AppLocalizations.of(context)!.pin_can_not_be_less_than_4_characters,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    PasswordTextFormField(
                        passwordController: confirmPasswordController,
                        hintText: AppLocalizations.of(context)!.confirm_pin,
                        autoFocus: false, onInteraction: (){
                      setState(() {
                        isConfirmPinEmpty = false;
                      });
                    }
                    ),
                    isConfirmPinEmpty
                        ? Text(
                      AppLocalizations.of(context)!.value_can_not_be_empty,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    isPasswordDifferent
                        ? Text(
                      AppLocalizations.of(context)!.both_pins_must_be_the_same,
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
                              if (changePinFormkey.currentState!.validate()) {
                                if(passwordController.text.isEmpty){
                                  return setState(() {
                                    isPinEmpty = true;
                                  });
                                }
                                if(confirmPasswordController.text.isEmpty){
                                  return setState(() {
                                    isConfirmPinEmpty = true;
                                  });
                                }
                                if(passwordController.text.length < 4){
                                  return setState(() {
                                    isPinInValid = true;
                                  });
                                } else {
                                  setState(() {
                                    isPinInValid = false;
                                  });
                                }
                                if (passwordController.text == confirmPasswordController.text) {
                                  setState(() {
                                    isPasswordDifferent = false;
                                  });
                                } else {
                                  return setState(() {
                                    isPasswordDifferent = true;
                                  });
                                }

                                final resetPin = BlocProvider.of<LoginBloc>(context);
                                resetPin.add(ResetPin(passwordController.text, confirmPasswordController.text, widget.phoneNumber));
                              }
                            },
                            text: AppLocalizations.of(context)!.save,
                            disabled: false)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
