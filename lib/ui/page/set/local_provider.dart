import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {

  static const String _keyLocale = "app_locale";
  static const List<Locale> locales = [
    Locale("en"),
    Locale("zh"),
  ];
  static String localeName(Locale locale) {
    switch (locale.languageCode) {
      case "zh":
        return "中文";
      case "en":
        return "English";
      default:
        return locale.languageCode;
    }
  }

  late Locale _locale;
  Locale get locale => _locale;
  String get currentLocalName => localeName(_locale);

  LocaleProvider() {
    _locale = locales.first;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_keyLocale);

    if (languageCode != null) {
      final savedLocale = Locale(languageCode);
      _locale = savedLocale;
    }

    notifyListeners();
  }

  Future<void> changeLocale(Locale locale) async {

    if (_locale == locale) {
      return;
    }

    _locale = locale;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyLocale,
      locale.languageCode,
    );

    notifyListeners();
  }


  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyLocale);

    _locale = locales.first;

    notifyListeners();
  }
}