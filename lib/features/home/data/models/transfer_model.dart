import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';

class TransferModel{
  final GameWeek? activeGameWeek;
  final List<MatchModel> matches;

  TransferModel({required this.activeGameWeek, required this.matches});
}