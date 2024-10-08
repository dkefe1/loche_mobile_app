import 'package:fantasy/features/home/data/models/stat.dart';

class PlayerStat {
  final String pid;
  final String full_name;
  final String position;
  final String club;
  final num fantasy_point;
  final num minutesplayed;
  final num goalscored;
  final num assist;
  final num passes;
  final num shotsontarget;
  final num cleansheet;
  final num shotssaved;
  final num penaltysaved;
  final num tacklesuccessful;
  final num yellowcard;
  final num redcard;
  final num owngoal;
  final num goalsconceded;
  final num penaltymissed;
  final num? chancecreated;
  final num? starting;
  final num? substitute;
  // final num blockedshot;
  final num interceptionwon;
  // final num clearance;
  final String id;
  Stat? stat;

  PlayerStat(
      {required this.pid,
        required this.full_name,
        required this.position,
        required this.club,
        required this.fantasy_point,
        required this.minutesplayed,
        required this.goalscored,
        required this.assist,
        required this.passes,
        required this.shotsontarget,
        required this.cleansheet,
        required this.shotssaved,
        required this.penaltysaved,
        required this.tacklesuccessful,
        required this.yellowcard,
        required this.redcard,
        required this.owngoal,
        required this.goalsconceded,
        required this.penaltymissed,
        required this.chancecreated,
        required this.starting,
        required this.substitute,
        // required this.blockedshot,
        required this.interceptionwon,
        // required this.clearance,
        required this.id, this.stat});

  factory PlayerStat.fromJson(Map<String, dynamic> json) => PlayerStat(
      pid: json["pid"],
      full_name: json["full_name"] ?? "",
      position: json["position"],
      club: json["tname"],
      fantasy_point: json["fantasy_point"],
      minutesplayed: json["minutesplayed"],
      goalscored: json["goalscored"],
      assist: json["assist"],
      passes: json["passes"],
      shotsontarget: json["shotsontarget"],
      cleansheet: json["cleansheet"],
      shotssaved: json["shotssaved"],
      penaltysaved: json["penaltysaved"],
      tacklesuccessful: json["tacklesuccessful"],
      yellowcard: json["yellowcard"],
      redcard: json["redcard"],
      owngoal: json["owngoal"],
      goalsconceded: json["goalsconceded"],
      penaltymissed: json["penaltymissed"],
      chancecreated: json["chancecreated"],
      starting: json["starting11"],
      substitute: json["substitute"],
      // blockedshot: json["blockedshot"],
      interceptionwon: json["interceptionwon"],
      // clearance: json["clearance"],
      id: json["_id"], stat: json["stat"] == null ? null : Stat.fromJson(json["stat"]));
}
