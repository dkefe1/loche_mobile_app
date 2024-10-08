import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/leaderboard/data/models/leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leader.dart';
import 'package:fantasy/features/leaderboard/data/models/monthly_leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/my_rank.dart';
import 'package:fantasy/features/leaderboard/data/models/week_leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/weekly_leaderboard.dart';
import 'package:fantasy/features/leaderboard/data/models/winner.dart';
import 'package:fantasy/features/leaderboard/data/models/yearly_leaderboard.dart';
import 'package:http/http.dart' as http;

class LeaderboardDatasource {

  final prefs = PrefService();

  HomeRemoteDataSource homeRemoteDataSource = HomeRemoteDataSource();

  Future<List<Winner>> getWeeklyWinners(String gameWeekId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/winners/weekly/$gameWeekId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List weeklyLeaderBoard = data["data"]["weeklyWinners"];
        List<Winner> finalWeeklyLeaderBoard = weeklyLeaderBoard.map((content) =>
            Winner.fromJson(content)).toList();
        return finalWeeklyLeaderBoard;
      }
      else {
        // print(resBody);
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

  Future<List<Winner>> getMonthlyWinners(String currentTime) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/winners/monthly?month=$currentTime');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List monthlyLeaderBoard = data["data"]["monthlyWinners"];
        List<Winner> finalMonthlyLeaderBoard = monthlyLeaderBoard.map((content) =>
            Winner.fromJson(content)).toList();
        return finalMonthlyLeaderBoard;
      }
      else {
        // print(resBody);
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

  Future<List<Winner>> getYearlyWinners() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/winners/yearly');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List yearlyLeaderBoard = data["data"]["yearlyWinners"];
        List<Winner> finalWeeklyLeaderBoard = yearlyLeaderBoard.map((content) =>
            Winner.fromJson(content)).toList();
        return finalWeeklyLeaderBoard;
      }
      else {
        // print(resBody);
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
        print(data);
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

  Future<WeeklyLeaderboard> getFinalWeeklyLeaderboard(String gameWeekId, String page) async {

    try {

      List<Winner> weeklyWinners = [];
      WeekLeaderboard weeklyLeaderboard = WeekLeaderboard(weeklyLeaderboard: [], has_started: false);

      List<GameWeek> gameWeeks = await getGameWeeks();
      List<Advertisement> ads = await homeRemoteDataSource.getAds("rank_page");

      // gameWeeks.removeWhere((gameWeek) => !gameWeek.is_done);

      MyRank? myRank;

      if(gameWeeks.isNotEmpty){
        if(gameWeekId == "initial"){
          weeklyWinners = await getWeeklyWinners(gameWeeks[0].id);
          weeklyLeaderboard = await getWeeklyLeaders(gameWeeks[0].id, page);
          myRank = await getMyWeeklyRank(gameWeeks[0].id);
        } else {
          weeklyWinners = await getWeeklyWinners(gameWeekId);
          weeklyLeaderboard = await getWeeklyLeaders(gameWeekId, page);
          myRank = await getMyWeeklyRank(gameWeekId);
        }
      }

      WeeklyLeaderboard weeklyLeaderBoard = WeeklyLeaderboard(weeklyWinners: weeklyWinners, gameWeeks: gameWeeks, weeklyLeaderboard: weeklyLeaderboard.weeklyLeaderboard, myRank: myRank, hasStarted: weeklyLeaderboard.has_started, ads: ads);
      return weeklyLeaderBoard;

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

  Future<List<Leaderboard>> getYearlyLeaders(String page) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/yearlyleaderboard?page=$page');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List yearlyLeaderBoard = data["data"]["yearlyLeaderboard"];
        List<Leaderboard> finalWeeklyLeaderBoard = yearlyLeaderBoard.map((content) =>
            Leaderboard.fromJson(content)).toList();
        return finalWeeklyLeaderBoard;
      }
      else {
        // print(resBody);
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

  Future<WeekLeaderboard> getWeeklyLeaders(String gameWeekId, String page) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/weeklyleaderboard/$gameWeekId?page=$page');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List weeklyLeaderBoard = data["data"]["weeklyLeaderBoard"];
        List<Leaderboard> finalWeeklyLeaderBoard = weeklyLeaderBoard.map((content) =>
            Leaderboard.fromJson(content)).toList();

        bool hasStarted = data["data"]["has_started"];
        return WeekLeaderboard(weeklyLeaderboard: finalWeeklyLeaderBoard, has_started: hasStarted);
      }
      else {
        // print(resBody);
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

  Future<List<MonthlyLeader>> getMonthlyLeaders(String currentTime, String page) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/monthlyleaderboard?month=$currentTime&page=$page');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List monthlyLeaderBoard = data["data"]["monthlyLeaderbaord"];
        List<MonthlyLeader> finalMonthlyLeaderBoard = monthlyLeaderBoard.map((content) =>
            MonthlyLeader.fromJson(content)).toList();
        return finalMonthlyLeaderBoard;
      }
      else {
        // print(resBody);
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

  Future<YearlyLeaderboard> getFinalYearlyLeaderboard(String page) async {

    try {

      List<Winner> yearlyWinners = await getYearlyWinners();
      List<Leaderboard> yearlyLeaderboard = await getYearlyLeaders(page);

      MyRank? myYearlyRank = await getMyYearlyRank();

      YearlyLeaderboard yearlyLeaderBoard = YearlyLeaderboard(yearlyWinners: yearlyWinners, yearlyLeaderboard: yearlyLeaderboard, myRank: myYearlyRank);
      return yearlyLeaderBoard;

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

  Future<MonthlyLeaderboard> getFinalMonthlyLeaderboard(String currentTime, String page) async {

    try {

      List<Winner> monthlyWinners = await getMonthlyWinners(currentTime);
      List<MonthlyLeader> monthlyLeaders = await getMonthlyLeaders(currentTime, page);

      MyRank? myMonthlyRank = await getMyMonthlyRank(currentTime);

      MonthlyLeaderboard monthlyLeaderBoard = MonthlyLeaderboard(monthlyLeaderboard: monthlyLeaders, monthlyWinners: monthlyWinners, myRank: myMonthlyRank);
      return monthlyLeaderBoard;

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


  Future<List<ClientPlayer>> getLeaderClientTeam(String gameWeekId, String clientId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/$gameWeekId/$clientId/clientgameweek');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List players = data["data"]["gameWeekTeam"]["players"];
        List<ClientPlayer> finalPlayers = players.map((content) =>
            ClientPlayer.fromJson(content)).toList();
        return finalPlayers;
      }
      else {
        // print(resBody);
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

  Future<List<ClientPlayer>> getOtherClientTeam(String clientId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/team/$clientId/clientteam');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List players = data["data"]["team"]["players"];
        List<ClientPlayer> finalPlayers = players.map((content) =>
            ClientPlayer.fromJson(content)).toList();
        return finalPlayers;
      }
      else {
        // print(resBody);
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

  Future<MyRank?> getMyWeeklyRank(String gameWeekId) async {
    var token = await prefs.readToken();
    var clientId = await prefs.getClientId();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/weeklyrank/$gameWeekId/$clientId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {

        if(data["data"]["weeklyRank"] == null){
          return null;
        }

        final myRank = MyRank.fromJson(data["data"]["weeklyRank"][0]);
        return myRank;
      }
      else {
        // print(resBody);
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


  Future<MyRank?> getMyMonthlyRank(String currentTime) async {
    var token = await prefs.readToken();
    var clientId = await prefs.getClientId();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/monthlyrank/$clientId?month=$currentTime');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        if(data["data"]["monthlyRank"] == null){
          return null;
        }
        final myMonthlyRank = MyRank.fromJson(data["data"]["monthlyRank"][0]);
        return myMonthlyRank;
      }
      else {
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

  Future<MyRank?> getMyYearlyRank() async {
    var token = await prefs.readToken();
    var clientId = await prefs.getClientId();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/gameweekteam/yearlyrank/$clientId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        if(data["data"]["yearlyRank"] == null){
          return null;
        }
        final myYearlyRank = MyRank.fromJson(data["data"]["yearlyRank"][0]);
        return myYearlyRank;
      }
      else {
        // print(resBody);
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

}