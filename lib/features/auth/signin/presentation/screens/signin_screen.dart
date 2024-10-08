import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/language_provider.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/data/models/signin.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_bloc.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_event.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_state.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/forgot_password_screen.dart';
import 'package:fantasy/features/auth/signup/presentation/screens/signup_screen.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/common_widgets/password_textformfield.dart';
import 'package:fantasy/features/common_widgets/phone_textformfield.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/screens/create_coach_screen.dart';
import 'package:fantasy/features/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isPhoneNumberEmpty = false;
  bool isPhoneNumberInValid = false;
  bool isPasswordEmpty = false;
  bool isPinEmpty = false;
  bool isPinInValid = false;

  final prefService = PrefService();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocConsumer<LoginBloc, LoginState>(
          builder: (_, state){
            return buildInitialInput();
          },
          listener: (_, state){
            if(state is LoginLoadingState){
              isLoading = true;
            } else if(state is LoginSuccessfulState) {
              isLoading = false;
              prefService.login(passwordController.text);
              prefService.setPhoneNumber(phoneController.text);
              if(state.hasTeam){
                prefService.createTeam("hasATeam");
                final getClientTeam =
                BlocProvider.of<ClientTeamBloc>(context);
                getClientTeam.add(GetClientTeamEvent());
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 0)), (route) => false);
              } else {
                final getCoaches = BlocProvider.of<CoachBloc>(context);
                getCoaches.add(GetCoachEvent());
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CreateCoachScreen()), (route) => false);
              }
            } else if(state is LoginFailedState) {
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
      key: loginFormKey,
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
            Positioned(
              top: 50,
              right: 20,
              child: Consumer<LanguageProvider>(
                builder: (context, data, child) {
                  return GestureDetector(
                    onTap: () {
                      final lang = Provider.of<LanguageProvider>(context, listen: false);
                      lang.changeLanguage();
                      if(data.isEnglish){
                        prefService.setLanguage("en");
                      } else {
                        prefService.setLanguage("am");
                      }
                    },
                    child: data.isEnglish ? Row(
                      children: [
                        Image.asset("images/english.png", width: 30, height: 30, fit: BoxFit.fill,),
                        SizedBox(width: 5,),
                        Text("Eng", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),)
                      ],
                    ) : Row(
                      children: [
                        Image.asset("images/amharic.png", width: 30, height: 30, fit: BoxFit.fill,),
                        SizedBox(width: 5,),
                        Text("አማ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),)
                      ],
                    ),
                  );
                }
              ),
            ),
            Container(
              height: h / 1.4,
              width: w,
              margin: EdgeInsets.fromLTRB(15, 150, 15, 0),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(defaultBorderRadius))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.login_to_your_account,
                        style: TextStyle(
                            color: headerColor,
                            fontSize: headerFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.login_to_your_account_desc,
                        style:
                        TextStyle(color: textColor, fontSize: textFontSize),
                      ),
                      SizedBox(
                        height: h / 20,
                      ),
                      phoneTextFormField(
                        isEnabled: true,
                          controller: phoneController,
                          hintText: AppLocalizations.of(context)!.phone_number,
                          icon: Ph.phone_light, autoFocus: false, onInteraction: (){
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
                      SizedBox(
                        height: 20,
                      ),
                      PasswordTextFormField(
                          passwordController: passwordController, hintText: AppLocalizations.of(context)!.pin, autoFocus: false, onInteraction: (){
                        setState(() {
                          isPinEmpty = false;
                        });
                      }),
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
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgot_pin,
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: h / 20,
                      ),
                      isLoading ? loadingButton() : SizedBox(
                          width: double.infinity,
                          child: submitButton(onPressed: () {
                            if(loginFormKey.currentState!.validate()){
                              if(phoneController.text.isEmpty){
                                return setState(() {
                                  isPhoneNumberEmpty = true;
                                });
                              }
                              if(passwordController.text.isEmpty){
                                return setState(() {
                                  isPinEmpty = true;
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
                              if(passwordController.text.length < 4){
                                return setState(() {
                                  isPinInValid = true;
                                });
                              } else {
                                setState(() {
                                  isPinInValid = false;
                                });
                              }
                              final login = BlocProvider.of<LoginBloc>(context);
                              login.add(LoginClient(SignIn(phone_number: "+251${phoneController.text}", pin: passwordController.text)));
                            }
                          }, text: AppLocalizations.of(context)!.login, disabled: false)),
                      SizedBox(height: 50,),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.are_you_new,
                                style: GoogleFonts.poppins(
                                  fontSize: textFontSize2,
                                  color: textBlackColor,),
                                children: <TextSpan>[
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                                    },
                                    text: AppLocalizations.of(context)!.create_account, style: GoogleFonts.poppins(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textFontSize2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
