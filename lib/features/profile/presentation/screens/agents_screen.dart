import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/data/models/agents.dart';
import 'package:fantasy/features/profile/data/models/profile.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/widgets/agent_component.dart';
import 'package:fantasy/features/profile/presentation/widgets/no_data_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AgentsScreen extends StatefulWidget {

  final Profile profile;

  AgentsScreen({super.key, required this.profile});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {

  final prefs = PrefService();
  int page = 1;

  List<Agents> allAgents = [];
  bool isLoading = false;
  bool isFull = false;

  @override
  void initState() {
    final transactionHistory =
    BlocProvider.of<AgentBloc>(context);
    transactionHistory.add(GetAgentEvent(widget.profile.id, page.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                AppLocalizations.of(context)!.users_who_used_referral_code),
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
                          "Agents".toUpperCase(),
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        Divider(
                          color: dividerColor,
                          thickness: 1.0,
                        ),
                        BlocConsumer<AgentBloc, AgentState>(
                            listener: (_, state) async {
                              if(state is GetAgentFailedState){
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
                              } else if(state is GetAgentSuccessfulState) {
                                allAgents.addAll(state.agents);
                                isLoading = false;
                                if(state.agents.length < 10){
                                  isFull = true;
                                }
                                setState(() {});
                              }
                            },
                            builder: (_, state) {
                              if (state is GetAgentSuccessfulState) {
                                return allAgents.isEmpty ? Center(child: noDataImageWidget(icon: "images/no_trans.png", message: "No Agents Joined One Game Week", iconWidth: 120, iconHeight: 120, iconColor: textColor)) : buildInitialInput();
                              } else if (state is GetAgentLoadingState) {
                                return allAgents.isEmpty ? agentsLoading() : buildInitialInput();
                              } else if (state is GetAgentFailedState) {
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
                                        final agents =
                                        BlocProvider.of<AgentBloc>(context);
                                        agents.add(GetAgentEvent(widget.profile.id, page.toString()));
                                      }),
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                        SizedBox(height: 30,)
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: allAgents.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return agentsComponent(agent: allAgents[index], index: index);
            }),
        SizedBox(height: 5,),
        isFull ? SizedBox() : allAgents.length < 10 ? SizedBox() : isLoading ? Center(
          child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,)),
        ) : Center(
          child: GestureDetector(
            onTap: (){
              setState(() {
                isLoading = true;
              });
              page += 1;
              final agents =
              BlocProvider.of<AgentBloc>(context);
              agents.add(GetAgentEvent(widget.profile.id, page.toString()));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Iconify(Mdi.reload, color: primaryColor, size: 16,),
                SizedBox(width: 5,),
                Text("More", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget agentsLoading(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: BlinkContainer(width: double.infinity, height: 80, borderRadius: 15),
                );
              })
        ],
      ),
    );
  }
}
