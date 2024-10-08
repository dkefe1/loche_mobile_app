abstract class FixtureEvent {}

class GetFixturesEvent extends FixtureEvent {
  final String round;
  GetFixturesEvent(this.round);
}

abstract class MatchInfoEvent {}

class GetMatchInfoEvent extends MatchInfoEvent {
  final String matchId;
  GetMatchInfoEvent(this.matchId);
}