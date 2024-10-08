import 'dart:async';
import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signup/data/models/signup.dart';
import 'package:fantasy/features/auth/signup/data/models/verify_otp.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class SignUpDatasource {
  final pref = PrefService();

  Future signUp(SignUp signUp) async {
    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/sendotp');

    Map<String, dynamic> body;

    if(signUp.agent_code!.isEmpty){

      body = {
        "first_name": signUp.first_name,
        "last_name": signUp.last_name,
        "phone_number": signUp.phone_number,
        "birth_date": signUp.birth_date,
        "pin": signUp.pin,
        "pin_confirm": signUp.pin_confirm,
        "accept": signUp.accept
      };
    } else {

      body = {
        "first_name": signUp.first_name,
        "last_name": signUp.last_name,
        "phone_number": signUp.phone_number,
        "birth_date": signUp.birth_date,
        "pin": signUp.pin,
        "pin_confirm": signUp.pin_confirm,
        "accept": signUp.accept,
        "ref_agent_code": signUp.agent_code
      };
    }

    try {
      var res = await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(resBody);
      } else {
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

  Future verifyOtp(VerifyOtp verifyOtp) async {
    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${baseUrl}api/v1/client/verifyotp');

    var body = {"phone_number": verifyOtp.phone_number, "otp": verifyOtp.otp};

    var res = await http.post(url, headers: headersList, body: json.encode(body));
    final resBody = res.body;
    final data = json.decode(resBody);

    try {
      if (data["status"] == "SUCCESS") {
        print(resBody);
        await pref.storeToken(data["token"]);
        await pref.setClientId(data["data"]["client"]["id"]);
      } else {
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

  Future<bool> checkCodeAgentAvailability(String codeAgent) async {

    var headersList = {
      'Accept': '*/*',
      'x-api-key': apiKey,
    };
    var url = Uri.parse('${baseUrl}api/v1/client/$codeAgent/agent');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (data["status"] == "SUCCESS") {
        print(data);
        bool isAvailable = data["data"]["is_agent"];
        return isAvailable;
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
