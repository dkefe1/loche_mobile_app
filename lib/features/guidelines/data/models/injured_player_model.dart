class InjuredPlayer {
  final String pid;
  final String pname;
  final String role;
  final String rating;
  final String tname;
  final String tlogo;
  final String tfullname;
  final String tabbr;

  InjuredPlayer(
      {required this.pid,
      required this.pname,
      required this.role,
      required this.rating,
      required this.tname,
      required this.tlogo,
      required this.tabbr,
      required this.tfullname});

  factory InjuredPlayer.fromJson(Map<String, dynamic> json) => InjuredPlayer(pid: json["pid"], pname: json["pname"], role: json["role"], rating: json["rating"], tname: json["team"]["tname"], tlogo: json["team"]["logo"], tabbr: json["team"]["abbr"], tfullname: json["team"]["fullname"]);
}
