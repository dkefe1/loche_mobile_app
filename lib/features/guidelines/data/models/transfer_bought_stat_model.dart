class TransferBoughtStatModel {
  final num bought;
  final String full_name;
  final String club;

  TransferBoughtStatModel(
      {
      required this.bought,
      required this.full_name,
      required this.club});

  factory TransferBoughtStatModel.fromJson(Map<String, dynamic> json) =>
      TransferBoughtStatModel(
          bought: json["bought"],
          full_name: json["player_info"]["bought_player"],
          club: json["player_info"]["club"]);
}
