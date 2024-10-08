import 'package:fantasy/features/guidelines/data/models/most_selected_model.dart';
import 'package:fantasy/features/guidelines/data/models/transfer_stat.dart';

class PlayerSelectedStat {
  final MostSelected mostSelectedPlayer;
  final MostSelected mostCaptainedPlayer;
  final MostSelected mostViceCaptainedPlayer;
  final TransferStat? transferStat;

  PlayerSelectedStat(
      {required this.mostSelectedPlayer,
      required this.mostCaptainedPlayer,
      required this.mostViceCaptainedPlayer, this.transferStat});

  factory PlayerSelectedStat.fromJson(Map<String, dynamic> json) =>
      PlayerSelectedStat(
          mostSelectedPlayer: MostSelected.fromJson(json["mostSelectedPlayer"]),
          mostCaptainedPlayer: MostSelected.fromJson(json["mostCaptainedPlayer"]),
          mostViceCaptainedPlayer: MostSelected.fromJson(json["mostViceCaptainedPlayer"]));
}
