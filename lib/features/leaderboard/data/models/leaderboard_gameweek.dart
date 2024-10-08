import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/leaderboard/data/models/leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/winner.dart';

class LeaderboardGameWeek{
  final List<Winner> weeklyWinners;
  final List<Winner> yearlyWinners;
  final List<GameWeek> gameWeeks;
  final List<Leaderboard> weeklyLeaderboard;
  final List<Leaderboard> yearlyLeaderboard;

  LeaderboardGameWeek({required this.weeklyWinners, required this.yearlyWinners, required this.gameWeeks, required this.weeklyLeaderboard, required this.yearlyLeaderboard});
}