class Bank{
  final String id;
  final String name;
  final String swift;
  final num acct_length;
  num? is_mobilemoney;

  Bank({required this.id, required this.name, required this.acct_length, required this.swift, this.is_mobilemoney});

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(id: json["id"], name: json["name"], acct_length: json["acct_length"], swift: json["swift"], is_mobilemoney: json["is_mobilemoney"]);
}