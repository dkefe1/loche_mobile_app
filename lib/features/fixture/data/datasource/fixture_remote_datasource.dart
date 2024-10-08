import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/fixture/data/models/fixtures.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/fixture/data/models/match_event.dart';
import 'package:fantasy/features/fixture/data/models/match_info.dart';
import 'package:fantasy/features/fixture/data/models/match_stat.dart';
import 'package:fantasy/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:http/http.dart' as http;

class FixtureRemoteDataSource {

  final prefs = PrefService();
  HomeRemoteDataSource homeRemoteDataSource = HomeRemoteDataSource();

  Future<Fixtures> getMatch(String round) async {

    List<Advertisement> ads = await homeRemoteDataSource.getAds("fixture_page");

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

      return Fixtures(matches: filteredMatches, ads: ads);
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
        GameWeek? gameWeek = data["data"]["gameWeek"] == null ? null : GameWeek.fromJson(data["data"]["gameWeek"]);
        return gameWeek;
      }
      else {
        if(data["no_client"] != null){
          throw doesNotExist;
        }
        print(resBody);
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

  Future<MatchEvent> getMatchInfo(String matchId) async {
    var headersList = {
      'Accept': '*/*'
    };
    var url = Uri.parse('${entityBaseUrl}matches/$matchId/info?token=$entityToken');

    List<MatchStat> matchStat = await getMatchStat(matchId);

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "ok") {
        List matchInfos = data["response"]["items"]["event"];
        List<MatchInfo> finalMatchInfo = matchInfos.map((matchInfo) => MatchInfo.fromJson(matchInfo)).toList();
        return MatchEvent(matchInfo: finalMatchInfo, matchStat: matchStat);
      }
      else {
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

  Future<List<MatchStat>> getMatchStat(String matchId) async {
    var headersList = {
      'Accept': '*/*'
    };
    var url = Uri.parse('${entityBaseUrl}matches/$matchId/statsv2?token=$entityToken');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "ok") {
        List matchStats = data["response"]["items"]["statistics"];
        List<MatchStat> finalMatchStat = matchStats.map((matchStat) => MatchStat.fromJson(matchStat)).toList();
        return finalMatchStat;
      }
      else {
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