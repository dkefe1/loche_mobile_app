import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/leaderboard/data/models/leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/my_rank.dart';
import 'package:fantasy/features/leaderboard/data/models/winner.dart';

class WeeklyLeaderboard{
  final List<Winner> weeklyWinners;
  final List<GameWeek> gameWeeks;
  final List<Leaderboard> weeklyLeaderboard;
  final MyRank? myRank;
  final bool hasStarted;
  final List<Advertisement> ads;

  WeeklyLeaderboard({required this.weeklyWinners, required this.gameWeeks, required this.weeklyLeaderboard, required this.myRank, required this.hasStarted, required this.ads});
}