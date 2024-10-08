import 'package:fantasy/features/fixture/data/models/result.dart';
import 'package:fantasy/features/fixture/data/models/team.dart';

class MatchModel {
  final String mid;
  final String round;
  final Result result;
  final Team home;
  final Team away;
  final String status;
  final String status_str;
  final String time;
  final String timestampstart;
  final String timestampend;

  MatchModel(
      {required this.mid,
      required this.round,
      required this.result,
      required this.home,
      required this.away,
      required this.status,
      required this.status_str,
      required this.time,
      required this.timestampstart,
      required this.timestampend});

  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
      mid: json["mid"],
      round: json["round"],
      result: Result.fromJson(json["result"]),
      home: Team.fromJson(json["teams"]["home"]),
      away: Team.fromJson(json["teams"]["away"]),
      status: json["status"],
      status_str: json["status_str"],
      time: json["time"],
      timestampstart: json["timestampstart"],
      timestampend: json["timestampend"]);
}
