import 'package:fantasy/features/guidelines/data/models/transfer_bought_stat_model.dart';
import 'package:fantasy/features/guidelines/data/models/transfer_sold_stat_model.dart';

class TransferStat {
  final TransferBoughtStatModel boughtStat;
  final TransferSoldStatModel soldStat;
  final num transfers;

  TransferStat(
      {required this.boughtStat,
      required this.soldStat,
      required this.transfers});

  factory TransferStat.fromJson(Map<String, dynamic> json) => TransferStat(
      boughtStat: TransferBoughtStatModel.fromJson(json["boughtStat"]),
      soldStat: TransferSoldStatModel.fromJson(json["soldStat"]),
      transfers: json["transfers"]);
}
