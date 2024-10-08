import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/data/models/signin.dart';
import 'package:http/http.dart' as http;

class SignInRemoteDataSource {

  final pref = PrefService();

  Future<bool> loginClient(SignIn login) async {
    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/login');

    var body = {
      "phone_number":login.phone_number,
      "pin":login.pin
    };

    try {
      var res = await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
        await pref.storeToken(data["token"]);
        await pref.setClientId(data["data"]["client"]["id"]);
        bool hasTeam = data["data"]["client"]["has_team"];
        return hasTeam;
      }
      else {
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
  }

  Future forgotPin(String phone_number) async {
    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/forgot');

    var body = {
      "phone_number":phone_number
    };

    try{
      var res = await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      }
      else {
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
  }

  Future verifyPin(String pin, String phone_number) async {
    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/verifypinresetotp');

    var body = {
      "otp":pin,
      "phone_number":phone_number
    };

    try {
      var res = await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
        final client_id = data["data"]["client"]["_id"];
        return client_id;
      }
      else {
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
  }

  Future resetPin(String pin, String pin_confirm, String phone_number) async {
    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/resetpin');

    var body = {
      "pin":pin,
      "pin_confirm":pin_confirm,
      "phone_number":phone_number
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