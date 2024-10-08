import 'package:fantasy/features/fixture/data/models/fixtures.dart';
import 'package:fantasy/features/fixture/data/models/match_event.dart';

abstract class FixtureState {}

class GetFixtureInitialState extends FixtureState {}

class GetFixtureLoadingState extends FixtureState {}

class GetFixtureSuccessfulState extends FixtureState {
  final Fixtures matches;
  GetFixtureSuccessfulState(this.matches);
}

class GetFixtureFailedState extends FixtureState {
  final String error;
  GetFixtureFailedState(this.error);
}

abstract class MatchInfoState {}

class GetMatchInfoInitialState extends MatchInfoState {}

class GetMatchInfoLoadingState extends MatchInfoState {}

class GetMatchInfoSuccessfulState extends MatchInfoState {
  final MatchEvent matchInfo;
  GetMatchInfoSuccessfulState(this.matchInfo);
}

class GetMatchInfoFailedState extends MatchInfoState {
  final String error;
  GetMatchInfoFailedState(this.error);
}