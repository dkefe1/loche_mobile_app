import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/logo_name.dart';
import 'package:fantasy/features/guidelines/data/models/poll_model.dart';
import 'package:fantasy/features/guidelines/data/models/user_poll.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/polls_widget.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/home/presentation/widgets/loading_icon.dart';
import 'package:fantasy/features/profile/presentation/widgets/no_data_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({Key? key}) : super(key: key);

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> with SingleTickerProviderStateMixin {

  List<PollModel> polls = [];
  List<UserPoll> userPoll = [];

  late ScrollController scrollController;

  late TabController tabController;

  final prefs = PrefService();

  int page = 1;

  bool isLoading = false;
  bool isFull = false;

  int _selectedTabbar = 0;

  @override
  void initState() {
    final getPolls = BlocProvider.of<PollsBloc>(context);
    getPolls.add(GetPollsEvent(page.toString()));
    tabController = TabController(length: 2, vsync: this);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >=
            scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if(!isFull){
            setState(() {
              isLoading = true;
            });
            page += 1;
            final getPolls = BlocProvider.of<PollsBloc>(context);
            getPolls.add(GetPollsEvent(page.toString()));
          }
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      logoName(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.poll,
                      style: TextStyle(
                          color: onPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
              child: TabBar(
                  controller: tabController,
                  indicatorWeight: 4.0,
                  onTap: (index) {
                    setState(() {
                      _selectedTabbar = index;
                      tabController.animateTo(index,
                          duration: Duration(seconds: 2));
                    });
                  },
                  tabs: [
                    Tab(
                        child: Text(
                          AppLocalizations.of(context)!.open,
                          style:
                          GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                        )),
                    Tab(
                        child: Text(
                          AppLocalizations.of(context)!.closed,
                          style:
                          GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                        )),
                  ]),
            ),
            Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                      color: Colors.white,),
                  child: Stack(
                    children: [
                      RefreshIndicator(
                        color: primaryColor,
                        onRefresh: () async {
                          polls.clear();
                          final getPolls = BlocProvider.of<PollsBloc>(context);
                          getPolls.add(GetPollsEvent("1"));
                          return await Future.delayed(Duration(seconds: 2));
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocConsumer<PollsBloc, PollsState>(builder: (_, state){
                                if (state is GetPollsSuccessfulState) {
                                  return polls.isEmpty ? Center(child: noDataImageWidget(icon: "images/poll.png", message: AppLocalizations.of(context)!.no_polls, iconWidth: 120, iconHeight: 120, iconColor: textColor)) : buildInitialInput(polls: polls, userPolls: state.polls.participatedPolls);
                                } else if (state is GetPollsLoadingState) {
                                  return polls.isEmpty ? pollLoading() : buildInitialInput(polls: polls, userPolls: userPoll);
                                } else if (state is GetPollsFailedState) {
                                  return errorView(
                                      iconPath: state.error == socketErrorMessage
                                          ? "images/connection.png"
                                          : "images/error.png",
                                      title: "Ooops!",
                                      text: state.error,
                                      onPressed: () {
                                        final getPolls = BlocProvider.of<PollsBloc>(context);
                                        getPolls.add(GetPollsEvent(page.toString()));
                                      });
                                } else {
                                  return SizedBox();
                                }
                              }, listener: (_, state){
                                if(state is GetPollsSuccessfulState){
                                  polls.addAll(state.polls.polls);
                                  userPoll = state.polls.participatedPolls;
                                  isLoading = false;
                                  if(state.polls.polls.length < 10){
                                    isFull = true;
                                  }
                                  setState(() {});
                                }
                              }),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ),
                      ),
                      BlocConsumer<PatchPollsBloc, PatchPollsState>(builder: (_, state){
                        if(state is PatchPollsLoadingState) {
                          return Container(
                            color: Colors.black.withOpacity(0.4),
                            child: Align(
                              alignment: Alignment.center,
                              child: LoadingIcon(),
                            ),
                          );
                        }
                        return SizedBox();
                      }, listener: (_, state) async {

                        if(state is PatchPollsSuccessfulState){
                          polls.clear();
                          final getPolls =
                          BlocProvider.of<PollsBloc>(context);
                          getPolls.add(GetPollsEvent("1"));
                        }

                        if(state is PatchPollsFailedState){
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
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput({required List<PollModel> polls, required List<UserPoll> userPolls}){
    return Column(
      children: [
        Builder(builder: (_) {

          List<PollModel> openPolls = polls.where((poll) => poll.status == "Open").toList();
          List<PollModel> closedPolls = polls.where((poll) => poll.status != "Open").toList();

          if (_selectedTabbar == 0) {
            return openPolls.isEmpty ? Center(child: noDataImageWidget(icon: "images/poll.png", message: AppLocalizations.of(context)!.no_polls, iconWidth: 120, iconHeight: 120, iconColor: textColor)) : pollsBody(polls: openPolls, userPolls: userPolls);
          } else {
            return closedPolls.isEmpty ? Center(child: noDataImageWidget(icon: "images/poll.png", message: AppLocalizations.of(context)!.no_polls, iconWidth: 120, iconHeight: 120, iconColor: textColor)) : pollsBody(polls: closedPolls, userPolls: userPolls);
          }
        })
      ],
    );
  }

  Widget pollsBody({required List<PollModel> polls, required List<UserPoll> userPolls}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          ListView.builder(
            padding: EdgeInsets.zero,
              itemCount: polls.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
            return pollsWidget(poll: polls[index], userPolls: userPolls);
          }),
          SizedBox(height: 5,),
          isFull ? SizedBox() : isLoading ? Center(
            child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,)),
          ) : SizedBox(),
        ],
      ),
    );
  }

  Widget pollLoading(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          BlinkContainer(width: double.infinity, height: 300, borderRadius: 20),
          SizedBox(height: 20,),
          BlinkContainer(width: double.infinity, height: 300, borderRadius: 20),
          SizedBox(height: 20,),
          BlinkContainer(width: double.infinity, height: 300, borderRadius: 20),
        ],
      ),
    );
  }

}
