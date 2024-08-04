import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'English';
  final List<String> supportedLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Korean'
  ];

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loadedLanguage = prefs.getString('language');

    if (loadedLanguage != null && supportedLanguages.contains(loadedLanguage)) {
      _currentLanguage = loadedLanguage;
    } else {
      _currentLanguage = 'English';
    }
    notifyListeners();
  }

  void setLanguage(String language) async {
    if (supportedLanguages.contains(language)) {
      _currentLanguage = language;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', language);
    } else {
      // 잘못된 언어 선택 시 처리 로직 추가 가능
    }
  }
}
