class Agents {
  final String first_name;
  final String last_name;
  final String full_name;
  final num amount;

  Agents(
      {required this.first_name,
      required this.last_name,
      required this.full_name,
      required this.amount});

  factory Agents.fromJson(Map<String, dynamic> json) => Agents(
      first_name: json["client_id"]["first_name"],
      last_name: json["client_id"]["last_name"],
      full_name: json["client_id"]["full_name"],
      amount: json["amount"]);
}
