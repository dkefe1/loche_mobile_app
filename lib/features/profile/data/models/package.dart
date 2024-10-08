class PackageModel {
  final String id;
  final num price;
  final num game_weeks;
  final num total_amount;
  final num discount;
  final num discounted_total_amount;
  final bool is_active;

  PackageModel(
      {required this.id,
      required this.price,
      required this.game_weeks,
      required this.total_amount,
      required this.discount,
      required this.discounted_total_amount,
      required this.is_active});

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
      id: json["_id"],
      price: json["price"],
      game_weeks: json["game_weeks"],
      total_amount: json["total_amount"],
      discount: json["discount"],
      discounted_total_amount: json["discounted_total_amount"],
      is_active: json["is_active"]);
}
