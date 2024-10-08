import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/guidelines/data/datasources/remote/guidelines_remote_datasource.dart';
import 'package:fantasy/features/guidelines/data/models/all_time_player_stat.dart';
import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:fantasy/features/guidelines/data/models/player_stat.dart';
import 'package:fantasy/features/home/data/models/ClientGameWeekTeam.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/app_update.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/client_team_model.dart';
import 'package:fantasy/features/home/data/models/coach.dart';
import 'package:fantasy/features/home/data/models/create_player_model.dart';
import 'package:fantasy/features/home/data/models/create_team_model.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/data/models/joined_client_game_week_team.dart';
import 'package:fantasy/features/home/data/models/joined_game_week_team.dart';
import 'package:fantasy/features/home/data/models/stat.dart';
import 'package:fantasy/features/home/data/models/transfer_history.dart';
import 'package:fantasy/features/home/data/models/transfer_model.dart';
import 'package:fantasy/features/home/data/models/transfer_player.dart';
import 'package:fantasy/features/home/data/models/transfer_squad.dart';
import 'package:http/http.dart' as http;

class HomeRemoteDataSource {

  final prefs = PrefService();
  final guidelinesRemoteDataSource = GuidelinesRemoteDataSource();

  Future<List<Advertisement>> getAds(String adPackage) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/advertisement?ad_package=$adPackage');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List ads = data["data"]["ads"];
        List<Advertisement> finalAds = ads.map((content) =>
            Advertisement.fromJson(content)).toList();
        return finalAds;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<List<EntityPlayer>> getSquads() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/fantasyroaster');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body.toString();

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List players = data["data"]["fantasyRoaster"][0]["players"];
        print(players[0]);
        List<EntityPlayer> finalPlayers = players.map((player) => EntityPlayer(pid: player["pid"], full_name: player["pname"], price: player["rating"], position: player["role"], clubAbbr: player["team"]["abbr"], club_logo: player["team"]["logo"], clubName: player["team"]["tname"], transfer_radar: player["transfer_radar"], is_injuried: player["is_injuried"], is_banned: player["is_banned"])).toList();
        return finalPlayers;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e)
    {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    }
    on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<TransferSquad> getTransferSquads() async {

    var token = await prefs.readToken();
    List<PlayerStat> allTimePlayerStat = await getAllTimePlayerStat();
    List<InjuryModel> injuredPlayers = await guidelinesRemoteDataSource.getInjuredPlayers(false);

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/fantasyroaster');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body.toString();

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List players = data["data"]["fantasyRoaster"][0]["players"];
        print(players[0]);
        List<EntityPlayer> finalPlayers = players.map((player) => EntityPlayer(pid: player["pid"], full_name: player["pname"], price: player["rating"], position: player["role"], clubAbbr: player["team"]["abbr"], club_logo: player["team"]["logo"], clubName: player["team"]["tname"], transfer_radar: player["transfer_radar"], is_injuried: player["is_injuried"], is_banned: player["is_banned"])).toList();
        List<EntityPlayer> allPlayers = [];
        for(int i = 0; i<finalPlayers.length; i++){
          PlayerStat? allTimeStat;
          for(int j=0; j<allTimePlayerStat.length; j++){
            if(allTimePlayerStat[j].id == finalPlayers[i].pid){
              allTimeStat = allTimePlayerStat[j];
              break;
            }
          }
          allPlayers.add(EntityPlayer(pid: finalPlayers[i].pid, full_name: finalPlayers[i].full_name, price: finalPlayers[i].price, position: finalPlayers[i].position, clubAbbr: finalPlayers[i].clubAbbr, club_logo: finalPlayers[i].club_logo, clubName: finalPlayers[i].clubName, transfer_radar: finalPlayers[i].transfer_radar, is_injuried: finalPlayers[i].is_injuried, is_banned: finalPlayers[i].is_banned, point: allTimeStat == null ? 0 : allTimeStat.fantasy_point));
        }
        return TransferSquad(players: allPlayers, injuredPlayers: injuredPlayers);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e)
    {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    }
    on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<List<Coach>> getCoaches() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/coach');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List coaches = data["data"]["coaches"];
        List<Coach> finalCoaches = coaches.map((coach) =>
            Coach.fromJson(coach)).toList();
        return finalCoaches;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<String> getCompetition() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/competitions');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        String competition = data["data"]["competetions"][0]["_id"];
        return competition;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future createTeam(CreateTeamModel createTeamModel) async {

    var token = await prefs.readToken();

    String competitionId = await getCompetition();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/team');

    Map<String, dynamic> teamJson = createTeamModel.toJson();
    print(teamJson);

    var body = {
      "competition": competitionId,
      "team_name": createTeamModel.team_name,
      "favorite_coach": createTeamModel.favorite_coach,
      "favorite_tactic": createTeamModel.favorite_tactic,
      "players" : teamJson["players"]
    };

    try {
      var res = await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<bool> checkTeamNameAvailability(String teamName) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/checkteamname/$teamName');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        bool isAvailable = data["is_name_available"];
        return isAvailable;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<ClientTeam> getClientTeam() async {

    var token = await prefs.readToken();

    ClientTeam? refreshedTeam = await getRefreshFantasyPoints();

    if(refreshedTeam == null){

      // List<Advertisement> ads = await getAds("home_page");
      JoinedGameWeekTeam joinedGameWeekTeam = await getJoinedGameWeekTeam();
      // List<MatchModel> matches = await getxMatch("null");

      var headersList = {
        'Accept': '*/*',
        'x-api-key': apiKey,
        'Authorization': 'Bearer $token'
      };
      var url = Uri.parse('${baseUrl}api/v1/team/clientteam');

      try {
        var res = await http.get(url, headers: headersList);
        final resBody = res.body;

        final data = json.decode(resBody);

        if (data["status"] == "SUCCESS") {
          // print(data);
          List players = data["data"]["team"]["players"];

          Map<String, dynamic> team = data["data"]["team"];

          // Coach coach = await getCoachById(team["favorite_coach"]);

          List<ClientPlayer> finalPlayers = players.map((player) =>
              ClientPlayer.fromJson(player)).toList();

          GameWeek? gameWeek = await getActiveGameWeek();

          num gameweek_fantasy_point = 0;
          for(int i=0; i<finalPlayers.length;i++){
            if(!finalPlayers[i].is_bench){
              gameweek_fantasy_point += finalPlayers[i].final_fantasy_point;
            }
          }

          ClientTeam clientTeam = ClientTeam(id: team["_id"], team_name: team["team_name"], favorite_coach: team["favorite_coach"], favorite_tactic: team["favorite_tactic"], competition: team["competition"], budget: team["budget"], players: finalPlayers, gameWeek: gameWeek, total_fantasy_point: team["total_fantasy_point"], gameweek_fantasy_point: gameweek_fantasy_point, joinedGameWeekTeam: joinedGameWeekTeam);

          return clientTeam;
        }
        else {
          if(data["no_client"] != null){
            throw doesNotExist;
          }
          print(resBody);
          throw data["message"];
        }
      } on TimeoutException catch (e) {
        print('Timeout Error: $e');
        throw timeoutErrorMessage;
      } on SocketException catch (e) {
        print('Socket Error: $e');
        throw socketErrorMessage;
      } on FormatException catch (e) {
        print('Format Error: $e');
        throw formatErrorMessage;
      } on http.ClientException catch (e) {
        print('Socket Error: $e');
        throw socketErrorMessage;
      } on Error catch (e) {
        throw e;
      }
    } else {
      return refreshedTeam;
    }
  }

  Future<TransferModel> getTransferModel() async {
    List<MatchModel> matches = await getMatch("null");
    GameWeek? activeGameWeek = await getActiveGameWeek();

    return TransferModel(activeGameWeek: activeGameWeek, matches: matches);
  }

  Future<Coach> getCoachById(String coachId, bool useLocal) async {
    var token = await prefs.readToken();

    String? value = await prefs.readCoach();
    if(value != null && useLocal){
      final data = json.decode(value);
      Coach coach = Coach.fromJson(data["data"]["coach"]);
      return coach;
    }

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/coach/$coachId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        prefs.createCoach(resBody);
        Coach coach = Coach.fromJson(data["data"]["coach"]);
        return coach;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future switchPlayers(String playerToBeIn, String playerToBeOut) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/switchplayers/$playerToBeOut');

    var body = {
      "pid": playerToBeIn
    };

    try {
      var res = await http.patch(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future transferPlayers(String playerToBeOut, TransferPlayerModel transferPlayerModel) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/transferplayer/$playerToBeOut');

    var body = {
      "pid": transferPlayerModel.pid,
      "full_name": transferPlayerModel.full_name,
      "price": transferPlayerModel.price,
      "position": transferPlayerModel.position,
      "club": transferPlayerModel.club,
      "club_logo": transferPlayerModel.club_logo
    };

    try {
      var res = await http.patch(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future swapPlayers(String playerToBeIn, String playerToBeOut) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/swapcaptains/$playerToBeOut');

    var body = {
      "pid": playerToBeIn
    };

    try {
      var res = await http.patch(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<List<GameWeek>> getGameWeeks() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweek');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List gameWeeks = data["data"]["gameWeeks"];
        List<GameWeek> finalGameWeeks = gameWeeks.map((gameWeek) =>
            GameWeek.fromJson(gameWeek)).toList();
        return finalGameWeeks;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<List<ClientGameWeekTeam>> getJoinedGameWeeks() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/joined');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List gameWeeks = data["data"]["clientGameWeeks"];
        List<ClientGameWeekTeam> finalGameWeeks = gameWeeks.map((gameWeek) =>
            ClientGameWeekTeam.fromJson(gameWeek)).toList();
        return finalGameWeeks;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<JoinedGameWeekTeam> getJoinedGameWeekTeam() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/joined/activegameweek');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        JoinedGameWeekTeam joinedGameWeekTeam = JoinedGameWeekTeam.fromJson(data["data"]);
        return joinedGameWeekTeam;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<GameWeek?> getActiveGameWeek() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweek/active');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        if(data["data"] == null){
          return null;
        }
        GameWeek? gameWeek = GameWeek.fromJson(data["data"]["gameWeek"]);
        return gameWeek;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future joinGameWeekTeam(String cid) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam');

    var body = {
      "cid": cid
    };

    try {
      var res = await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<List<TransferHistory>> getTransferHistory(String page) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/transferhistory/?page=$page');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List transferHistories = data["data"]["transferHistories"];
        List<TransferHistory> finalTransferHistories = transferHistories.map((content) =>
            TransferHistory.fromJson(content)).toList();
        return finalTransferHistories;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<AppUpdate?> getAppVersion(String platformType) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/appversion/latest?os=${platformType}');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        if(data["data"] == null){
          return null;
        }
        AppUpdate appUpdate = AppUpdate.fromJson(data["data"]["latestVersion"]);
        return appUpdate;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<ClientTeam?> getRefreshFantasyPoints() async {
    var token = await prefs.readToken();

    // List<MatchModel> matches = await getMatch("null");
    // List<Advertisement> ads = await getAds("home_page");
    JoinedGameWeekTeam joinedGameWeekTeam = await getJoinedGameWeekTeam();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/refresh');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        if(data["joinedActiveGameWeek"] == false){
          return null;
        } else {

          GameWeek? gameWeek = await getActiveGameWeek();

          List refreshedPlayers = data["data"]["players"];
          List<ClientPlayer> finalRefreshedPlayers = refreshedPlayers.map((content) =>
              ClientPlayer.fromJson(content)).toList();

          final team = data["data"]["team"];

          num gameweek_fantasy_point = 0;
          for(int i=0; i<finalRefreshedPlayers.length;i++){
            if(!finalRefreshedPlayers[i].is_bench){
              gameweek_fantasy_point += finalRefreshedPlayers[i].final_fantasy_point;
            }
          }

          ClientTeam? clientTeam = ClientTeam(id: team["_id"], team_name: team["team_name"], competition: team["competition"], favorite_coach: team["favorite_coach"], favorite_tactic: team["favorite_tactic"], budget: team["budget"], total_fantasy_point: team["total_fantasy_point"], gameweek_fantasy_point: gameweek_fantasy_point, players: finalRefreshedPlayers, gameWeek: gameWeek, joinedGameWeekTeam: joinedGameWeekTeam);
          return clientTeam;
        }
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<JoinedClientGameWeekTeam> getJoinedClientGameWeek(String gameWeekId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/gameweek/$gameWeekId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        JoinedClientGameWeekTeam finalGameWeek = JoinedClientGameWeekTeam.fromJson(data["data"]["gameWeek"]);
        return finalGameWeek;
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Erro r: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future patchTeam(String favorite_coach, String favorite_tactic, String teamId) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/$teamId/profile');

    var body = {
      "favorite_coach":favorite_coach,
      "favorite_tactic":favorite_tactic
    };

    try {
      var res = await http.patch(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future resetTeam() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/resetteam');

    try {
      var res = await http.patch(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future recreateTeam(List<CreatePlayerModel> players) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/recreateteam');

    var body = {
      "players" : List<dynamic>.from(players.map((player) => player.toJson()))
    };

    try {
      var res = await http.patch(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
        print(resBody);
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

  Future<List<MatchModel>> getMatch(String round) async {

    if(round == "null"){
      GameWeek? gameWeek = await getActiveGameWeek();
      print(gameWeek);
      round = gameWeek == null ? "1" : gameWeek.game_week;
    }

    var headersList = {
      'Accept': '*/*'
    };

    try {

      List<MatchModel> filteredMatches = [];

      for(int i = 0; i<2; i++){
        var url = Uri.parse('${entityBaseUrl}competition/992/matches?token=$entityToken&paged=${(int.parse(round) + i).toString()}');

        var res = await http.get(url, headers: headersList);
        final resBody = res.body;

        final data = json.decode(resBody);

        if (data["status"] == "ok") {
          List matches = data["response"]["items"];
          List<MatchModel> finalMatches = matches.map((match) => MatchModel.fromJson(match)).toList();
          filteredMatches.addAll(finalMatches);
        }
        else {
          throw data["message"];
        }
      }

      filteredMatches = filteredMatches.where((match) => match.round == round).toList();

      return filteredMatches;
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }

  }

  Future<List<PlayerStat>> getAllTimePlayerStat() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/playerstat/all');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body.toString();

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List players = data["data"]["playerStat"];
        List<AllTimePlayerStat> allTimePlayers = players
            .map((player) => AllTimePlayerStat.fromJson(player))
            .toList();
        List<PlayerStat> finalPlayers = [];
        for (int i = 0; i < allTimePlayers.length; i++) {
          finalPlayers.add(PlayerStat(
              pid: allTimePlayers[i].id,
              full_name: allTimePlayers[i].full_name,
              position: allTimePlayers[i].position,
              club: allTimePlayers[i].tname,
              fantasy_point: allTimePlayers[i].total_fantasy_point,
              minutesplayed: allTimePlayers[i].total_minutes_played,
              goalscored: allTimePlayers[i].total_goal_scored_point,
              assist: allTimePlayers[i].total_assist_point,
              passes: allTimePlayers[i].total_passes_point,
              shotsontarget: allTimePlayers[i].total_shots_on_target_point,
              cleansheet: allTimePlayers[i].total_cleansheet_point,
              shotssaved: allTimePlayers[i].total_shots_saved_point,
              penaltysaved: allTimePlayers[i].total_penalty_saved_point,
              tacklesuccessful: allTimePlayers[i].total_tacklesuccessful_point,
              yellowcard: allTimePlayers[i].total_yellowcard_point,
              redcard: allTimePlayers[i].total_redcard_point,
              owngoal: allTimePlayers[i].total_owngoal_point,
              goalsconceded: allTimePlayers[i].total_goalconceded_point,
              penaltymissed: allTimePlayers[i].total_penalty_missed_point,
              chancecreated: null,
              starting: null,
              substitute: null,
              interceptionwon: allTimePlayers[i].total_interception_won_point,
              id: allTimePlayers[i].id,
              stat: Stat(
                  minutesplayed: allTimePlayers[i].total_minutes_played,
                  goalscored: allTimePlayers[i].total_goal_scored,
                  assist: allTimePlayers[i].total_assist,
                  passes: allTimePlayers[i].total_passes,
                  shotsontarget: allTimePlayers[i].total_shots_on_target,
                  cleansheet: allTimePlayers[i].total_cleansheet,
                  shotssaved: allTimePlayers[i].total_shots_saved,
                  penaltysaved: allTimePlayers[i].total_penalty_saved,
                  tacklesuccessful: allTimePlayers[i].total_tacklesuccessful,
                  yellowcard: allTimePlayers[i].total_yellowcard,
                  redcard: allTimePlayers[i].total_redcard,
                  owngoal: allTimePlayers[i].total_owngoal,
                  goalsconceded: allTimePlayers[i].total_goalconceded,
                  penaltymissed: allTimePlayers[i].total_penalty_missed,
                  chancecreated: null,
                  starting11: null,
                  substitute: null,
                  blockedshot: null,
                  interceptionwon: allTimePlayers[i].total_interception_won,
                  clearance: null)));
        }

        return finalPlayers;
      } else {
        print(resBody);
        if (data["no_client"] != null) {
          throw doesNotExist;
        }
        throw data["message"];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      throw e;
    }
  }

}

