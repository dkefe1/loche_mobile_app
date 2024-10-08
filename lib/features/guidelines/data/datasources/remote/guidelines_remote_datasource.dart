import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/guidelines/data/models/about_us_model.dart';
import 'package:fantasy/features/guidelines/data/models/all_time_player_stat.dart';
import 'package:fantasy/features/guidelines/data/models/faq_model.dart';
import 'package:fantasy/features/guidelines/data/models/feedback_title_model.dart';
import 'package:fantasy/features/guidelines/data/models/final_poll.dart';
import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:fantasy/features/guidelines/data/models/most_selected_model.dart';
import 'package:fantasy/features/guidelines/data/models/player_selected_model.dart';
import 'package:fantasy/features/guidelines/data/models/player_stat.dart';
import 'package:fantasy/features/guidelines/data/models/poll_model.dart';
import 'package:fantasy/features/guidelines/data/models/privacy_model.dart';
import 'package:fantasy/features/guidelines/data/models/terms_model.dart';
import 'package:fantasy/features/guidelines/data/models/transfer_stat.dart';
import 'package:fantasy/features/guidelines/data/models/user_poll.dart';
import 'package:fantasy/features/guidelines/data/models/week_player_stat.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/data/models/stat.dart';
import 'package:http/http.dart' as http;

class GuidelinesRemoteDataSource {
  final prefs = PrefService();

  Future<List<FAQModel>> getAllFAQs() async {
    var headersList = {'Accept': '*/*', 'x-api-key': apiKey};
    var url = Uri.parse('${baseUrl}api/v1/faq');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List faqs = data["data"]["faqs"];
        List<FAQModel> finalFAQs =
            faqs.map((faq) => FAQModel.fromJson(faq)).toList();
        return finalFAQs;
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

  Future<List<TermsModel>> getAllTerms() async {
    var headersList = {'Accept': '*/*', 'x-api-key': apiKey};
    var url = Uri.parse('${baseUrl}api/v1/terms');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List terms = data["data"]["termsAndConditions"];
        List<TermsModel> finalTerms =
            terms.map((term) => TermsModel.fromJson(term)).toList();
        return finalTerms;
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

  Future<List<PrivacyModel>> getAllPolicies() async {
    var headersList = {'Accept': '*/*', 'x-api-key': apiKey};
    var url = Uri.parse('${baseUrl}api/v1/privacy?sort=createdAt');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List policies = data["data"]["privacy"];
        List<PrivacyModel> finalPolicy =
            policies.map((policy) => PrivacyModel.fromJson(policy)).toList();
        return finalPolicy;
      } else {
        print(resBody);
        if (data["no_client"] != null) {
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

  Future<List<FeedbackTitleModel>> getAllFeedbackTitles() async {
    var headersList = {'Accept': '*/*', 'x-api-key': apiKey};
    var url = Uri.parse('${baseUrl}api/v1/feedbacktitle');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List feedbackTitles = data["data"]["feedbackTitles"];
        List<FeedbackTitleModel> finalFeedbackTitles = feedbackTitles
            .map((title) => FeedbackTitleModel.fromJson(title))
            .toList();
        return finalFeedbackTitles;
      } else {
        print(resBody);
        if (data["no_client"] != null) {
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

  Future postFeedback(String title_id, String content) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/feedback');

    var body = {"title_id": title_id, "content": content};

    try {
      var res =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
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

  Future<List<AboutUsModel>> getAboutUs() async {
    var headersList = {'Accept': '*/*', 'x-api-key': apiKey};
    var url = Uri.parse('${baseUrl}api/v1/aboutus');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List aboutUs = data["data"]["aboutUs"];
        List<AboutUsModel> finalAboutUs =
            aboutUs.map((content) => AboutUsModel.fromJson(content)).toList();
        return finalAboutUs;
      } else {
        print(resBody);
        if (data["no_client"] != null) {
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

  Future<List<PlayerStat>> getPlayerStats(String gameWeekId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/playerstat/$gameWeekId/gameweek');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body.toString();

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESSS") {
        // print(data);
        List players = data["data"]["playerStat"]["players"];
        List<PlayerStat> finalPlayers =
            players.map((player) => PlayerStat.fromJson(player)).toList();
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
        List<GameWeek> finalGameWeeks =
            gameWeeks.map((gameWeek) => GameWeek.fromJson(gameWeek)).toList();

        finalGameWeeks.removeWhere((gameWeek) => !gameWeek.is_done);

        return finalGameWeeks;
      } else {
        print(resBody);
        if (data["no_client"] != null) {
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

  Future<WeeklyPlayerStat> getWeeklyPlayerStat(
      String gameWeekId, bool isAllTime) async {
    try {
      if (isAllTime) {
        List<PlayerStat> players = await getAllTimePlayerStat();
        List<GameWeek> gameWeeks = await getGameWeeks();

        gameWeeks.removeWhere((gameWeek) => !gameWeek.is_done);

        return WeeklyPlayerStat(players: players, gameWeeks: gameWeeks);
      } else {
        List<PlayerStat> players = [];
        List<GameWeek> gameWeeks = await getGameWeeks();

        gameWeeks.removeWhere((gameWeek) => !gameWeek.is_done);

        if (gameWeeks.isNotEmpty) {
          if (gameWeekId == "initial") {
            players = await getPlayerStats(gameWeeks[0].id);
          } else {
            players = await getPlayerStats(gameWeekId);
          }
        }

        WeeklyPlayerStat weeklyPlayerStat =
            WeeklyPlayerStat(players: players, gameWeeks: gameWeeks);
        return weeklyPlayerStat;
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

  Future<PlayerSelectedStat> getPlayerSelectedStat(String? gameWeekId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };

    var url;
    
    TransferStat? transferStat = null;

    if(gameWeekId == null) {
      url = Uri.parse('${baseUrl}api/v1/gameweekteam/selectionstat');
      transferStat = await getTransferStat();
    } else {
      url = Uri.parse('${baseUrl}api/v1/gameweekteam/$gameWeekId/selectionstat');
    }

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        return PlayerSelectedStat(mostSelectedPlayer: MostSelected.fromJson(data["data"]["stat"]["mostSelectedPlayer"]), mostCaptainedPlayer: MostSelected.fromJson(data["data"]["stat"]["mostCaptainedPlayer"]), mostViceCaptainedPlayer: MostSelected.fromJson(data["data"]["stat"]["mostViceCaptainedPlayer"]), transferStat: transferStat);
      } else {
        print(resBody);
        if (data["no_client"] != null) {
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

  Future<TransferStat> getTransferStat() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse('${baseUrl}api/v1/transferhistory/transfersstat');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        return TransferStat.fromJson(data["data"]["stat"]);
      } else {
        print(resBody);
        if (data["no_client"] != null) {
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

  Future<List<InjuryModel>> getInjuredPlayers(bool isLatest) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
    };
    var url = Uri.parse('${baseUrl}api/v1/injuriesban/all');
    if(isLatest){
      url = Uri.parse('${baseUrl}api/v1/injuriesban');
    }

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List injuredPlayers = data["data"]["injuriesBans"];
        List<InjuryModel> finalInjuredPlayers = injuredPlayers.map((injuredPlayer) => InjuryModel.fromJson(injuredPlayer)).toList();
        return finalInjuredPlayers;
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

  Future<FinalPoll> getPolls(String page) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
    };
    var url = Uri.parse('${baseUrl}api/v1/poll?page=$page');

    List<UserPoll> userPolls = await getUserPolls();

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        // print(data);
        List polls = data["data"]["polls"];
        List<PollModel> finalPolls = polls.map((poll) => PollModel.fromJson(poll)).toList();
        return FinalPoll(polls: finalPolls, participatedPolls: userPolls);
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

  Future patchPoll(String pol_id, String choice_id) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}api/v1/poll/pollresponse');

    var body = {"poll_id": pol_id, "choice_id": choice_id};

    try {
      var res =
      await http.patch(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
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

  Future<List<UserPoll>> getUserPolls() async {

    var token = await prefs.readToken();
    var clientId = await prefs.getClientId();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
    };
    var url = Uri.parse('${baseUrl}api/v1/poll/userpolls/$clientId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List polls = data["data"]["polls"];
        List<UserPoll> finalPolls = polls.map((poll) => UserPoll.fromJson(poll)).toList();
        return finalPolls;
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

}
