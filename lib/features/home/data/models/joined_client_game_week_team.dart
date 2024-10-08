import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/game_week_id.dart';

class JoinedClientGameWeekTeam {
  final String id;
  final GameWeekId game_week_id;
  final String client_id;
  final List<ClientPlayer> players;
  final num total_fantasy_point;

  JoinedClientGameWeekTeam(
      {required this.id,
      required this.game_week_id,
      required this.client_id,
      required this.players,
      required this.total_fantasy_point});

  factory JoinedClientGameWeekTeam.fromJson(Map<String, dynamic> json) {

    List apiPlayers = json["players"];
    List<ClientPlayer> players =
        apiPlayers.map((player) => ClientPlayer.fromJson(player)).toList();

    return JoinedClientGameWeekTeam(
        id: json["_id"],
        game_week_id: GameWeekId.fromJson(json["game_week_id"]),
        client_id: json["client_id"],
        players: players,
        total_fantasy_point: json["total_fantasy_point"]);
  }
}
