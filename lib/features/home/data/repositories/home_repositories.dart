import 'package:fantasy/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:fantasy/features/home/data/models/ClientGameWeekTeam.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/app_update.dart';
import 'package:fantasy/features/home/data/models/client_team_model.dart';
import 'package:fantasy/features/home/data/models/coach.dart';
import 'package:fantasy/features/home/data/models/create_player_model.dart';
import 'package:fantasy/features/home/data/models/create_team_model.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/data/models/joined_client_game_week_team.dart';
import 'package:fantasy/features/home/data/models/joined_game_week_team.dart';
import 'package:fantasy/features/home/data/models/transfer_history.dart';
import 'package:fantasy/features/home/data/models/transfer_model.dart';
import 'package:fantasy/features/home/data/models/transfer_player.dart';
import 'package:fantasy/features/home/data/models/transfer_squad.dart';

class HomeRepositories {
  HomeRemoteDataSource homeRemoteDataSource;
  HomeRepositories(this.homeRemoteDataSource);

  Future<List<Advertisement>> getAds(String adPackage) async {
    try {
      final ads = await homeRemoteDataSource.getAds(adPackage);
      return ads;
    } catch (e) {
      throw e;
    }
  }

  Future<List<EntityPlayer>> getSquads() async {
    try {
      final squads = await homeRemoteDataSource.getSquads();
      return squads;
    } catch (e) {
      throw e;
    }
  }

  Future<TransferSquad> getTransferSquads() async {
    try {
      final squads = await homeRemoteDataSource.getTransferSquads();
      return squads;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Coach>> getCoaches() async {
    try {
      final coaches = await homeRemoteDataSource.getCoaches();
      return coaches;
    } catch (e) {
      throw e;
    }
  }

  Future createTeam(CreateTeamModel createTeamModel) async {
    try {
      await homeRemoteDataSource.createTeam(createTeamModel);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkTeamNameAvailability(String teamName) async {
    try {
      final isAvailable = await homeRemoteDataSource.checkTeamNameAvailability(teamName);
      return isAvailable;
    } catch (e) {
      throw e;
    }
  }

  Future<ClientTeam> getClientTeam() async {
    try {
      final team = await homeRemoteDataSource.getClientTeam();
      return team;
    } catch (e) {
      throw e;
    }
  }

  Future switchPlayers(String playerToBeIn, String playerToBeOut) async {
    try {
      await homeRemoteDataSource.switchPlayers(playerToBeIn, playerToBeOut);
    } catch (e) {
      throw e;
    }
  }

  Future transferPlayers(String playerToBeOut, TransferPlayerModel transferPlayerModel) async {
    try {
      await homeRemoteDataSource.transferPlayers(playerToBeOut, transferPlayerModel);
    } catch (e) {
      throw e;
    }
  }

  Future swapPlayers(String playerToBeIn, String playerToBeOut) async {
    try {
      await homeRemoteDataSource.swapPlayers(playerToBeIn, playerToBeOut);
    } catch (e) {
      throw e;
    }
  }

  Future<List<GameWeek>> getGameWeeks() async {
    try {
      final gameWeeks = await homeRemoteDataSource.getGameWeeks();
      return gameWeeks;
    } catch (e) {
      throw e;
    }
  }

  Future<JoinedGameWeekTeam> getJoinedGameWeekTeam() async {
    try {
      final joinedGameWeekTeam = await homeRemoteDataSource.getJoinedGameWeekTeam();
      return joinedGameWeekTeam;
    } catch (e) {
      throw e;
    }
  }

  Future joinGameWeekTeam(String cid) async {
    try {
      await homeRemoteDataSource.joinGameWeekTeam(cid);
    } catch (e) {
      throw e;
    }
  }

  Future<List<TransferHistory>> getTransferHistory(String page) async {
    try {
      final transferHistory = await homeRemoteDataSource.getTransferHistory(page);
      return transferHistory;
    } catch (e) {
      throw e;
    }
  }

  Future<List<ClientGameWeekTeam>> getJoinedGameWeeks() async {
    try {
      final gameWeeks = await homeRemoteDataSource.getJoinedGameWeeks();
      return gameWeeks;
    } catch (e) {
      throw e;
    }
  }

  Future<AppUpdate?> getAppVersion(String platformType) async {
    try {
      final appVersion = await homeRemoteDataSource.getAppVersion(platformType);
      return appVersion;
    } catch (e) {
      throw e;
    }
  }

  Future<GameWeek?> getActiveGameWeek() async{
    try {
      final activeGameWeek = await homeRemoteDataSource.getActiveGameWeek();
      return activeGameWeek;
    } catch (e) {
      throw e;
    }
  }

  Future<TransferModel> getTransferModel() async{
    try {
      final transferModel = await homeRemoteDataSource.getTransferModel();
      return transferModel;
    } catch (e) {
      throw e;
    }
  }

  Future<Coach> getCoach(String coachId, bool useLocal) async{
    try {
      final coach = await homeRemoteDataSource.getCoachById(coachId, useLocal);
      return coach;
    } catch (e) {
      throw e;
    }
  }

  Future<JoinedClientGameWeekTeam> getJoinedClientGameWeek(String gameWeekId) async{
    try {
      final team = await homeRemoteDataSource.getJoinedClientGameWeek(gameWeekId);
      return team;
    } catch (e) {
      throw e;
    }
  }

  Future patchTeam(String favorite_coach, String favorite_tactic, String teamId) async{
    try {
      await homeRemoteDataSource.patchTeam(favorite_coach, favorite_tactic, teamId);
    } catch (e) {
      throw e;
    }
  }

  Future resetTeam() async{
    try {
      await homeRemoteDataSource.resetTeam();
    } catch (e) {
      throw e;
    }
  }

  Future recreateTeam(List<CreatePlayerModel> players) async {
    try {
      await homeRemoteDataSource.recreateTeam(players);
    } catch (e) {
      throw e;
    }
  }
}