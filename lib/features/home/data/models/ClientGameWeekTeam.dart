import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/game_week_id.dart';

class ClientGameWeekTeam{
  final String id;
  final GameWeekId game_week_id;

  ClientGameWeekTeam(
      {required this.id,
        required this.game_week_id});

  factory ClientGameWeekTeam.fromJson(Map<String, dynamic> json) {

    return ClientGameWeekTeam(
      id: json["id"],
      game_week_id: GameWeekId.fromJson(json["game_week_id"]));
  }
}