class TransferHistoryPlayers {
  final String full_name;
  final String club;
  final num price;

  TransferHistoryPlayers(
      {required this.full_name, required this.club, required this.price});

  factory TransferHistoryPlayers.fromJson(Map<String, dynamic> json) =>
      TransferHistoryPlayers(
          full_name: json["full_name"], club: json["club"], price: json["price"]);
}
