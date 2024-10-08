import 'package:fantasy/features/guidelines/data/models/player_stat.dart';

class EntityPlayer{
  final String pid;
  final String full_name;
  final String price;
  final String position;
  final String clubAbbr;
  final String club_logo;
  final String clubName;
  bool isCaptain;
  bool isViceCaptain;
  bool isBench;
  final bool transfer_radar;
  final bool is_injuried;
  final bool is_banned;
  num point;

  EntityPlayer({required this.pid, required this.full_name, required this.price, required this.position, required this.clubAbbr, required this.club_logo, required this.clubName,
    this.isCaptain = false,
    this.isViceCaptain = false, this.isBench = false, required this.transfer_radar, required this.is_injuried, required this.is_banned, this.point = 0});

  Map<String, dynamic> toJson() => {
    "pid" : pid,
    "price" : num.parse(price),
    "position" : position,
    "club" : clubAbbr,
    "club_logo" : club_logo,
    "is_bench" : isBench,
    "is_captain" : isCaptain,
    "is_vice_captain" : isViceCaptain,
  };

}