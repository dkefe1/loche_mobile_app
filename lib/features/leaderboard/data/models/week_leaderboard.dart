import 'package:fantasy/features/leaderboard/data/models/leaderboard.dart';

class WeekLeaderboard{
  final List<Leaderboard> weeklyLeaderboard;
  final bool has_started;

  WeekLeaderboard({required this.weeklyLeaderboard, required this.has_started});
}