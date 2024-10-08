import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/how_to_play_component.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/htp_sub_component.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/pro_tip_widget.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({Key? key}) : super(key: key);

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
                AppLocalizations.of(context)!.discover_the_winning_playbook),
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
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      AppLocalizations.of(context)!.how_to_play,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    howToPlayComponent(
                        title: AppLocalizations.of(context)!.create_your_team,
                        description:
                        AppLocalizations.of(context)!.create_your_team_welcome,
                        iconPath: "images/htp_match.png",
                        iconHeight: 25,
                        iconWidth: 26.32),
                    SizedBox(
                      height: 10,
                    ),
                    proTipWidget(
                        value:
                        AppLocalizations.of(context)!.pro_tip_one, context: context),
                    SizedBox(height: 50,),
                    htpSubComponent(title: AppLocalizations.of(context)!.what_are_loche_credits, description: AppLocalizations.of(context)!.what_are_loche_credits_desc),
                    SizedBox(height: 20,),
                    htpSubComponent(title: AppLocalizations.of(context)!.what_are_fantasy_points, description: AppLocalizations.of(context)!.what_are_fantasy_points_desc),
                    SizedBox(height: 20,),
                    htpSubComponent(title: AppLocalizations.of(context)!.joining_leagues, description: AppLocalizations.of(context)!.joining_leagues_desc),
                    SizedBox(height: 10,),
                    proTipWidget(value: AppLocalizations.of(context)!.pro_tip_two, context: context),
                    SizedBox(height: 50,),
                    howToPlayComponent(title: AppLocalizations.of(context)!.joining_game_week_process, description: AppLocalizations.of(context)!.joining_game_week_process_desc, iconPath: "images/htp_credit.png", iconHeight: 18.12, iconWidth: 28),
                    SizedBox(height: 10,),
                    proTipWidget(value: AppLocalizations.of(context)!.pro_tip_three, context: context),
                    SizedBox(height: 50,),
                    howToPlayComponent(title: AppLocalizations.of(context)!.payment_process, description: """${AppLocalizations.of(context)!.payment_process_desc}""", iconPath: "images/htp_trophy.png", iconHeight: 20, iconWidth: 14),
                    SizedBox(height: 50,),
                    Text(AppLocalizations.of(context)!.good_luck, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600),),
                    SizedBox(height: 5,),
                    Text(AppLocalizations.of(context)!.good_luck_desc, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w500),),
                    SizedBox(height: 40,)
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
