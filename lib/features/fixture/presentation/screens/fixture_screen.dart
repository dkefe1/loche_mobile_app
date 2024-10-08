import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/core/services/time_convert.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/ads_component.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_bloc.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_event.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_state.dart';
import 'package:fantasy/features/fixture/presentation/widgets/fixture_component.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FixtureScreen extends StatefulWidget {
  const FixtureScreen({super.key});

  @override
  State<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends State<FixtureScreen> {

  List<MatchModel> matches = [];
  Map<String, List<MatchModel>> groupedMatches = {};
  int? round;
  String gameWeekStartFormattedDate = "";

  List<int> fixtures = [];
  int? fixValue;

  TimeConvert timeConvert = TimeConvert();

  final prefs = PrefService();

  List<Advertisement> ads = [];

  @override
  void initState() {
    fixtures = List.generate(38, (index) => index + 1);
    final getMatches = BlocProvider.of<FixtureBloc>(context);
    getMatches.add(GetFixturesEvent(round.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
                child: RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () async {
                    final getFixture = BlocProvider.of<FixtureBloc>(context);
                    getFixture.add(GetFixturesEvent(round.toString()));
                    return await Future.delayed(Duration(seconds: 2));
                  },
                  child: Column(
                    children: [
                      ads.isEmpty ? SizedBox() : AdsComponent(ads: ads, height: 50),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                BlocConsumer<FixtureBloc, FixtureState>(builder: (_, state){
                                  if (state is GetFixtureSuccessfulState) {
                                    return buildInitialInput();
                                  } else if (state is GetFixtureLoadingState) {
                                    return fixtureLoading();
                                  } else if (state is GetFixtureFailedState) {
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
                                    return errorView(
                                        iconPath: state.error == socketErrorMessage
                                            ? "images/connection.png"
                                            : "images/error.png",
                                        title: "Ooops!",
                                        text: state.error,
                                        onPressed: () {
                                          final getFixture = BlocProvider.of<FixtureBloc>(context);
                                          getFixture.add(GetFixturesEvent(round.toString()));
                                        });
                                  } else {
                                    return SizedBox();
                                  }
                                }, listener: (_, state) async {
                                  matches = [];
                                  groupedMatches = {};
                                  gameWeekStartFormattedDate = "";
                                  if(state is GetFixtureSuccessfulState){

                                    ads = state.matches.ads;
                                    setState(() {});

                                    round = int.parse(state.matches.matches.last.round);

                                    fixValue = round;

                                    matches.addAll(state.matches.matches);
                                    matches.sort((a, b) => a.timestampstart.compareTo(b.timestampstart));

                                    MatchModel earliestMatch = matches.first;
                                    String earliestMatchFormattedDate = timeConvert.formatTimestampToDateTime(int.parse(earliestMatch.timestampstart));

                                    gameWeekStartFormattedDate = earliestMatchFormattedDate;

                                    for (MatchModel match in matches) {
                                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(match.timestampstart) * 1000);
                                      String formattedDate = "${timeConvert.getDayOfWeek(dateTime.weekday)}, ${dateTime.day} ${timeConvert.getMonth(dateTime.month)}";

                                      if (!groupedMatches.containsKey(formattedDate)) {
                                        groupedMatches[formattedDate] = [];
                                      }
                                      groupedMatches[formattedDate]!.add(match);
                                    }
                                  } else if(state is GetFixtureFailedState){
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
                                  }
                                }),
                                SizedBox(height: 30,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          ads.isEmpty ? SizedBox() : AdsComponent(ads: ads, height: 50),
        ],
      ),
    );
  }

  Widget buildInitialInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     GestureDetector(
        //       onTap: (){
        //         if(round != 1){
        //           round = round! - 1;
        //           final getMatches = BlocProvider.of<FixtureBloc>(context);
        //           getMatches.add(GetFixturesEvent(round.toString()));
        //         }
        //       },
        //       child: Container(
        //         width: 35,
        //         height: 35,
        //         decoration: BoxDecoration(
        //             color: Color(0xFF1E727E).withOpacity(0.2),
        //             borderRadius: BorderRadius.circular(30)
        //         ),
        //         child: Center(child: Iconify(Ic.sharp_navigate_before, color: primaryColor, size: 30,)),
        //       ),
        //     ),
        //     Column(
        //       children: [
        //         Text("Gameweek $round", style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),),
        //         Text(gameWeekStartFormattedDate, style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w400),),
        //       ],
        //     ),
        //     GestureDetector(
        //       onTap: (){
        //         if(round != 38){
        //           round = round! + 1;
        //           final getMatches = BlocProvider.of<FixtureBloc>(context);
        //           getMatches.add(GetFixturesEvent(round.toString()));
        //         }
        //       },
        //       child: Container(
        //         width: 35,
        //         height: 35,
        //         decoration: BoxDecoration(
        //             color: Color(0xFF1E727E).withOpacity(0.2),
        //             borderRadius: BorderRadius.circular(30)
        //         ),
        //         child: Center(child: Iconify(Ic.sharp_navigate_next, color: primaryColor, size: 30)),
        //       ),
        //     )
        //   ],
        // ),
        SizedBox(height: 20,),
        Text(AppLocalizations.of(context)!.fixtures, style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w600),),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
                value: fixValue,
                isExpanded: true,
                hint: Text(
                  "GameWeek $fixValue",
                  style: TextStyle(
                      color: textColor,
                      fontSize: textFontSize2,
                      fontWeight: FontWeight.w500),
                ),
                items: fixtures.map(buildFixtures).toList(),
                icon: Iconify(
                  MaterialSymbols.arrow_drop_down_rounded,
                  color: primaryColor,
                  size: 30,
                ),
                onChanged: (value) {
                  final getMatches = BlocProvider.of<FixtureBloc>(context);
                  getMatches.add(GetFixturesEvent(value.toString()));
                }),
          ),
        ),
        SizedBox(height: 20,),
        ListView.builder(
          padding: EdgeInsets.zero,
            itemCount: groupedMatches.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){

              String formattedDate = groupedMatches.keys.elementAt(index);
              List<MatchModel> matchesForDate = groupedMatches[formattedDate] ?? [];

              return fixtureComponent(formattedDate: formattedDate, matches: matchesForDate);
            }),
      ],
    );
  }

  Widget fixtureLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        BlinkContainer(width: 120, height: 20, borderRadius: 0),
        SizedBox(height: 10,),
        BlinkContainer(width: double.infinity, height: 50, borderRadius: 4),
        SizedBox(height: 20,),
        BlinkContainer(width: double.infinity, height: 150, borderRadius: 15),
        SizedBox(height: 15,),
        BlinkContainer(width: double.infinity, height: 150, borderRadius: 15),
        SizedBox(height: 5,),
        Divider(thickness: 1.0, color: lightPrimary,),
        SizedBox(height: 5,),
        BlinkContainer(width: double.infinity, height: 150, borderRadius: 15),
        SizedBox(height: 15,),
        BlinkContainer(width: double.infinity, height: 150, borderRadius: 15),
        SizedBox(height: 5,),
        Divider(thickness: 1.0, color: lightPrimary,),
        SizedBox(height: 5,),
        BlinkContainer(width: double.infinity, height: 150, borderRadius: 15),
        SizedBox(height: 5,),
        Divider(thickness: 1.0, color: lightPrimary,),
        SizedBox(height: 5,),
        BlinkContainer(width: double.infinity, height: 150, borderRadius: 15),
      ],
    );
  }

  DropdownMenuItem<int> buildFixtures(int fixture) => DropdownMenuItem(
      value: fixture,
      child: Text(
        "GameWeek $fixture",
        style: TextStyle(
            color: primaryColor,
            fontSize: textFontSize2,
            fontWeight: FontWeight.w500),
      ));

}
