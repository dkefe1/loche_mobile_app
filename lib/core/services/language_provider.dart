import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale lang = Locale('en');
  bool isEnglish = true;

  void changeToAmharic(){
    lang = Locale('am');
    isEnglish = false;
    notifyListeners();
  }

  void changeToEnglish(){
    lang = Locale('en');
    isEnglish = true;
    notifyListeners();
  }

  void changeLanguage(){
    isEnglish = !isEnglish;
    if(isEnglish){
      lang = Locale('en');
    } else {
      lang = Locale('am');
    }
    notifyListeners();
  }
}