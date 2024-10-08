class MonthlyLeader {
  final String id;
  final String first_name;
  final String last_name;
  final num total_fantasy_point;
  final num rank;

  MonthlyLeader(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.total_fantasy_point, required this.rank});

  factory MonthlyLeader.fromJson(Map<String, dynamic> json) => MonthlyLeader(
      id: json["_id"],
      first_name: json["client_id"]["first_name"],
      last_name: json["client_id"]["last_name"],
      total_fantasy_point: json["total_fantasy_point"],
      rank: json["rank"]
  );
}
