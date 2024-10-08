import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_bloc.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_event.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_state.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/check_otp_screen.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/common_widgets/phone_textformfield.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();

  final forgotFormkey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isPhoneNumberEmpty = false;
  bool isPhoneNumberInValid = false;

  @override
  void dispose() {
    phoneController.dispose();
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
            isLoading = false;
            if(state is ForgotPinLoadingState){
              isLoading = true;
            } else if(state is ForgotPinSuccessfulState) {
              isLoading = false;
              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOtpScreen(phoneNumber: "+251${phoneController.text}")));
            } else if(state is ForgotPinFailedState) {
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
      key: forgotFormkey,
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
                      AppLocalizations.of(context)!.recover_password,
                      style: TextStyle(
                          color: headerColor,
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      AppLocalizations.of(context)!.enter_phone_number_for_verification,
                      style: TextStyle(
                          color: textColor, fontSize: textFontSize),
                    ),
                    SizedBox(height: 40,),
                    phoneTextFormField(
                      isEnabled: true,
                        controller: phoneController,
                        hintText: AppLocalizations.of(context)!.phone_number,
                        icon: Ph.phone_light, autoFocus: true, onInteraction: (){
                      setState(() {
                        isPhoneNumberEmpty = false;
                      });
                    }),
                    isPhoneNumberEmpty
                        ? Text(
                      AppLocalizations.of(context)!.value_can_not_be_empty,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    isPhoneNumberInValid
                        ? Text(
                      AppLocalizations.of(context)!.please_enter_a_valid_phone_number,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    SizedBox(height: 50,),
                    isLoading ? loadingButton() : SizedBox(
                        width: double.infinity,
                        child:
                        submitButton(onPressed: () {
                          if(forgotFormkey.currentState!.validate()){
                            if(phoneController.text.isEmpty){
                              return setState(() {
                                isPhoneNumberEmpty = true;
                              });
                            }
                            if(phoneController.text.length != 9){
                              return setState(() {
                                isPhoneNumberInValid = true;
                              });
                            } else {
                              setState(() {
                                isPhoneNumberInValid = false;
                              });
                            }
                            final forgotPin = BlocProvider.of<LoginBloc>(context);
                            forgotPin.add(ForgotPin("+251${phoneController.text}", false));
                          }
                        }, text: AppLocalizations.of(context)!.submit, disabled: false)),
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
