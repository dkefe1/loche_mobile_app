class Result{
  final String home;
  final String away;
  final String winner;

  Result({required this.home, required this.away, required this.winner});

  factory Result.fromJson(Map<String, dynamic> json) => Result(home: json["home"], away: json["away"], winner: json["winner"]);
}