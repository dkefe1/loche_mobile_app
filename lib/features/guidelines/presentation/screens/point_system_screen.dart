import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/guidelines/data/models/point_system_model.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/bullet_list.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/point_system_component.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PointSystemScreen extends StatefulWidget {
  const PointSystemScreen({Key? key}) : super(key: key);

  @override
  State<PointSystemScreen> createState() => _PointSystemScreenState();
}

class _PointSystemScreenState extends State<PointSystemScreen> {
  
  List<PointSystemModel> attackerContents = [];

  List<PointSystemModel> defenderContents = [];

  List<PointSystemModel> otherContents = [];

  List<PointSystemModel> negativeContents = [];
  
  @override
  Widget build(BuildContext context) {

    attackerContents = [
      PointSystemModel(name: AppLocalizations.of(context)!.goal_scored_for, value: AppLocalizations.of(context)!.goal_scored_for_desc, point: 10),
      PointSystemModel(name: AppLocalizations.of(context)!.goal_scored_mid, value: AppLocalizations.of(context)!.goal_scored_mid_desc, point: 12.5),
      PointSystemModel(name: AppLocalizations.of(context)!.goal_scored_def, value: AppLocalizations.of(context)!.goal_scored_def_desc, point: 15),
      PointSystemModel(name: AppLocalizations.of(context)!.assist, value: AppLocalizations.of(context)!.assist_desc, point: 5),
      PointSystemModel(name: AppLocalizations.of(context)!.shot_on_target, value: AppLocalizations.of(context)!.shot_on_target_desc, point: 1.5),
      PointSystemModel(name: AppLocalizations.of(context)!.chance_created, value: AppLocalizations.of(context)!.chance_created_desc, point: 1.5),
      PointSystemModel(name: AppLocalizations.of(context)!.passes_completed, value: AppLocalizations.of(context)!.passes_completed_desc, point: 1),
    ];

    defenderContents = [
      PointSystemModel(name: AppLocalizations.of(context)!.tackle_won, value: AppLocalizations.of(context)!.tackle_won_desc, point: 1),
      PointSystemModel(name: AppLocalizations.of(context)!.interception, value: AppLocalizations.of(context)!.interception_desc, point: 1),
      PointSystemModel(name: AppLocalizations.of(context)!.goal_keeper_save, value: AppLocalizations.of(context)!.goal_keeper_save_desc, point: 1.5),
      PointSystemModel(name: AppLocalizations.of(context)!.clean_sheet, value: AppLocalizations.of(context)!.clean_sheet_desc, point: 5),
      PointSystemModel(name: AppLocalizations.of(context)!.penalty_saved, value: AppLocalizations.of(context)!.penalty_saved_desc, point: 12.5),
    ];

    otherContents = [
      PointSystemModel(name: AppLocalizations.of(context)!.starting, value: AppLocalizations.of(context)!.starting_desc, point: 1),
      PointSystemModel(name: AppLocalizations.of(context)!.substitute, value: AppLocalizations.of(context)!.substitute_desc, point: 0.5),
    ];

    negativeContents = [
      PointSystemModel(name: AppLocalizations.of(context)!.own_goal, value: AppLocalizations.of(context)!.own_goal_desc, point: 2),
      PointSystemModel(name: AppLocalizations.of(context)!.penalty_missed, value: AppLocalizations.of(context)!.penalty_missed_desc, point: 5),
      PointSystemModel(name: AppLocalizations.of(context)!.yellow_card, value: AppLocalizations.of(context)!.yellow_card_desc, point: 1),
      PointSystemModel(name: AppLocalizations.of(context)!.red_card, value: AppLocalizations.of(context)!.red_card_desc, point: 2.5),
      PointSystemModel(name: AppLocalizations.of(context)!.two_goals_conceded, value: AppLocalizations.of(context)!.two_goals_conceded_desc, point: 1),
    ];

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
                AppLocalizations.of(context)!.point_system_2),
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
                          AppLocalizations.of(context)!.points_system,
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          AppLocalizations.of(context)!.point_system_desc,
                          style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        pointSystemComponent(title: AppLocalizations.of(context)!.attacking_points, contents: attackerContents, onPressed: (){
                          setState(() {});
                        }),
                        SizedBox(height: 15,),
                        pointSystemComponent(title: AppLocalizations.of(context)!.defending_points, contents: defenderContents, onPressed: (){
                          setState(() {});
                        }),
                        SizedBox(height: 15,),
                        pointSystemComponent(title: AppLocalizations.of(context)!.other_points, contents: otherContents, onPressed: (){
                          setState(() {});
                        }),
                        SizedBox(height: 15,),
                        pointSystemComponent(title: AppLocalizations.of(context)!.negative_points, contents: negativeContents, onPressed: (){
                          setState(() {});
                        }),
                        SizedBox(height: 40,),
                        Text(AppLocalizations.of(context)!.remark, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600),),
                        SizedBox(height: 10,),
                        bulletList(text: AppLocalizations.of(context)!.remark_one),
                        bulletList(text: AppLocalizations.of(context)!.remark_two),
                        bulletList(text: AppLocalizations.of(context)!.remark_three),
                        bulletList(text: AppLocalizations.of(context)!.remark_four),
                        bulletList(text: AppLocalizations.of(context)!.remark_5),
                        bulletList(text: AppLocalizations.of(context)!.remark_6),
                        bulletList(text: AppLocalizations.of(context)!.remark_7),
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
