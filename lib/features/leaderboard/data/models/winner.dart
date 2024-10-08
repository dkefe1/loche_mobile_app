import 'package:fantasy/features/leaderboard/data/models/client_id.dart';

class Winner {
  final String id;
  final ClientId client_id;
  final String season;
  final String weekly_monthly_yearly;
  final num prize;
  final num total_fantasy_point;

  Winner(
      {required this.id,
      required this.client_id,
      required this.season,
      required this.weekly_monthly_yearly,
      required this.prize, required this.total_fantasy_point});

  factory Winner.fromJson(Map<String, dynamic> json) => Winner(
      id: json["_id"],
      client_id: ClientId.fromJson(json["client_id"]),
      season: json["season"],
      weekly_monthly_yearly: json["weekly_monthly_yearly"],
      prize: json["prize"], total_fantasy_point: json["total_fantasy_point"]);
}
