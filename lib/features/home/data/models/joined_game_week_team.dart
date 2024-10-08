import 'package:fantasy/features/home/data/models/ClientGameWeekTeam.dart';

class JoinedGameWeekTeam {
  final ClientGameWeekTeam? clientGameWeekTeam;
  final bool activeGameWeekAvailable;
  final bool deadlinePassed;
  final bool isGameWeekFree;
  final bool lowBalance;
  final bool no_package;

  JoinedGameWeekTeam(
      {required this.clientGameWeekTeam,
      required this.activeGameWeekAvailable,
      required this.deadlinePassed,
      required this.isGameWeekFree, required this.lowBalance, required this.no_package});

  factory JoinedGameWeekTeam.fromJson(Map<String, dynamic> json) =>
      JoinedGameWeekTeam(
          clientGameWeekTeam: json["clientGameWeekTeam"] == null ? null :
              ClientGameWeekTeam.fromJson(json["clientGameWeekTeam"]),
          activeGameWeekAvailable: json["activeGameWeekAvailable"],
          deadlinePassed: json["deadlinePassed"],
          isGameWeekFree: json["isGameWeekFree"],
          lowBalance: json["lowBalance"],
        no_package: json["no_package"],
      );
}
