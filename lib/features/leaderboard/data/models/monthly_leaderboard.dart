import 'package:fantasy/features/leaderboard/data/models/monthly_leader.dart';
import 'package:fantasy/features/leaderboard/data/models/my_rank.dart';
import 'package:fantasy/features/leaderboard/data/models/winner.dart';

class MonthlyLeaderboard{
  final List<Winner> monthlyWinners;
  final List<MonthlyLeader> monthlyLeaderboard;
  final MyRank? myRank;

  MonthlyLeaderboard({required this.monthlyLeaderboard, required this.monthlyWinners, required this.myRank});
}