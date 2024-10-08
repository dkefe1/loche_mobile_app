import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/ads_component.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/leaderboard/data/models/leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/month.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leader.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/my_rank.dart';
import 'package:fantasy/features/leaderboard/data/models/winner.dart';
import 'package:fantasy/features/leaderboard/data/models/yearly_leaderboard.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_bloc.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_event.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_state.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/best_manager_carousel2.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/leaderboard_widget.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/monthy_leaderboard_widget.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/my_rank_widget.dart';
import 'package:fantasy/features/leaderboard/presentation/widgets/yearly_leaderboard_widget.dart';
import 'package:fantasy/features/profile/presentation/widgets/no_data_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> with SingleTickerProviderStateMixin {

  int _selectedTabbar = 0;
  late TabController tabController;

  GameWeek? gameWeekValue;
  List<GameWeek> gameWeeks = [];

  List<Leaderboard> allWeeklyLeaders = [];
  List<MonthlyLeader> allMonthlyLeaders = [];
  List<Leaderboard> allYearlyLeaders = [];

  int weeklyPage = 1;
  int monthlyPage = 1;
  int yearlyPage = 1;

  final prefs = PrefService();

  List<Advertisement>? ads;

  List<String> timeTypes = [];

  MyRank? myWeeklyRank;

  MyRank? myYearlyRank;

  List<Winner>? weeklyWinner;
  List<Winner>? monthlyWinner;
  List<Winner>? yearlyWinner;

  MyRank? myMonthlyRank;

  late ScrollController weeklyScrollController;
  late ScrollController monthlyScrollController;
  late ScrollController yearlyScrollController;
  late ScrollController scrollController;

  bool hasMoreWeekly = true;
  bool isWeeklyLoading = false;

  bool hasMoreMonthly = true;
  bool isMonthlyLoading = false;

  bool hasMoreYearly = true;
  bool isYearlyLoading = false;

  Month? monthValue;
  List<Month> months = [
    Month(month: "August", value: "08"),
    Month(month: "September", value: "09"),
    Month(month: "October", value: "10"),
    Month(month: "November", value: "11"),
    Month(month: "December", value: "12"),
    Month(month: "January", value: "01"),
    Month(month: "February", value: "02"),
    Month(month: "March", value: "03"),
    Month(month: "April", value: "04"),
    Month(month: "May", value: "05"),
    Month(month: "June", value: "06"),
    Month(month: "July", value: "07"),
  ];

  bool hasStarted = false;
  bool isNotRefreshed = true;

  bool checkMonthForYear(currentMonth){
    int monthIndex = months.indexOf(months.firstWhere(
          (month) => month.value == currentMonth,
      orElse: () => Month(month: "Unknown", value: ""),
    ));

    if(monthIndex < 5){
      return true;
    } else {
      return false;
    }
  }

  void _setCurrentMonthValue() {
    DateTime now = DateTime.now();
    String currentMonth = now.month.toString().padLeft(2, '0');

    Month? foundMonth = months.firstWhere(
          (month) => month.value == currentMonth,
      orElse: () => Month(month: "Unknown", value: ""),
    );

    setState(() {
      monthValue = foundMonth;
    });
  }

  void loadWeeklyMore() async {
    if(weeklyScrollController.position.extentAfter < 300){
      if(!isWeeklyLoading){
        weeklyPage+=1;
        if(gameWeekValue == null){
          final weeklyLeaderboard =
          BlocProvider.of<WeeklyLeaderboardBloc>(context);
          weeklyLeaderboard.add(GetWeeklyLeaderboardEvent("initial", weeklyPage.toString()));
        } else {
          final weeklyLeaderboard =
          BlocProvider.of<WeeklyLeaderboardBloc>(context);
          weeklyLeaderboard.add(GetWeeklyLeaderboardEvent(gameWeekValue!.id, weeklyPage.toString()));
        }
      }
    }
  }

  void loadMonthlyMore() async {
    if(monthlyScrollController.position.extentAfter < 300){
      if(!isMonthlyLoading){
        print("SDFDSFDSFSDFDSFDSFDSFAS");
        monthlyPage+=1;

        String year = monthValue!.year;

        if(checkMonthForYear(monthValue!.value)){
          year = (int.parse(year) - 1).toString();
        }

        final monthlyLeaderboard =
        BlocProvider.of<MonthlyLeaderboardBloc>(context);
        monthlyLeaderboard.add(GetMonthlyLeaderboardEvent("$year-${monthValue!.value}", monthlyPage.toString()));
      }
    }
  }

  void loadYearlyMore() async {
    if(yearlyScrollController.position.extentAfter < 300){
      print("WWWQQQQQQQAQQAQAAQAQA");
      if(!isYearlyLoading){
        print("SDFDSFDSFSDFDSFDSFDSFAS");
        yearlyPage+=1;
        final yearlyLeaderboard =
        BlocProvider.of<YearlyLeaderboardBloc>(context);
        yearlyLeaderboard.add(GetYearlyLeaderboardEvent(yearlyPage.toString()));
      }
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    weeklyScrollController = ScrollController()..addListener(loadWeeklyMore);
    monthlyScrollController = ScrollController()..addListener(loadMonthlyMore);
    yearlyScrollController = ScrollController()..addListener(loadYearlyMore);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >=
            scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if(_selectedTabbar == 0){
            loadWeeklyMore();
          } else if(_selectedTabbar == 1){
            loadMonthlyMore();
          } else if(_selectedTabbar == 2){
            loadYearlyMore();
          }
        }
      });
    final weeklyLeaderboard =
    BlocProvider.of<WeeklyLeaderboardBloc>(context);
    weeklyLeaderboard.add(GetWeeklyLeaderboardEvent("initial", "1"));
    _setCurrentMonthValue();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    timeTypes = [
      AppLocalizations.of(context)!.best_manager_week,
      AppLocalizations.of(context)!.best_manager_month,
      AppLocalizations.of(context)!.best_manager_year,
    ];

    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
                child: buildInitialInput(),
              )),
          ads == null ? SizedBox() : AdsComponent(ads: ads!, height: 50),
        ],
      ),
    );
  }

  Widget buildInitialInput(){
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () async {
        if(gameWeekValue != null && isNotRefreshed){
          if(gameWeekValue!.is_done == false){
            allWeeklyLeaders.clear();
            weeklyPage = 1;

            final weeklyLeaderboard = BlocProvider.of<WeeklyLeaderboardBloc>(context);
            weeklyLeaderboard.add(GetWeeklyLeaderboardEvent("initial", "1"));

            return await Future.delayed(Duration(seconds: 0));
          }
        }
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            BestManagerCarousel2(winners: _selectedTabbar == 1 ? monthlyWinner == null ? [] : monthlyWinner! : _selectedTabbar == 0 ? weeklyWinner == null ? [] : weeklyWinner! : yearlyWinner == null ? [] : yearlyWinner!, text: timeTypes[_selectedTabbar],),
            SizedBox(height: 10,),
            Text(AppLocalizations.of(context)!.ranking, style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w600),),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [BoxShadow(color: Color(0xFF000000).withOpacity(0.1), blurRadius: 7)]),
              child: TabBar(
                  onTap: (index) {
                    setState(() {
                      _selectedTabbar = index;
                      tabController.animateTo(index,
                          duration: Duration(seconds: 2));
                    });
                    if(index == 2){
                      if(allYearlyLeaders.isEmpty){
                        final yearlyLeaderboard =
                        BlocProvider.of<YearlyLeaderboardBloc>(context);
                        yearlyLeaderboard.add(GetYearlyLeaderboardEvent("1"));
                      }
                    } else if(index == 1){
                      if(allMonthlyLeaders.isEmpty){
                        String year = monthValue!.year;

                        if(checkMonthForYear(monthValue!.value)){
                          year = (int.parse(year) - 1).toString();
                        }

                        final monthlyLeaderboard =
                        BlocProvider.of<MonthlyLeaderboardBloc>(context);
                        monthlyLeaderboard.add(GetMonthlyLeaderboardEvent("$year-${monthValue!.value}", "1"));
                      }
                    }
                  },
                  labelColor: onPrimaryColor,
                  unselectedLabelColor: primaryColor,
                  labelStyle: TextStyle(fontSize: 13),
                  indicator: BoxDecoration(
                      color: Color(0xFF1E727E).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(60)),
                  controller: tabController,
                  tabs: [
                    Tab(
                        child: Text(
                          AppLocalizations.of(context)!.weekly,
                          style:
                          GoogleFonts.poppins(fontSize: 15),
                        )),
                    Tab(
                        child: Text(
                          AppLocalizations.of(context)!.monthly,
                          style:
                          GoogleFonts.poppins(fontSize: 15),
                        )),
                    Tab(
                        child: Text(
                          AppLocalizations.of(context)!.yearly,
                          style:
                          GoogleFonts.poppins(fontSize: 15),
                        ))
                  ]),
            ),
            SizedBox(height: 10,),
            _selectedTabbar == 1 ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Month>(
                    value: monthValue,
                    isExpanded: true,
                    hint: Text(
                      AppLocalizations.of(context)!.months,
                      style: TextStyle(
                          color: textColor,
                          fontSize: textFontSize2,
                          fontWeight: FontWeight.w500),
                    ),
                    items: months.map(buildMenuMonths).toList(),
                    icon: Iconify(
                      MaterialSymbols.arrow_drop_down_rounded,
                      color: primaryColor,
                      size: 30,
                    ),
                    onChanged: (value) {
                      monthValue = value;
                      myMonthlyRank = null;
                      monthlyPage = 1;
                      allMonthlyLeaders.clear();
                      hasMoreMonthly = true;
                      String year = monthValue!.year;

                      if(checkMonthForYear(monthValue!.value)){
                        year = (int.parse(year) - 1).toString();
                      }
                      final monthlyLeaderboard =
                      BlocProvider.of<MonthlyLeaderboardBloc>(context);
                      monthlyLeaderboard.add(GetMonthlyLeaderboardEvent("$year-${monthValue!.value}", "1"));
                      setState(() {
                      });
                    }),
              ),
            ) : SizedBox(),
            Builder(builder: (_) {
              if (_selectedTabbar == 0) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<GameWeek>(
                            value: gameWeekValue,
                            isExpanded: true,
                            hint: Text(
                              AppLocalizations.of(context)!.game_weeks,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: textFontSize2,
                                  fontWeight: FontWeight.w500),
                            ),
                            items: gameWeeks.map(buildMenuCategories).toList(),
                            icon: Iconify(
                              MaterialSymbols.arrow_drop_down_rounded,
                              color: primaryColor,
                              size: 30,
                            ),
                            onChanged: (value) {
                              gameWeekValue = value;
                              myWeeklyRank = null;
                              weeklyPage = 1;
                              allWeeklyLeaders.clear();
                              hasMoreWeekly = true;
                              final weeklyLeaderboard =
                              BlocProvider.of<WeeklyLeaderboardBloc>(context);
                              weeklyLeaderboard.add(GetWeeklyLeaderboardEvent(gameWeekValue!.id, "1"));
                              setState(() {
                              });
                            }),
                      ),
                    ),
                    SizedBox(height: 10,),
                    BlocConsumer<WeeklyLeaderboardBloc, WeeklyLeaderboardState>(
                        listener: (_, state) async {
                          if(state is GetWeeklyLeaderboardFailedState){
                            isWeeklyLoading = false;
                            isNotRefreshed = true;
                            gameWeekValue = null;
                            gameWeeks.clear();
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
                            setState(() {});
                          } else if(state is GetWeeklyLeaderboardSuccessfulState) {

                            ads = state.leaderboard.ads;

                            isWeeklyLoading = false;
                            isNotRefreshed = true;
                            gameWeekValue ?? gameWeeks.addAll(state.leaderboard.gameWeeks);
                            gameWeekValue ??= state.leaderboard.gameWeeks[0];

                            weeklyWinner = state.leaderboard.weeklyWinners;

                            allWeeklyLeaders.addAll(state.leaderboard.weeklyLeaderboard);

                            hasStarted = state.leaderboard.hasStarted;

                            if(state.leaderboard.weeklyLeaderboard.isEmpty){
                              hasMoreWeekly = false;
                            }

                            if(allWeeklyLeaders.length < 18){
                              hasMoreWeekly = false;
                            }

                            myWeeklyRank = state.leaderboard.myRank;

                            setState(() {});
                          } else if(state is GetWeeklyLeaderboardLoadingState){
                            isWeeklyLoading = true;
                            isNotRefreshed = false;
                          }
                        },
                        builder: (_, state) {
                          if (state is GetWeeklyLeaderboardSuccessfulState) {
                            return allWeeklyLeaders.isEmpty ? Padding(
                              padding: const EdgeInsets.only(top: noLeaderTopPadding),
                              child: Center(child: noDataImageWidget(icon: "images/no_leader.png", message: AppLocalizations.of(context)!.leaderboard_not_available, iconWidth: 120, iconHeight: 120, iconColor: textColor)),
                            ) : weeklyLeaderBoard(weeklyWinners: state.leaderboard.weeklyWinners, gameWeeks: gameWeeks, leaderboard: allWeeklyLeaders, hasStarted: state.leaderboard.hasStarted);
                          } else if (state is GetWeeklyLeaderboardLoadingState) {
                            return allWeeklyLeaders.isEmpty ? weeklyLeaderboardLoading() : weeklyLeaderBoard(weeklyWinners: weeklyWinner ?? [], gameWeeks: gameWeeks, leaderboard: allWeeklyLeaders, hasStarted: hasStarted);
                          } else if (state is GetWeeklyLeaderboardFailedState) {
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
                                    allWeeklyLeaders.clear();
                                    final weeklyLeaderboard =
                                    BlocProvider.of<WeeklyLeaderboardBloc>(context);
                                    weeklyLeaderboard.add(GetWeeklyLeaderboardEvent("initial", "1"));
                                  }),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                  ],
                );
              } else if(_selectedTabbar == 1){
                return BlocConsumer<MonthlyLeaderboardBloc, MonthlyLeaderboardState>(
                    listener: (_, state) async {
                      if(state is GetMonthlyLeaderboardFailedState){
                        isMonthlyLoading = false;

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
                      } else if(state is GetMonthlyLeaderboardSuccessfulState) {

                        isMonthlyLoading = false;

                        monthlyWinner = state.leaderboard.monthlyWinners;
                        myMonthlyRank = state.leaderboard.myRank;

                        if(state.leaderboard.monthlyLeaderboard.isEmpty){
                          hasMoreMonthly = false;
                        }

                        allMonthlyLeaders.addAll(state.leaderboard.monthlyLeaderboard);

                        setState(() {});
                      } else if(state is GetMonthlyLeaderboardLoadingState){
                        isMonthlyLoading = true;
                      }
                    },
                    builder: (_, state) {
                      if (state is GetMonthlyLeaderboardSuccessfulState) {
                        return allMonthlyLeaders.isEmpty ? Padding(
                            padding: EdgeInsets.only(top: noLeaderTopPadding),
                            child: Center(child: noDataImageWidget(icon: "images/no_leader.png", message: AppLocalizations.of(context)!.leaderboard_not_available, iconWidth: 120, iconHeight: 120, iconColor: textColor))) : monthlyLeaderBoard(leaderboard: MonthlyLeaderboard(monthlyLeaderboard: allMonthlyLeaders, monthlyWinners: state.leaderboard.monthlyWinners, myRank: state.leaderboard.myRank));
                      } else if (state is GetMonthlyLeaderboardLoadingState) {
                        return allMonthlyLeaders.isEmpty ? weeklyLeaderboardLoading() : monthlyLeaderBoard(leaderboard: MonthlyLeaderboard(monthlyLeaderboard: allMonthlyLeaders, monthlyWinners: monthlyWinner ?? [], myRank: myMonthlyRank));
                      } else if (state is GetMonthlyLeaderboardFailedState) {
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
                                allMonthlyLeaders.clear();
                                String year = monthValue!.year;

                                if(checkMonthForYear(monthValue!.value)){
                                  year = (int.parse(year) - 1).toString();
                                }

                                final monthlyLeaderboard =
                                BlocProvider.of<MonthlyLeaderboardBloc>(context);
                                monthlyLeaderboard.add(GetMonthlyLeaderboardEvent("$year-${monthValue!.value}", "1"));
                              }),
                        );
                      } else {
                        return SizedBox();
                      }
                    });
              } else {
                return BlocConsumer<YearlyLeaderboardBloc, YearlyLeaderboardState>(
                    listener: (_, state) async {
                      if(state is GetYearlyLeaderboardFailedState){

                        isYearlyLoading = false;

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
                      } else if(state is GetYearlyLeaderboardSuccessfulState) {

                        isYearlyLoading = false;

                        yearlyWinner = state.leaderboard.yearlyWinners;
                        myYearlyRank = state.leaderboard.myRank;

                        if(state.leaderboard.yearlyLeaderboard.isEmpty){
                          hasMoreYearly = false;
                        }

                        allYearlyLeaders.addAll(state.leaderboard.yearlyLeaderboard);

                        setState(() {});
                      } else if(state is GetYearlyLeaderboardLoadingState){
                        isYearlyLoading = true;
                      }
                    },
                    builder: (_, state) {
                      if (state is GetYearlyLeaderboardSuccessfulState) {
                        return allYearlyLeaders.isEmpty ? Padding(
                          padding: const EdgeInsets.only(top: noLeaderTopPadding),
                          child: Center(child: noDataImageWidget(icon: "images/no_leader.png", message: AppLocalizations.of(context)!.leaderboard_not_available, iconWidth: 120, iconHeight: 120, iconColor: textColor)),
                        ) : yearlyLeaderBoard(leaderboard: YearlyLeaderboard(yearlyWinners: state.leaderboard.yearlyWinners, yearlyLeaderboard: allYearlyLeaders, myRank: myYearlyRank));
                      } else if (state is GetYearlyLeaderboardLoadingState) {
                        return allYearlyLeaders.isEmpty ? yearlyLeaderboardLoading() : yearlyLeaderBoard(leaderboard: YearlyLeaderboard(yearlyWinners: yearlyWinner ?? [], yearlyLeaderboard: allYearlyLeaders, myRank: myYearlyRank));
                      } else if (state is GetYearlyLeaderboardFailedState) {
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
                                allYearlyLeaders.clear();
                                final yearlyLeaderboard =
                                BlocProvider.of<YearlyLeaderboardBloc>(context);
                                yearlyLeaderboard.add(GetYearlyLeaderboardEvent("1"));
                              }),
                        );
                      } else {
                        return SizedBox();
                      }
                    });
              }
            }),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  Widget weeklyLeaderBoard({required List<Winner> weeklyWinners, required List<GameWeek> gameWeeks, required List<Leaderboard> leaderboard, required bool hasStarted}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gameWeekValue == null ? SizedBox() : gameWeekValue!.is_done == false ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SpinKitPulse(
              color: primaryColor,
              size: 25,
            ),
            SizedBox(width: 10,),
            Text(AppLocalizations.of(context)!.live, style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, letterSpacing: 1.0),),
            SizedBox(width: 10,)
          ],
        ) : SizedBox(),
        SizedBox(height: 5,),
        gameWeekValue == null ? SizedBox() : gameWeekValue!.is_done == false ? Text(AppLocalizations.of(context)!.this_is_not_the_final_result, style: TextStyle(color: primaryColor),) : SizedBox(),
        SizedBox(height: 10,),
        myWeeklyRank == null ? SizedBox() : hasStarted ? myRankContainer(contestor: myWeeklyRank!) : SizedBox(),
        SizedBox(height: 10,),
        gameWeekValue == null ? SizedBox() : leaderBoardWidget(leaderBoard: leaderboard, gameWeekId: gameWeekValue!.id, hasMore: hasMoreWeekly, controller: weeklyScrollController, hasStarted: hasStarted),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget monthlyLeaderBoard({required MonthlyLeaderboard leaderboard}){
    return Column(
      children: [
        SizedBox(height: 10,),
        myMonthlyRank == null ? SizedBox() : myRankContainer(contestor: myMonthlyRank!),
        SizedBox(height: 10,),
        monthlyLeaderBoardWidget(leaderBoard: leaderboard.monthlyLeaderboard, hasMore: hasMoreMonthly, controller: monthlyScrollController),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget yearlyLeaderBoard({required YearlyLeaderboard leaderboard}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myYearlyRank == null? SizedBox() : myRankContainer(contestor: myYearlyRank!),
        SizedBox(height: 10,),
        yearlyLeaderBoardWidget(leaderBoard: leaderboard.yearlyLeaderboard, hasMore: hasMoreYearly, controller: yearlyScrollController),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget weeklyLeaderboardLoading(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 30,),
          // BlinkContainer(width: 200, height: 30, borderRadius: 0),
          // SizedBox(height: 10,),
          // BlinkContainer(width: double.infinity, height: 200, borderRadius: 18),
          // SizedBox(height: 5,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     BlinkContainer(width: 15, height: 15, borderRadius: 15),
          //     SizedBox(width: 5,),
          //     BlinkContainer(width: 15, height: 15, borderRadius: 15),
          //     SizedBox(width: 5,),
          //     BlinkContainer(width: 15, height: 15, borderRadius: 15),
          //     SizedBox(width: 5,),
          //     BlinkContainer(width: 15, height: 15, borderRadius: 15),
          //     SizedBox(width: 5,),
          //     BlinkContainer(width: 15, height: 15, borderRadius: 15),
          //   ],
          // ),
          // SizedBox(height: 10,),
          // BlinkContainer(width: 150, height: 30, borderRadius: 0),
          // SizedBox(height: 10,),
          // BlinkContainer(width: double.infinity, height: 40, borderRadius: 60),
          // SizedBox(height: 10,),
          // _selectedTabbar == 1 ? SizedBox() : BlinkContainer(width: double.infinity, height: 50, borderRadius: 0),
          SizedBox(height: 10,),
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
          }),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget yearlyLeaderboardLoading(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              }),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  DropdownMenuItem<GameWeek> buildMenuCategories(GameWeek gameWeek) => DropdownMenuItem(
      value: gameWeek,
      child: Text(
        "${AppLocalizations.of(context)!.game_week} ${gameWeek.game_week}",
        style: TextStyle(
            color: primaryColor,
            fontSize: textFontSize2,
            fontWeight: FontWeight.w500),
      ));

  DropdownMenuItem<Month> buildMenuMonths(Month month) => DropdownMenuItem(
      value: month,
      child: Text(
        month.month,
        style: TextStyle(
            color: primaryColor,
            fontSize: textFontSize2,
            fontWeight: FontWeight.w500),
      ));

}
