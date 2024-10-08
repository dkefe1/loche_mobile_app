import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/profile/data/models/agent_code.dart';
import 'package:fantasy/features/profile/data/models/agent_transaction.dart';
import 'package:fantasy/features/profile/data/models/agents.dart';
import 'package:fantasy/features/profile/data/models/awards.dart';
import 'package:fantasy/features/profile/data/models/bank.dart';
import 'package:fantasy/features/profile/data/models/client_request.dart';
import 'package:fantasy/features/profile/data/models/notes.dart';
import 'package:fantasy/features/profile/data/models/package.dart';
import 'package:fantasy/features/profile/data/models/profile.dart';
import 'package:fantasy/features/profile/data/models/profile_section.dart';
import 'package:fantasy/features/profile/data/models/scout.dart';
import 'package:fantasy/features/profile/data/models/transaction_history.dart';
import 'package:fantasy/features/profile/data/models/update_pin.dart';
import 'package:fantasy/features/profile/data/models/update_profile.dart';
import 'package:fantasy/features/profile/data/models/withdraw.dart';
import 'package:http/http.dart' as http;

class ProfileRemoteDataSource {

  final prefs = PrefService();

  HomeRemoteDataSource homeRemoteDataSource = HomeRemoteDataSource();

  Future<ProfileSection> getProfile() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/profile');

    try {

      List<Advertisement> ads = await homeRemoteDataSource.getAds("profile_page");

      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        return ProfileSection(profile: Profile.fromJson(data["data"]["client"]), ads: ads);
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

  Future updateProfile(UpdateProfile updateProfile) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/profile');

    var body = {
      "first_name": updateProfile.first_name,
      "last_name" : updateProfile.last_name,
      "phone_number" : updateProfile.phone_number,
      "birth_date": updateProfile.birth_date
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

  Future patchPin(UpdatePin updatePin) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/pin');

    var body = {
      "current_pin": updatePin.current_pin,
      "pin" : updatePin.pin,
      "pin_confirm" : updatePin.pin_confirm
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

  Future patchProPic(String id, String imageUrl) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/profilepicture');

    var body = {
      "pp_secure_url": imageUrl,
      "pp_public_id" : id
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

  Future<List<Notes>> getNotes() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/notes');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List notes = data["data"]["clientNotes"];
        List<Notes> finalNotes = notes.map((note) => Notes.fromJson(note)).toList();
        return finalNotes;
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

  Future postNote(String note) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/notes');

    var body = {
      "note": note
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

  Future patchNote(String id, String note) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/notes/$id');

    var body = {
      "note": note
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

  Future deleteNote(String id) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/notes/$id');

    try {
      var res = await http.delete(url, headers: headersList);
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

  Future deleteAllNote() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/notes');

    try {
      var res = await http.delete(url, headers: headersList);
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

  Future<List<Scout>> getScouts() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/scout');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List scouts = data["data"]["players"];
        List<Scout> finalScouts = scouts.map((scout) => Scout.fromJson(scout)).toList();
        return finalScouts;
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

  Future postScout(Scout scout) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/scout');

    var body = {
      "playerId": scout.player_id,
      "player_name": scout.player_name,
      "position": scout.position,
      "team": scout.team,
      "club_logo": scout.club_logo,
      "player_number": scout.player_number
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

  Future deleteScout(String id) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/scout/$id');

    try {
      var res = await http.delete(url, headers: headersList);
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

  Future requestAgentCode(AgentCode agentCode) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/agentrequest');

    var body = {
      "facebook_link":agentCode.facebook_link,
      "tiktok_link":agentCode.tiktok_link,
      "instagram_link":agentCode.instagram_link,
      "current_job":agentCode.current_job,
      "user_traction":agentCode.user_traction
    };

    var filteredBody = body..removeWhere((key, value) => value == "");

    try {
      var res = await http.post(url, headers: headersList, body: json.encode(filteredBody));
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

  Future<ClientRequest?> getClientRequest() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/agentrequest/getclientrequest');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        if(data["data"]["clientRequest"] == null) {
          return null;
        }
        return ClientRequest.fromJson(data["data"]["clientRequest"]);
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

  Future<String> depositCredit(num amount, String phoneNumber, bool autoJoin, bool isPackage, num? gameweeks) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/credit/pay');

    var body = {};

    if(phoneNumber.isEmpty){
      body = {
        "amount": amount,
        "auto_join": autoJoin,
        "is_package": isPackage,
        "gameweeks": gameweeks??0
      };
    } else {
      body = {
        "amount": amount,
        "phone_number": phoneNumber,
        "auto_join": autoJoin,
        "is_package": isPackage,
        "gameweeks": gameweeks??0
      };
    }

    try {
      var res = await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
        String checkout_url = data["checkout_url"];
        return checkout_url;
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

  Future<List<TransactionHistory>> getTransactions(String page) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/transaction/?page=$page');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List transactions = data["data"]["transactions"];
        List<TransactionHistory> finalTransactions = transactions.map((transaction) => TransactionHistory.fromJson(transaction)).toList();
        return finalTransactions;
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

  Future<List<AgentTransaction>> getAgentTransactions(String page, String clientId) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/commission/agentcommissions/$clientId/?page=$page');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List transactions = data["data"]["commissions"];
        List<AgentTransaction> finalTransactions = transactions.map((transaction) => AgentTransaction.fromJson(transaction)).toList();
        return finalTransactions;
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

  Future withdraw(Withdraw withdraw) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/credit/withdrawal');

    var body = {};

    if(withdraw.bank_code == null){
      body = {
        "amount": withdraw.amount,
        "toBankOrCredit" : withdraw.toBankOrCredit,
        "fromPrizeOrCommission" : withdraw.fromPrizeOrCommission
      };
    } else {
      body = {
        "amount": withdraw.amount,
        "account_number" : withdraw.account_number,
        "bank_code" : withdraw.bank_code,
        "account_name" : withdraw.account_name,
        "toBankOrCredit" : withdraw.toBankOrCredit,
        "fromPrizeOrCommission" : withdraw.fromPrizeOrCommission
      };
    }

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


  Future<List<Bank>> getBanks() async {

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $CHAPA_SECRET_KEY'
    };
    var url = Uri.parse('https://api.chapa.co/v1/banks');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (res.statusCode == 200) {
        print(data);
        List banks = data["data"];
        List<Bank> finalBanks = banks.map((bank) => Bank.fromJson(bank)).toList();
        return finalBanks;
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

  Future<List<Awards>> getAwards(String clientId) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
    };
    var url = Uri.parse('${baseUrl}api/v1/winners/clientawards/$clientId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        List awards = data["data"]["clientAwards"];
        List<Awards> finalAwards = awards.map((award) => Awards.fromJson(award)).toList();
        return finalAwards;
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

  Future transferCredit(num amount, String phoneNumber) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/credit/transfer');

    var body = {
      "amount": amount,
      "to": phoneNumber
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

  Future<List<Agents>> getAgents(String clientId, String page) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/commission/agentcommissions/$clientId?page=$page');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List agents = data["data"]["commissions"];
        List<Agents> finalAgents = agents.map((agent) => Agents.fromJson(agent)).toList();
        return finalAgents;
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

  Future<List<PackageModel>> getPackages() async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse('${baseUrl}api/v1/packages/active');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        List packages = data["data"]["packages"];
        List<PackageModel> finalPackages = packages.map((agent) => PackageModel.fromJson(agent)).toList();
        return finalPackages;
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

  Future buyPackageWithCredit(num amount, num gameweeks) async {

    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/creditpackage');

    var body = {
      "amount": amount,
      "gameweeks": gameweeks
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

}