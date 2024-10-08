import 'package:fantasy/features/leaderboard/data/models/leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/my_rank.dart';
import 'package:fantasy/features/leaderboard/data/models/winner.dart';

class YearlyLeaderboard{
  final List<Winner> yearlyWinners;
  final List<Leaderboard> yearlyLeaderboard;
  final MyRank? myRank;

  YearlyLeaderboard({required this.yearlyWinners, required this.yearlyLeaderboard, required this.myRank});
}