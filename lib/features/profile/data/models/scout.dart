class Scout {
  String? id;
  String? client_id;
  final String player_id;
  final String player_name;
  final String player_number;
  final String position;
  final String team;
  final String club_logo;
  String? createdAt;
  String? updatedAt;

  Scout(
      {this.id, this.client_id,
      required this.player_id,
      required this.player_name,
      required this.player_number,
      required this.position,
      required this.team,
      required this.club_logo,
        this.createdAt, this.updatedAt});

  factory Scout.fromJson(Map<String, dynamic> json) => Scout(
      id: json["id"],
      client_id: json["client_id"],
      player_id: json["player_id"],
      player_name: json["player_name"],
      player_number: json["player_number"],
      position: json["position"],
      team: json["team"],
      club_logo: json["club_logo"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);
}
