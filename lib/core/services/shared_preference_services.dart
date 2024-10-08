import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future login(String password) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("password", password);
  }

  Future readLogin() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cache = _preferences.getString("password");
    return cache;
  }

  Future signout() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove("password");
    await removeCoach();
  }

  Future storeToken(String token) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("token", token);
  }

  Future readToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cache = _preferences.getString("token");
    return cache;
  }

  Future removeToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove("token");
  }

  Future board() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("boarded", "boarded");
  }

  Future getBoarded() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cache = _preferences.getString("boarded");
    return cache;
  }

  Future setClientId(String id) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("clientID", id);
  }

  Future getClientId() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cache = _preferences.getString("clientID");
    return cache;
  }

  Future createTeam(String teamName) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("teamName", teamName);
  }

  Future readCreatedTeam() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cache = _preferences.getString("teamName");
    return cache;
  }

  Future removeCreatedTeam() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove("teamName");
  }

  Future createCoach(String coach) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("coach", coach);
  }

  Future readCoach() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cache = _preferences.getString("coach");
    return cache;
  }

  Future removeCoach() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove("coach");
  }

  Future cleanPref() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.clear();
  }

  Future setLanguage(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("language", value);
  }

  Future getLanguage() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var language = _preferences.getString("language");
    return language;
  }

  Future setPhoneNumber(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("phoneNumber", value);
  }

  Future getPhoneNumber() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var phoneNumber = _preferences.getString("phoneNumber");
    return phoneNumber;
  }
}