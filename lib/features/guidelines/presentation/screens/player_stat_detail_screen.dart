import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/assign_kit.dart';
import 'package:fantasy/features/guidelines/data/models/player_stat.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/home/presentation/widgets/client_player_detail_component.dart';
import 'package:fantasy/features/home/presentation/widgets/yes_or_no_player_component.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/tabler.dart';

class PlayerStatDetailScreen extends StatefulWidget {

  PlayerStat clientPlayer;

  PlayerStatDetailScreen({super.key, required this.clientPlayer});

  @override
  State<PlayerStatDetailScreen> createState() => _PlayerStatDetailScreenState();
}

class _PlayerStatDetailScreenState extends State<PlayerStatDetailScreen> {

  Kit kit = Kit();

  bool switched = false;

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
            AppHeader(title: "", desc: "Player detail"),
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
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 61.03,
                                height: 84.33,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage(kit.getKit(team: widget.clientPlayer.club, position: widget.clientPlayer.position)), fit: BoxFit.fill)
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(widget.clientPlayer.full_name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textBlackColor),),
                              Text(widget.clientPlayer.position, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: textColor),),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Text("This are the information of this week's player performance", style: TextStyle(color: textColor, fontSize: 12),),
                        SizedBox(height: 10,),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                              color: lightPrimary,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text("Performance", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),)),
                                      Expanded(child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(switched ? "Status" : "Points", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),),
                                          SizedBox(width: 10,),
                                          widget.clientPlayer.stat == null ? SizedBox() : GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                switched = !switched;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: Iconify(Tabler.switch_horizontal, color: Colors.white,),
                                            ),
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Divider(color: dividerColor, thickness: 1.0,),
                                  SizedBox(height: 10,),
                                ],
                              ),
                              switched ? clientPlayerComponent(label: "Minutes Played", value: widget.clientPlayer.minutesplayed) : SizedBox(),
                              clientPlayerComponent(label: "Goal Scored", value: switched ? widget.clientPlayer.stat!.goalscored : widget.clientPlayer.goalscored),
                              clientPlayerComponent(label: "Assist", value: switched ? widget.clientPlayer.stat!.assist : widget.clientPlayer.assist),
                              clientPlayerComponent(label: "Passes", value: switched ? widget.clientPlayer.stat!.passes : widget.clientPlayer.passes),
                              clientPlayerComponent(label: "Shots On Target", value: switched ? widget.clientPlayer.stat!.shotsontarget : widget.clientPlayer.shotsontarget),
                              clientPlayerComponent(label: "Clean Sheet", value: switched ? widget.clientPlayer.stat!.cleansheet : widget.clientPlayer.cleansheet),
                              clientPlayerComponent(label: "Shots Saved", value: switched ? widget.clientPlayer.stat!.shotssaved : widget.clientPlayer.shotssaved),
                              clientPlayerComponent(label: "Penalty Saved", value: switched ? widget.clientPlayer.stat!.penaltysaved : widget.clientPlayer.penaltysaved),
                              clientPlayerComponent(label: "Tackle Successful", value: switched ? widget.clientPlayer.stat!.tacklesuccessful : widget.clientPlayer.tacklesuccessful),
                              clientPlayerComponent(label: "Yellow Card", value: switched ? widget.clientPlayer.stat!.yellowcard : widget.clientPlayer.yellowcard),
                              clientPlayerComponent(label: "Red Card", value: switched ? widget.clientPlayer.stat!.redcard : widget.clientPlayer.redcard),
                              clientPlayerComponent(label: "Own Goal", value: switched ? widget.clientPlayer.stat!.owngoal : widget.clientPlayer.owngoal),
                              clientPlayerComponent(label: "Goals Conceded", value: switched ? widget.clientPlayer.stat!.goalsconceded : widget.clientPlayer.goalsconceded),
                              clientPlayerComponent(label: "Penalty Missed", value: switched ? widget.clientPlayer.stat!.penaltymissed : widget.clientPlayer.penaltymissed),
                              widget.clientPlayer.chancecreated == null ? SizedBox() : clientPlayerComponent(label: "Chance Created", value: switched ? widget.clientPlayer.stat!.chancecreated! : widget.clientPlayer.chancecreated!),
                              widget.clientPlayer.starting == null ? SizedBox() : switched ? yesOrNoClientPlayerComponent(label: "Starting", value: widget.clientPlayer.stat!.starting11!) : clientPlayerComponent(label: "Starting", value: widget.clientPlayer.starting!),
                              widget.clientPlayer.substitute == null ? SizedBox() : switched ? yesOrNoClientPlayerComponent(label: "Substitute", value: widget.clientPlayer.stat!.substitute!) : clientPlayerComponent(label: "Substitute", value: widget.clientPlayer.substitute!),
                              // clientPlayerComponent(label: "Blocked Shot", value: switched ? widget.clientPlayer.stat!.blockedshot : widget.clientPlayer.blockedshot),
                              clientPlayerComponent(label: "Interception Won", value: switched ? widget.clientPlayer.stat!.interceptionwon : widget.clientPlayer.interceptionwon),
                              // clientPlayerComponent(label: "Clearance", value: switched ? widget.clientPlayer.stat!.clearance : widget.clientPlayer.clearance),
                              switched ? SizedBox() : clientPlayerComponent(label: "Total", value: widget.clientPlayer.fantasy_point),
                            ],
                          ),
                        ),
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
}
