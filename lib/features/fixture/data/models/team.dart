class Team {
  final String tid;
  final String tname;
  final String logo;
  final String fullname;
  final String abbr;

  Team(
      {required this.tid,
      required this.tname,
      required this.logo,
      required this.fullname,
      required this.abbr});

  factory Team.fromJson(Map<String, dynamic> json) => Team(
      tid: json["tid"],
      tname: json["tname"],
      logo: json["logo"],
      fullname: json["fullname"],
      abbr: json["abbr"]);
}
