import 'dart:async';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_bloc.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_event.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_state.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/reset_pin_screen.dart';
import 'package:fantasy/features/auth/signup/presentation/widgets/otp_textformfield.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/common_widgets/success_flashbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckOtpScreen extends StatefulWidget {

  String phoneNumber;

  CheckOtpScreen({required this.phoneNumber, super.key});

  @override
  State<CheckOtpScreen> createState() => _CheckOtpScreenState();
}

class _CheckOtpScreenState extends State<CheckOtpScreen> {
  TextEditingController pinController1 = TextEditingController();

  TextEditingController pinController2 = TextEditingController();

  TextEditingController pinController3 = TextEditingController();

  TextEditingController pinController4 = TextEditingController();

  TextEditingController pinController5 = TextEditingController();

  bool isPinEmpty = false;
  bool isIncorrect = false;
  bool isLoading = false;
  bool isOtpSent = true;

  int _start = 60;
  Timer? _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start < 1) {
          isOtpSent = false;
          _timer!.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    pinController1.dispose();
    pinController2.dispose();
    pinController3.dispose();
    pinController4.dispose();
    pinController5.dispose();
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
          builder: (_, state){
            return buildInitialInput();
          },
          listener: (_, state){
            if(state is VerifyPinLoadingState){
              isLoading = true;
            } else if(state is VerifyPinSuccessfulState) {
              isLoading = false;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPinScreen(phoneNumber: widget.phoneNumber,)));
            } else if(state is VerifyPinFailedState) {
              isLoading = false;
              errorFlashBar(context: context, message: state.error);
            } else if(state is ForgotPinFailedState) {
              isLoading = false;
              setState(() {
                isOtpSent = false;
              });
              errorFlashBar(context: context, message: state.error);
            } else if(state is ResendOtpSuccessfulState) {
              isLoading = false;
              successFlashBar(context: context, message: AppLocalizations.of(context)!.otp_resent_successfully);
            }
          }),
    );
  }

  Widget buildInitialInput() {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
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
                    AppLocalizations.of(context)!.verify_phone_number,
                    style: TextStyle(
                        color: headerColor,
                        fontSize: headerFontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.we_have_sent_to} ${widget.phoneNumber}",
                    style: TextStyle(
                        color: textColor, fontSize: textFontSize),
                  ),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(child: otpTextFormField(context: context, pinController: pinController1)),
                      Expanded(child: otpTextFormField(context: context, pinController: pinController2)),
                      Expanded(child: otpTextFormField(context: context, pinController: pinController3)),
                      Expanded(child: otpTextFormField(context: context, pinController: pinController4)),
                      Expanded(child: otpTextFormField(context: context, pinController: pinController5)),
                    ],
                  ),
                  isPinEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.please_fill_all_the_fields,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    ),
                  )
                      : SizedBox(),
                  isIncorrect
                      ? Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.pin_is_wrong,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    ),
                  )
                      : SizedBox(),
                  SizedBox(height: 40,),
                  isLoading ? loadingButton() : SizedBox(
                      width: double.infinity,
                      child: submitButton(onPressed: () {
                        String fullPin = pinController1.text + pinController2.text + pinController3.text + pinController4.text + pinController5.text;
                        if(fullPin.length < 5) {
                          return setState(() {
                            isPinEmpty = true;
                          });
                        } else {
                          setState(() {
                            isPinEmpty = false;
                          });
                        }
                        final verifyPin = BlocProvider.of<LoginBloc>(context);
                        verifyPin.add(VerifyPin(fullPin, widget.phoneNumber));
                      }, text: "Verify", disabled: false)),
                  SizedBox(height: 30,),
                  isOtpSent ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.resend_otp,
                        style: TextStyle(
                            fontSize: textFontSize2,
                            color: textBlackColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatTime(_start),
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: textFontSize2),
                      ),
                    ],
                  ) : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.did_not_receive_code,
                        style: TextStyle(
                            fontSize: textFontSize2,
                            color: textBlackColor,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: (){
                          _start = 60;
                          startTimer();
                          setState(() {
                            isOtpSent = true;
                          });
                          final forgotPin = BlocProvider.of<LoginBloc>(context);
                          forgotPin.add(ForgotPin(widget.phoneNumber, true));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.resend,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: textFontSize2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
