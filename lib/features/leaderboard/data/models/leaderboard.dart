import 'package:fantasy/features/leaderboard/data/models/client_id.dart';

class Leaderboard {
  final String id;
  final ClientId client_id;
  final num total_fantasy_point;
  final num rank;

  Leaderboard(
      {required this.id,
        required this.client_id,
        required this.total_fantasy_point, required this.rank});

  factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
      id: json["_id"],
      client_id: ClientId.fromJson(json["client_id"]),
      total_fantasy_point: json["total_fantasy_point"],
      rank: json["rank"]
  );
}
