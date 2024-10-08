import 'package:fantasy/features/home/data/models/create_player_model.dart';

class CreateTeamModel {
  final String competition;
  final String team_name;
  final String favorite_coach;
  final String favorite_tactic;
  final List<CreatePlayerModel> players;

  CreateTeamModel(
      {required this.competition,
      required this.team_name,
      required this.favorite_coach,
      required this.favorite_tactic,
      required this.players});

  factory CreateTeamModel.fromJson(Map<String, dynamic> json) =>
      CreateTeamModel(
          competition: json["competition"],
          team_name: json["team_name"],
          favorite_coach: json["favorite_coach"],
          favorite_tactic: json["favorite_tactic"],
          players: json["players"].map((player) => CreatePlayerModel.fromJson(player)).toList());

  Map<String, dynamic> toJson() => {
    "competition": competition,
    "team_name": team_name,
    "favorite_coach": favorite_coach,
    "favorite_tactic": favorite_tactic,
    "players": List<dynamic>.from(players.map((player) => player.toJson())),
  };
}
