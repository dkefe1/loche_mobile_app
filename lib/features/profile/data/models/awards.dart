import 'package:fantasy/features/leaderboard/data/models/client_id.dart';

class Awards {
  final num total_fantasy_point;
  final ClientId client_id;
  final num prize;

  Awards(
      {required this.total_fantasy_point,
      required this.client_id,
      required this.prize});

  factory Awards.fromJson(Map<String, dynamic> json) => Awards(
      total_fantasy_point: json["total_fantasy_point"],
      client_id: ClientId.fromJson(json["client_id"]),
      prize: json["prize"]);
}
