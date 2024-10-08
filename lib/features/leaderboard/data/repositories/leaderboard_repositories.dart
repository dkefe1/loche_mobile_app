import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/leaderboard/data/datasources/leaderboard_datasources.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/weekly_leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/yearly_leaderboard.dart';

class LeaderboardRepositories{

  LeaderboardDatasource leaderboardDatasource;
  LeaderboardRepositories(this.leaderboardDatasource);

  Future<WeeklyLeaderboard> getWeeklyLeaderboard(String gameWeekId, String page) async {
    try {
      final leaderBoard = await leaderboardDatasource.getFinalWeeklyLeaderboard(gameWeekId, page);
      return leaderBoard;
    } catch (e) {
      throw e;
    }
  }

  Future<YearlyLeaderboard> getYearlyLeaderboard(String page) async {
    try {
      final leaderBoard = await leaderboardDatasource.getFinalYearlyLeaderboard(page);
      return leaderBoard;
    } catch (e) {
      throw e;
    }
  }

  Future<MonthlyLeaderboard> getMonthlyLeaderboard(String currentTime, String page) async {
    try {
      final leaderBoard = await leaderboardDatasource.getFinalMonthlyLeaderboard(currentTime, page);
      return leaderBoard;
    } catch (e) {
      throw e;
    }
  }

  Future<List<ClientPlayer>> getLeaderClientTeam(String gameWeekId, String clientId) async {
    try {
      final players = await leaderboardDatasource.getLeaderClientTeam(gameWeekId, clientId);
      return players;
    } catch (e) {
      throw e;
    }
  }

  Future<List<ClientPlayer>> getOtherClientTeam(String clientId) async {
    try {
      final players = await leaderboardDatasource.getOtherClientTeam(clientId);
      return players;
    } catch (e) {
      throw e;
    }
  }
}