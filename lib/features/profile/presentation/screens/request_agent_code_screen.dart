import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/common_widgets/textformfield.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/index.dart';
import 'package:fantasy/features/profile/data/models/agent_code.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/widgets/number_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestAgentCodeScreen extends StatefulWidget {
  const RequestAgentCodeScreen({super.key});

  @override
  State<RequestAgentCodeScreen> createState() => _RequestAgentCodeScreenState();
}

class _RequestAgentCodeScreenState extends State<RequestAgentCodeScreen> {

  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController tiktokController = TextEditingController();
  TextEditingController currentJobController = TextEditingController();
  TextEditingController userTractionController = TextEditingController();

  bool isCurrentJobEmpty = false;
  bool isUserTractionEmpty = false;
  bool isOneFieldEntered = false;

  bool isLoading = false;

  final prefs = PrefService();

  @override
  void dispose() {
    instagramController.dispose();
    facebookController.dispose();
    tiktokController.dispose();
    currentJobController.dispose();
    userTractionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AgentCodeBloc, AgentCodeState>(
          builder: (_, state) {
            return buildInitialInput();
          }, listener: (_, state) async {
        if (state is AgentCodeLoadingState) {
          isLoading = true;
        } else if (state is AgentCodeSuccessfulState) {
          isLoading = false;
          final profile = BlocProvider.of<ProfileBloc>(context);
          profile.add(GetProfileEvent());
          final getClientRequest = BlocProvider.of<ClientRequestBloc>(context);
          getClientRequest.add(GetClientRequestEvent());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 2,)));
        } else if (state is AgentCodeFailedState) {
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
              AppLocalizations.of(context)!.get_a_referral_code),
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
                      SizedBox(height: 20,),
                      Text(
                        AppLocalizations.of(context)!.fill_out_the_details,
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: textFontSize),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      textFormField(
                          controller: currentJobController,
                          hintText: AppLocalizations.of(context)!.current_job,
                          icon: Ic.baseline_person_outline,
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isCurrentJobEmpty = false;
                        });
                      }),
                      isCurrentJobEmpty
                          ? Text(
                        AppLocalizations.of(context)!.value_can_not_be_empty,
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      SizedBox(height: 10,),
                      textFormField(
                          controller: instagramController,
                          hintText: AppLocalizations.of(context)!.instagram,
                          icon: Bi.instagram,
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isOneFieldEntered = false;
                        });
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      textFormField(
                          controller: facebookController,
                          hintText: AppLocalizations.of(context)!.facebook,
                          icon: Bi.facebook,
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isOneFieldEntered = false;
                        });
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      textFormField(
                          controller: tiktokController,
                          hintText: AppLocalizations.of(context)!.tiktok,
                          icon: Bi.tiktok,
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isOneFieldEntered = false;
                        });
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      numberTextFormField(
                          controller: userTractionController,
                          hintText: AppLocalizations.of(context)!.user_traction,
                          icon: Ri.team_line,
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isUserTractionEmpty = false;
                        });
                      }),
                      isUserTractionEmpty
                          ? Text(
                        AppLocalizations.of(context)!.value_can_not_be_empty,
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      isOneFieldEntered
                          ? Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "At least one social media is required",
                          style: TextStyle(
                              color: dangerColor, fontSize: textFontSize),
                        ),
                      )
                          : SizedBox(),
                      SizedBox(height: 70,),
                      isLoading ? loadingButton() : SizedBox(
                          width: double.infinity,
                          child: submitButton(onPressed: () {
                            if(currentJobController.text.isEmpty){
                              return setState(() {
                                isCurrentJobEmpty = true;
                              });
                            }

                            if(userTractionController.text.isEmpty){
                              return setState(() {
                                isUserTractionEmpty = true;
                              });
                            }

                            if(instagramController.text.isEmpty && facebookController.text.isEmpty && tiktokController.text.isEmpty){
                              return setState(() {
                                isOneFieldEntered = true;
                              });
                            }

                            final requestAgentCode = BlocProvider.of<AgentCodeBloc>(context);
                            requestAgentCode.add(RequestAgentCodeEvent(AgentCode(facebook_link: facebookController.text, tiktok_link: tiktokController.text, instagram_link: instagramController.text, current_job: currentJobController.text, user_traction: num.parse(userTractionController.text))));
                          }, text: AppLocalizations.of(context)!.request, disabled: false)),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

}
