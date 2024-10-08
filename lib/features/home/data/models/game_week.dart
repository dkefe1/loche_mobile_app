class GameWeek {
  final String id;
  final String game_week;
  final String transfer_deadline;
  final bool is_done;

  GameWeek(
      {required this.id,
      required this.game_week,
      required this.transfer_deadline,
      required this.is_done});

  factory GameWeek.fromJson(Map<String, dynamic> json) => GameWeek(
      id: json["id"],
      game_week: json["game_week"],
      transfer_deadline: json["transfer_deadline"],
      is_done: json["is_done"]);
}
