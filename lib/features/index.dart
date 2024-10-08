import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/language_provider.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/fixture/presentation/screens/fixture_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/guidelines_screen.dart';
import 'package:fantasy/features/home/data/models/client_players.dart';
import 'package:fantasy/features/home/presentation/screens/home_screen2.dart';
import 'package:fantasy/features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndexScreen extends StatefulWidget {
  IndexScreen({Key? key, required this.pageIndex}) : super(key: key);

  int pageIndex;

  @override
  State<IndexScreen> createState() => _IndexScreenState(pageIndex: pageIndex);
}

class _IndexScreenState extends State<IndexScreen> {
  _IndexScreenState({required this.pageIndex});
  int pageIndex;

  final pages = [HomeScreen2(), LeaderBoardScreen(), ProfileScreen(), FixtureScreen(), GuidelinesScreen()];
  List<String> messages = [];

  DateTime? currentBackPressTime;

  final prefService = PrefService();

  @override
  Widget build(BuildContext context) {

    messages = ["",
      AppLocalizations.of(context)!.ranking,
      AppLocalizations.of(context)!.take_control_of_your_profile,
      AppLocalizations.of(context)!.fixtures,
      AppLocalizations.of(context)!.discover_the_winning_playbook];

    return Platform.isIOS ?
    GestureDetector(
        onPanUpdate: (details) async {
          if (details.delta.dx > 30) {
            final checkSwitch = Provider.of<ClientPlayersProvider>(context, listen: false);
            if(checkSwitch.isSwitch){
              checkSwitch.showSwitch();
              return;
            }
            DateTime now = DateTime.now();
            if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
              currentBackPressTime = now;
              Fluttertoast.showToast(backgroundColor: primaryColor, msg: AppLocalizations.of(context)!.tap_twice_to_exit);
              return;
            }
            Navigator.of(context).pop();
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: buildInitialInput(),
        )
    )
        : WillPopScope(
      onWillPop: () async {
        final checkSwitch = Provider.of<ClientPlayersProvider>(context, listen: false);
        if(checkSwitch.isSwitch){
          checkSwitch.showSwitch();
          return false;
        }
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(backgroundColor: primaryColor, msg: AppLocalizations.of(context)!.tap_twice_to_exit);
          return false;
        }
        return true;
      },
      child: buildInitialInput(),
    );
  }

  Widget buildInitialInput(){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            pageIndex == 0 ? SizedBox() : Row(
              children: [
                Expanded(child: AppHeader(title: "", desc: messages[pageIndex])),
                pageIndex == 2 ? Padding(
                  padding: const EdgeInsets.only(right: 20.0),
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
                ) : SizedBox()
              ],
            ),
            pages[pageIndex]
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
                "images/home.svg",
                color: pageIndex == 0 ? primaryColor : unSelectedIconColor,
                semanticsLabel: 'A home icon'
            ),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined, color: pageIndex == 1 ? primaryColor : unSelectedIconColor,),
            label: AppLocalizations.of(context)!.ranking,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
                "images/profile.svg",
                color: pageIndex == 2 ? primaryColor : unSelectedIconColor,
                semanticsLabel: 'A profile icon'
            ),
            label: AppLocalizations.of(context)!.profile,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: pageIndex == 3 ? primaryColor : unSelectedIconColor,),
            label: AppLocalizations.of(context)!.fixtures,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
                "images/guide.svg",
                color: pageIndex == 4 ? primaryColor : unSelectedIconColor,
                semanticsLabel: 'A guidelines icon'
            ),
            label: AppLocalizations.of(context)!.info,
          ),
        ],
      ),
    );
  }

}
