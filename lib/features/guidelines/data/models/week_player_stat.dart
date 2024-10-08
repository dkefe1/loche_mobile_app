import 'package:fantasy/features/guidelines/data/models/player_stat.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';

class WeeklyPlayerStat{
  final List<PlayerStat> players;
  final List<GameWeek> gameWeeks;

  WeeklyPlayerStat({required this.players, required this.gameWeeks});
}