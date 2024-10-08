import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/weekly_leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/yearly_leaderboard.dart';

abstract class WeeklyLeaderboardState {}

class GetWeeklyLeaderboardInitialState extends WeeklyLeaderboardState {}

class GetWeeklyLeaderboardSuccessfulState extends WeeklyLeaderboardState {
  final WeeklyLeaderboard leaderboard;
  GetWeeklyLeaderboardSuccessfulState(this.leaderboard);
}

class GetWeeklyLeaderboardFailedState extends WeeklyLeaderboardState {
  final String error;
  GetWeeklyLeaderboardFailedState(this.error);
}

class GetWeeklyLeaderboardLoadingState extends WeeklyLeaderboardState {}

abstract class YearlyLeaderboardState {}

class GetYearlyLeaderboardInitialState extends YearlyLeaderboardState {}

class GetYearlyLeaderboardSuccessfulState extends YearlyLeaderboardState {
  final YearlyLeaderboard leaderboard;
  GetYearlyLeaderboardSuccessfulState(this.leaderboard);
}

class GetYearlyLeaderboardFailedState extends YearlyLeaderboardState {
  final String error;
  GetYearlyLeaderboardFailedState(this.error);
}

class GetYearlyLeaderboardLoadingState extends YearlyLeaderboardState {}

abstract class MonthlyLeaderboardState {}

class GetMonthlyLeaderboardInitialState extends MonthlyLeaderboardState {}

class GetMonthlyLeaderboardSuccessfulState extends MonthlyLeaderboardState {
  final MonthlyLeaderboard leaderboard;
  GetMonthlyLeaderboardSuccessfulState(this.leaderboard);
}

class GetMonthlyLeaderboardFailedState extends MonthlyLeaderboardState {
  final String error;
  GetMonthlyLeaderboardFailedState(this.error);
}

class GetMonthlyLeaderboardLoadingState extends MonthlyLeaderboardState {}

abstract class LeaderClientTeamState {}

class GetLeaderClientTeamInitialState extends LeaderClientTeamState {}

class GetLeaderClientTeamSuccessfulState extends LeaderClientTeamState {
  final List<ClientPlayer> players;
  GetLeaderClientTeamSuccessfulState(this.players);
}

class GetLeaderClientTeamFailedState extends LeaderClientTeamState {
  final String error;
  GetLeaderClientTeamFailedState(this.error);
}

class GetLeaderClientTeamLoadingState extends LeaderClientTeamState {}

abstract class OtherClientTeamState {}

class GetOtherClientTeamInitialState extends OtherClientTeamState {}

class GetOtherClientTeamSuccessfulState extends OtherClientTeamState {
  final List<ClientPlayer> players;
  GetOtherClientTeamSuccessfulState(this.players);
}

class GetOtherClientTeamFailedState extends OtherClientTeamState {
  final String error;
  GetOtherClientTeamFailedState(this.error);
}

class GetOtherClientTeamLoadingState extends OtherClientTeamState {}

