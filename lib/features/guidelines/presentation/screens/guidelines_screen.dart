import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/guidelines/presentation/screens/about_us_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/faq_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/feedback_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/how_to_play_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/injured_players_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/player_selection_stat_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/player_stat_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/point_system_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/poll_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/privacy_policy_screen.dart';
import 'package:fantasy/features/guidelines/presentation/screens/terms_and_conditions_screen.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/guidelines_detail_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  AppLocalizations.of(context)!.informations,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 20,),
                Text(
                  AppLocalizations.of(context)!.poll.toUpperCase(),
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w400,
                      fontSize: textFontSize),
                ),
                SizedBox(
                  height: 10,
                ),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.poll,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PollScreen()));
                    }),
                SizedBox(height: 10,),
                Text(
                  AppLocalizations.of(context)!.player_stat.toUpperCase(),
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w400,
                      fontSize: textFontSize),
                ),
                SizedBox(
                  height: 10,
                ),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.player_stat,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerStatScreen()));
                    }),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.player_selection_stat,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerSelectionStatScreen(gameWeek: null,)));
                    }),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.injured_banned_list,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InjuredPlayersScreen()));
                    }),
                SizedBox(height: 10,),
                Text(
                  AppLocalizations.of(context)!.guides,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w400,
                      fontSize: textFontSize),
                ),
                SizedBox(
                  height: 10,
                ),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.how_to_play,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HowToPlayScreen()));
                    }),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.points_system,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PointSystemScreen()));
                    }),
                SizedBox(height: 10,),
                Text(
                  AppLocalizations.of(context)!.support,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w400,
                      fontSize: textFontSize),
                ),
                SizedBox(
                  height: 10,
                ),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.faq,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FAQScreen()));
                    }),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.terms_and_conditions,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditionsScreen()));
                    }),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.privacy_policy,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
                    }),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.feedback,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen()));
                    }),
                guidelinesDetailBox(
                    label: AppLocalizations.of(context)!.about_us,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
                    }),
                SizedBox(height: 30,)
              ],
            ),
          ),
        ));
  }
}
