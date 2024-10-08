import 'package:fantasy/features/guidelines/data/models/injured_player_model.dart';

class InjuryModel {
  final String id;
  final InjuredPlayer injuredPlayer;
  final String state;
  final String? injury_title;
  final num chance;

  InjuryModel(
      {required this.id,
      required this.injuredPlayer,
      required this.state, this.injury_title,
      required this.chance});

  factory InjuryModel.fromJson(Map<String, dynamic> json) => InjuryModel(
      id: json["_id"],
      injuredPlayer: InjuredPlayer.fromJson(json["player"]),
      state: json["state"],
      injury_title: json["injury_title"],
      chance: json["chance"]);
}
