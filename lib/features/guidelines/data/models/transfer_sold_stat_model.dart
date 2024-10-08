class TransferSoldStatModel {
  final num sold;
  final String full_name;
  final String club;

  TransferSoldStatModel(
      {
      required this.sold,
      required this.full_name,
      required this.club});

  factory TransferSoldStatModel.fromJson(Map<String, dynamic> json) =>
      TransferSoldStatModel(
          sold: json["sold"],
          full_name: json["player_info"]["sold_player"],
          club: json["player_info"]["club"]);
}
