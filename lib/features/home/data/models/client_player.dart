import 'package:fantasy/features/home/data/models/stat.dart';

class ClientPlayer {
  final String pid;
  final String full_name;
  final String position;
  final num price;
  final String club;
  final String club_logo;
  final bool is_bench;
  final bool is_captain;
  final bool is_vice_captain;
  final bool is_switched;
  final num fantasy_point;
  final num final_fantasy_point;
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
  final num chancecreated;
  final num starting;
  final num substitute;
  final num blockedshot;
  final num interceptionwon;
  final num clearance;
  final String id;
  Stat? stat;
  String? switched_by;

  ClientPlayer(
      {required this.pid,
      required this.full_name,
      required this.position,
      required this.price,
      required this.club,
      required this.club_logo,
      required this.is_bench,
      required this.is_captain,
      required this.is_vice_captain,
      required this.is_switched,
      required this.fantasy_point,
      required this.final_fantasy_point,
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
      required this.blockedshot,
      required this.interceptionwon,
      required this.clearance,
      required this.id, this.stat, this.switched_by});

  factory ClientPlayer.fromJson(Map<String, dynamic> json) => ClientPlayer(
      pid: json["pid"],
      full_name: json["full_name"] ?? "",
      position: json["position"],
      price: json["price"],
      club: json["club"],
      club_logo: json["club_logo"] ?? "",
      is_bench: json["is_bench"],
      is_captain: json["is_captain"],
      is_vice_captain: json["is_vice_captain"],
      is_switched: json["is_switched"] ?? false,
      fantasy_point: json["fantasy_point"],
      final_fantasy_point: json["final_fantasy_point"],
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
      starting: json["starting"],
      substitute: json["substitute"],
      blockedshot: json["blockedshot"],
      interceptionwon: json["interceptionwon"],
      clearance: json["clearance"],
      id: json["_id"], stat: json["stat"] == null ? null : Stat.fromJson(json["stat"]), switched_by: json["switched_by"]);
}
