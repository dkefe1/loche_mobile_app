import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/coach.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/data/models/joined_game_week_team.dart';

class ClientTeam {
  final String id;
  final String competition;
  final String team_name;
  final String favorite_coach;
  final String favorite_tactic;
  final num budget;
  final num total_fantasy_point;
  final num gameweek_fantasy_point;
  final List<ClientPlayer> players;
  final GameWeek? gameWeek;
  // final List<Advertisement> ads;
  final JoinedGameWeekTeam joinedGameWeekTeam;
  // final List<MatchModel> matches;

  ClientTeam(
      {required this.id,
      required this.competition,
      required this.team_name,
      required this.favorite_coach,
      required this.favorite_tactic,
      required this.budget,
      required this.total_fantasy_point,
      required this.gameweek_fantasy_point,
      required this.players, required this.gameWeek, required this.joinedGameWeekTeam});
}
