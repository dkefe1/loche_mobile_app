class ClientId {
  final String id;
  final String full_name;
  final String first_name;
  final String last_name;

  ClientId(
      {required this.id,
      required this.full_name,
      required this.first_name,
      required this.last_name});

  factory ClientId.fromJson(Map<String, dynamic> json) => ClientId(
      id: json["id"],
      full_name: json["full_name"],
      first_name: json["first_name"],
      last_name: json["last_name"]);
}
