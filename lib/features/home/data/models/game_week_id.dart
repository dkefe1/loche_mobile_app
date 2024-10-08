class GameWeekId {
  final String id;
  final String game_week;
  final bool is_done;
  final String first_match_start_date;

  GameWeekId(
      {required this.id,
      required this.game_week,
      required this.is_done,
      required this.first_match_start_date});

  factory GameWeekId.fromJson(Map<String, dynamic> json) => GameWeekId(
      id: json["id"],
      game_week: json["game_week"],
      is_done: json["is_done"],
      first_match_start_date: json["first_match_start_date"]);
}
