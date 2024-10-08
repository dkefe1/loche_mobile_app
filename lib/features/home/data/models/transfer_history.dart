import 'package:fantasy/features/home/data/models/transfer_history_players.dart';

class TransferHistory {
  final TransferHistoryPlayers bought_player;
  final TransferHistoryPlayers sold_player;
  final String id;
  final String createdAt;
  final String updatedAt;

  TransferHistory({required this.bought_player,
    required this.sold_player,
    required this.id,
    required this.createdAt,
    required this.updatedAt});

  factory TransferHistory.fromJson(Map<String, dynamic> json) =>
      TransferHistory(bought_player: TransferHistoryPlayers.fromJson(json["bought_player"]),
          sold_player: TransferHistoryPlayers.fromJson(json["sold_player"]),
          id: json["id"],
          createdAt: json["createdAt"],
          updatedAt: json["updatedAt"]);
}
