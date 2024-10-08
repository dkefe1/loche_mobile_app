class MostSelected {
  final num selected;
  final String full_name;
  final String club;
  final String position;

  MostSelected(
      {required this.selected, required this.full_name, required this.club, required this.position});

  factory MostSelected.fromJson(Map<String, dynamic> json) => MostSelected(
      selected: json["selected"],
      full_name: json["player_info"]["full_name"],
    club: json["player_info"]["club"],
    position: json["player_info"]["position"],
  );
}
