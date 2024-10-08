class Profile {
  final String id;
  final String first_name;
  final String last_name;
  final String phone_number;
  final String birth_date;
  final num credit;
  final num commission_balance;
  final num earned_commission;
  final num earned_prize;
  final num prize_balance;
  final String full_name;
  final String agent_code;
  final bool has_team;
  String? pp_secure_url;
  final num? gameweek_package;

  Profile(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.phone_number,
      required this.birth_date,
      required this.credit,
      required this.commission_balance,
      required this.earned_commission,
      required this.earned_prize,
      required this.prize_balance,
      required this.full_name,
        required this.agent_code,
        required this.has_team,
      this.pp_secure_url, required this.gameweek_package});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json["id"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      phone_number: json["phone_number"],
      birth_date: json["birth_date"],
      credit: json["credit"],
      commission_balance: json["commission_balance"],
      earned_commission: json["earned_commission"],
      earned_prize: json["earned_prize"],
      prize_balance: json["prize_balance"],
      full_name: json["full_name"],
      agent_code: json["agent_code"],
      has_team: json["has_team"],
      pp_secure_url: json["pp_secure_url"], gameweek_package: json["gameweek_package"]);
}
