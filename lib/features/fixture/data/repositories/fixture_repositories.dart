import 'package:fantasy/features/fixture/data/datasource/fixture_remote_datasource.dart';
import 'package:fantasy/features/fixture/data/models/fixtures.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/fixture/data/models/match_event.dart';
import 'package:fantasy/features/fixture/data/models/match_info.dart';

class FixtureRepositories {
  FixtureRemoteDataSource fixtureRemoteDataSource;
  FixtureRepositories(this.fixtureRemoteDataSource);

  Future<Fixtures> getMatches(String round) async {
    try{
      final matches = fixtureRemoteDataSource.getMatch(round);
      return matches;
    } catch(e){
      throw e;
    }
  }

  Future<MatchEvent> getMatchInfo(String matchId) async {
    try{
      final matchInfos = fixtureRemoteDataSource.getMatchInfo(matchId);
      return matchInfos;
    } catch(e){
      throw e;
    }
  }
}