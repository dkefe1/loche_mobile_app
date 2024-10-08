class MatchInfo {
  final String? pname;
  final String type;
  final String time;
  final String injurytime;
  final String name;
  final String team;
  final Map<String, dynamic>? assistPName;
  final String? goaltype;
  final String? card;
  final String? player_in_name;
  final String? player_out_name;

  MatchInfo(
      {this.pname,
      required this.type,
      required this.time,
      required this.injurytime,
      required this.name,
      required this.team,
      this.assistPName,
      this.goaltype,
      this.card,
      this.player_in_name,
      this.player_out_name});

  factory MatchInfo.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic>? assist;

    if(json["assists"].runtimeType == List){
      assist = null;
    } else {
      assist = json["assists"];
    }

    return MatchInfo(
      pname: json["pname"],
      type: json["type"],
      time: json["time"],
      injurytime: json["injurytime"],
      name: json["name"],
      team: json["team"],
      assistPName: assist,
      goaltype: json["goaltype"],
      card: json["card"],
      player_in_name: json["player_in_name"],
      player_out_name: json["player_out_name"],
  );
  }
}
