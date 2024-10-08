class CreatePlayerModel {
  final String pid;
  final String full_name;
  final num price;
  final String position;
  final String club;
  final String club_logo;
  bool? is_bench;
  bool? is_captain;
  bool? is_vice_captain;

  CreatePlayerModel(
      {required this.pid,
      required this.full_name,
      required this.price,
      required this.position,
      required this.club,
      required this.club_logo,
      this.is_bench,
      this.is_captain,
      this.is_vice_captain});

  factory CreatePlayerModel.fromJson(Map<String, dynamic> json) =>
      CreatePlayerModel(
          pid: json["pid"],
          full_name: json["full_name"],
          price: json["price"],
          position: json["position"],
          club: json["club"],
          club_logo: json["club_logo"],
          is_bench: json["is_bench"],
          is_captain: json["is_captain"],
          is_vice_captain: json["is_vice_captain"]);

  Map<String, dynamic> toJson() => {
    "pid" : pid,
    "full_name" : full_name,
    "price" : price,
    "position" : position,
    "club" : club,
    "club_logo" : club_logo,
    "is_bench" : is_bench,
    "is_captain" : is_captain,
    "is_vice_captain" : is_vice_captain,
  };
}
