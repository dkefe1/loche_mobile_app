abstract class WeeklyLeaderboardEvent {}

class GetWeeklyLeaderboardEvent extends WeeklyLeaderboardEvent {
  final String gameWeekId, page;
  GetWeeklyLeaderboardEvent(this.gameWeekId, this.page);
}

abstract class YearlyLeaderboardEvent {}

class GetYearlyLeaderboardEvent extends YearlyLeaderboardEvent {
  final String page;
  GetYearlyLeaderboardEvent(this.page);
}

abstract class MonthlyLeaderboardEvent {}

class GetMonthlyLeaderboardEvent extends MonthlyLeaderboardEvent {
  final String currentTime, page;
  GetMonthlyLeaderboardEvent(this.currentTime, this.page);
}

abstract class LeaderClientTeamEvent {}

class GetLeaderClientTeamEvent extends LeaderClientTeamEvent {
  final String gameWeekId, clientId;
  GetLeaderClientTeamEvent(this.gameWeekId, this.clientId);
}

abstract class OtherClientTeamEvent {}

class GetOtherClientTeamEvent extends OtherClientTeamEvent {
  final String clientId;
  GetOtherClientTeamEvent(this.clientId);
}