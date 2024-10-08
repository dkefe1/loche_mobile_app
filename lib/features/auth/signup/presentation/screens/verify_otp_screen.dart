import 'dart:async';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signup/data/models/signup.dart';
import 'package:fantasy/features/auth/signup/data/models/verify_otp.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:fantasy/features/auth/signup/presentation/widgets/otp_textformfield.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/common_widgets/success_flashbar.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/screens/create_coach_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyOtpScreen extends StatefulWidget {

  String phoneNumber;
  SignUp signUp;

  VerifyOtpScreen({required this.phoneNumber, required this.signUp, super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController pinController1 = TextEditingController();

  TextEditingController pinController2 = TextEditingController();

  TextEditingController pinController3 = TextEditingController();

  TextEditingController pinController4 = TextEditingController();

  TextEditingController pinController5 = TextEditingController();

  bool isPinEmpty = false;
  bool isIncorrect = false;
  bool isLoading = false;

  final prefService = PrefService();

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
      body: BlocConsumer<SignUpBloc, SignUpState>(
          builder: (_, state){
            return buildInitialInput();
          },
          listener: (_, state){
            if(state is VerifyOtpLoading){
              isLoading = true;
            } else if(state is VerifyOtpSuccessful) {
              isLoading = false;
              prefService.login("logged in");
              prefService.setPhoneNumber(widget.phoneNumber.substring(4));
              final getCoaches = BlocProvider.of<CoachBloc>(context);
              getCoaches.add(GetCoachEvent());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CreateCoachScreen()), (route) => false);
            } else if(state is VerifyOtpFailed) {
              isLoading = false;
              errorFlashBar(context: context, message: state.error);
            } else if(state is SignUpFailed) {
              isLoading = false;
              setState(() {
                isOtpSent = false;
              });
              errorFlashBar(context: context, message: state.error);
            } else if(state is SignUpResendOtpSuccessful) {
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
                        final verifyOtp = BlocProvider.of<SignUpBloc>(context);
                        verifyOtp.add(VerifyOtpEvent(VerifyOtp(phone_number: widget.phoneNumber, otp: fullPin)));
                      }, text: AppLocalizations.of(context)!.verify, disabled: false)),
                  SizedBox(height: 20,),
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
                          final signup = BlocProvider.of<SignUpBloc>(context);
                          signup.add(PostSignUp(widget.signUp, true));
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
