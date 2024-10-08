class MatchStat{
  final String name;
  final num home;
  final num away;

  MatchStat({required this.name, required this.home, required this.away});

  factory MatchStat.fromJson(Map<String, dynamic> json) =>
      MatchStat(name: json["name"], home: json["home"], away: json["away"]);
}