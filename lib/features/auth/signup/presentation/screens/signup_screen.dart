import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/auth/signup/data/models/signup.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:fantasy/features/auth/signup/presentation/screens/verify_otp_screen.dart';
import 'package:fantasy/features/auth/signup/presentation/widgets/checkbox.dart';
import 'package:fantasy/features/auth/signup/presentation/widgets/privacy_dialog.dart';
import 'package:fantasy/features/auth/signup/presentation/widgets/terms_dialog.dart';
import 'package:fantasy/features/common_widgets/date_formfield.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/common_widgets/password_textformfield.dart';
import 'package:fantasy/features/common_widgets/phone_textformfield.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/common_widgets/textformfield.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final signupFormKey = GlobalKey<FormState>();

  bool isChecked = false;
  bool isLoading = false;
  bool isPasswordDifferent = false;
  bool isPhoneNumberEmpty = false;
  bool isPhoneNumberInValid = false;
  bool isDateEmpty = false;
  bool isPinEmpty = false;
  bool isConfirmPinEmpty = false;
  bool isPinInValid = false;
  bool isFirstNameEmpty = false;
  bool isLastNameEmpty = false;
  // bool isAddressEmpty = false;
  // bool isEmailEmpty = false;
  // bool isEmailInValid = false;

  // bool isPhoneChosen = true;

  TextEditingController referralLinkController = TextEditingController();
  bool referralLinkExists = true;
  bool isReferralLinkLoading = false;

  final FocusNode _focusNode = FocusNode();
  bool _isFieldFocused = false;

  DateTime firstDate = DateTime.now().subtract(Duration(days: 130 * 365));
  DateTime initialDate = DateTime.now().subtract(Duration(days: 21 * 365));
  DateTime lastDate = DateTime.now().subtract(Duration(days: 21 * 365));

  final dateController = TextEditingController();

  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && referralLinkController.text.isNotEmpty) {
      print("LLLLLLLLLLLLLLLLLLLLLLLLLLL");
      final checkAvailability = BlocProvider.of<CodeAgentBloc>(context);
      checkAvailability.add(CheckCodeAgentEvent(referralLinkController.text));
    }
    setState(() {
      _isFieldFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    // addressController.dispose();
    // emailController.dispose();
    phoneController.dispose();
    dateController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<SignUpBloc, SignUpState>(
            builder: (_, state){
              return buildInitialInput();
            },
            listener: (_, state){
              isLoading = false;
              if(state is SignUpLoading){
                isLoading = true;
              } else if(state is SignUpSuccessful) {
                isLoading = false;
                Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtpScreen(phoneNumber: "+251${phoneController.text}", signUp: SignUp(first_name: firstNameController.text, last_name: lastNameController.text, phone_number: "+251${phoneController.text}", birth_date: dateController.text, pin: passwordController.text, pin_confirm: confirmPasswordController.text, accept: isChecked, agent_code: referralLinkController.text),)));
              } else if(state is SignUpFailed) {
                isLoading = false;
                errorFlashBar(context: context, message: state.error);
              }
            }),
      ),
    );
  }

  Widget buildInitialInput() {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Form(
      key: signupFormKey,
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
                      AppLocalizations.of(context)!.create_an_account,
                      style: TextStyle(
                          color: headerColor,
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      AppLocalizations.of(context)!.welcome,
                      style: TextStyle(
                          color: textColor, fontSize: textFontSize),
                    ),
                    SizedBox(
                      height: h / 20,
                    ),
                    textFormField(
                        controller: firstNameController,
                        hintText: AppLocalizations.of(context)!.first_name,
                        icon: Ic.baseline_person_outline,
                        autoFocus: false, onInteraction: (){
                      setState(() {
                        isFirstNameEmpty = false;
                      });
                    }),
                    isFirstNameEmpty
                        ? Text(
                      AppLocalizations.of(context)!.value_can_not_be_empty,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    textFormField(
                        controller: lastNameController,
                        hintText: AppLocalizations.of(context)!.last_name,
                        icon: Ic.baseline_person_outline,
                        autoFocus: false, onInteraction: (){
                      setState(() {
                        isLastNameEmpty = false;
                      });
                    }),
                    isLastNameEmpty
                        ? Text(
                      AppLocalizations.of(context)!.value_can_not_be_empty,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    SizedBox(
                      height: 20,
                    ),
                    // Row(
                    //   children: [
                    //     Row(
                    //       children: [
                    //         GestureDetector(
                    //           onTap: (){
                    //             setState(() {
                    //               isPhoneChosen = true;
                    //             });
                    //           },
                    //           child: Container(
                    //             width: 20,
                    //             height: 20,
                    //             decoration: BoxDecoration(
                    //               color: Colors.white,
                    //               borderRadius: BorderRadius.circular(30),
                    //               border: Border.all(color: primaryColor)
                    //             ),
                    //             child: isPhoneChosen ? Center(
                    //               child: Container(
                    //                 width: 10,
                    //                 height: 10,
                    //                 decoration: BoxDecoration(
                    //                   color: primaryColor,
                    //                   borderRadius: BorderRadius.circular(18)
                    //                 ),
                    //               ),
                    //             ) : SizedBox(),
                    //           ),
                    //         ),
                    //         SizedBox(width: 10,),
                    //         Text(AppLocalizations.of(context)!.phone)
                    //       ],
                    //     ),
                    //     SizedBox(width: 30,),
                    //     Row(
                    //       children: [
                    //         GestureDetector(
                    //           onTap: (){
                    //             setState(() {
                    //               isPhoneChosen = false;
                    //             });
                    //           },
                    //           child: Container(
                    //             width: 20,
                    //             height: 20,
                    //             decoration: BoxDecoration(
                    //               color: Colors.white,
                    //               borderRadius: BorderRadius.circular(30),
                    //               border: Border.all(color: primaryColor)
                    //             ),
                    //             child: !isPhoneChosen ? Center(
                    //               child: Container(
                    //                 width: 10,
                    //                 height: 10,
                    //                 decoration: BoxDecoration(
                    //                   color: primaryColor,
                    //                   borderRadius: BorderRadius.circular(18)
                    //                 ),
                    //               ),
                    //             ) : SizedBox(),
                    //           ),
                    //         ),
                    //         SizedBox(width: 10,),
                    //         Text(AppLocalizations.of(context)!.email)
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    phoneTextFormField(
                        isEnabled: true,
                        controller: phoneController,
                        hintText: AppLocalizations.of(context)!.phone_number,
                        icon: Ic.outline_local_phone,
                        autoFocus: false, onInteraction: (){
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
                    // isPhoneChosen ? Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     phoneTextFormField(
                    //       isEnabled: true,
                    //         controller: phoneController,
                    //         hintText: AppLocalizations.of(context)!.phone_number,
                    //         icon: Ic.outline_local_phone,
                    //         autoFocus: false, onInteraction: (){
                    //       setState(() {
                    //         isPhoneNumberEmpty = false;
                    //       });
                    //     }),
                    //     isPhoneNumberEmpty
                    //         ? Text(
                    //       AppLocalizations.of(context)!.value_can_not_be_empty,
                    //       style: TextStyle(
                    //           color: dangerColor, fontSize: textFontSize),
                    //     )
                    //         : SizedBox(),
                    //     isPhoneNumberInValid
                    //         ? Text(
                    //       AppLocalizations.of(context)!.please_enter_a_valid_phone_number,
                    //       style: TextStyle(
                    //           color: dangerColor, fontSize: textFontSize),
                    //     )
                    //         : SizedBox(),
                    //   ],
                    // ) : Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     textFormField(
                    //         controller: emailController,
                    //         hintText: AppLocalizations.of(context)!.email,
                    //         icon: Ic.mail_outline,
                    //         autoFocus: false, onInteraction: (){
                    //       setState(() {
                    //         isEmailEmpty = false;
                    //       });
                    //     }),
                    //     isEmailEmpty
                    //         ? Text(
                    //       AppLocalizations.of(context)!.value_can_not_be_empty,
                    //       style: TextStyle(
                    //           color: dangerColor, fontSize: textFontSize),
                    //     )
                    //         : SizedBox(),
                    //     isEmailInValid
                    //         ? Text(
                    //       AppLocalizations.of(context)!.valid_email,
                    //       style: TextStyle(
                    //           color: dangerColor, fontSize: textFontSize),
                    //     )
                    //         : SizedBox(),
                    //   ],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    dateFormField(controller: dateController, icon: Ic.outline_calendar_today, hintText: AppLocalizations.of(context)!.dob, onPressed: (){
                      displayDatePicker(context);
                    }, onInteraction: (){
                      setState(() {
                        isDateEmpty = false;
                      });
                    }),
                    isDateEmpty
                        ? Text(
                      AppLocalizations.of(context)!.value_can_not_be_empty,
                      style: TextStyle(
                          color: dangerColor, fontSize: textFontSize),
                    )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    PasswordTextFormField(
                        passwordController: passwordController,
                        hintText: AppLocalizations.of(context)!.pin,
                        autoFocus: false, onInteraction: (){
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
                      height: 10,
                    ),
                    BlocConsumer<CodeAgentBloc, CodeAgentState>(builder: (_, state){
                      return referralLinkWidget();
                    }, listener: (_, state){
                      isReferralLinkLoading = false;
                      if(state is CodeAgentSuccessfulState){
                        if(state.isAvailable){

                        } else {
                          referralLinkExists = false;
                          setState(() {});
                        }
                      }

                      if(state is CodeAgentLoadingState){
                        isReferralLinkLoading = true;
                      }
                      if(state is CodeAgentFailedState){
                        isReferralLinkLoading = false;
                      }
                    }),
                    referralLinkExists ? SizedBox() : Text(
                      AppLocalizations.of(context)!.referral_does_not_exist,
                      style: TextStyle(
                          color: dangerColor, fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        CheckboxWidget(
                          isChecked: isChecked,
                          onPressed: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.agree_to_the,
                              style: TextStyle(
                                  fontSize: 11, color: textBlackColor),
                              children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!.terms_and_conditions,
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      final getAllTerms =
                                      BlocProvider.of<TermsBloc>(context);
                                      getAllTerms.add(GetAllTermsEvent());
                                      showDialog(context: context, builder: (BuildContext context){
                                        return termsDialog(context: context);
                                      });
                                    },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: primaryColor)),
                                TextSpan(
                                    text: AppLocalizations.of(context)!.and,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: textBlackColor)),
                                TextSpan(
                                    text: AppLocalizations.of(context)!.privacy_policy,
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      final getAllPolicies =
                                      BlocProvider.of<PrivacyBloc>(context);
                                      getAllPolicies.add(GetAllPrivacyEvent());
                                      showDialog(context: context, builder: (BuildContext context){
                                        return privacyDialog(context: context);
                                      });
                                    },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: primaryColor)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: h / 30,
                    ),
                    isLoading ? loadingButton() : SizedBox(
                        width: double.infinity,
                        child: submitButton(
                            onPressed: () {
                              if (signupFormKey.currentState!.validate()) {
                                if(firstNameController.text.isEmpty){
                                  return setState(() {
                                    isFirstNameEmpty = true;
                                  });
                                }
                                if(lastNameController.text.isEmpty){
                                  return setState(() {
                                    isLastNameEmpty = true;
                                  });
                                }
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
                                if(dateController.text.isEmpty){
                                  return setState(() {
                                    isDateEmpty = true;
                                  });
                                }
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
                                if (passwordController.text ==
                                    confirmPasswordController.text) {
                                  setState(() {
                                    isPasswordDifferent = false;
                                  });

                                  if(referralLinkExists){
                                    final signup = BlocProvider.of<SignUpBloc>(context);
                                    signup.add(PostSignUp(SignUp(first_name: firstNameController.text, last_name: lastNameController.text, phone_number: "+251${phoneController.text}", birth_date: dateController.text, pin: passwordController.text, pin_confirm: confirmPasswordController.text, accept: isChecked, agent_code: referralLinkController.text), false));
                                  }
                                } else {
                                  setState(() {
                                    isPasswordDifferent = true;
                                  });
                                }
                              }
                            },
                            text: AppLocalizations.of(context)!.signup,
                            disabled: !isChecked)),
                    SizedBox(height: 25,),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: AppLocalizations.of(context)!.already_have_an_account,
                          style: GoogleFonts.poppins(
                              fontSize: textFontSize2,
                              color: textBlackColor,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignInScreen()));
                                },
                                text: AppLocalizations.of(context)!.login,
                                style: GoogleFonts.poppins(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textFontSize2)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: onPrimaryColor,
              onSurface: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final pickedDate = date.toLocal().toString().split(" ")[0];
      List splittedDate = pickedDate.split("-");
      String dateFormat = "${splittedDate[0]}-${splittedDate[1]}-${splittedDate[2]}";
      setState(() {
        dateController.text = dateFormat;
      });
    }
  }

  Widget referralLinkWidget() {
    return TextFormField(
      autofocus: false,
      focusNode: _focusNode,
      controller: referralLinkController,
      onChanged: (value){
        setState(() {
          referralLinkExists = true;
        });
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        filled: true,
        fillColor: textFormFieldBackgroundColor,
        hintText: AppLocalizations.of(context)!.referral_code_optional,
        hintStyle: TextStyle(
          fontSize: textFontSize2,
          color: textColor,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(textFormFieldRadius)),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: isReferralLinkLoading ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,),) : Iconify(
            Ri.team_line,
            color: textColor,
          ),
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 40),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFormFieldBackgroundColor),
        ),
      ),
    );
  }

}
