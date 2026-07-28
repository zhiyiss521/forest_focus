import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ff_theme.dart';

class FFThemeProvider extends ChangeNotifier {
  final List<FFTheme> themes = [];

  FFTheme? current;

  Future<void> load() async {
    await _loadTheme("assets/theme/forest.json");
    await _loadTheme("assets/theme/lavender.json");
    await _loadTheme("assets/theme/dark.json");

    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString("current_theme_id");

    if (savedId != null) {
      current = themes.firstWhere(
            (theme) => theme.id == savedId,
        orElse: () => themes.first,
      );
    } else {
      current = themes.first;
    }

    notifyListeners();
  }

  Future<void> _loadTheme(String path) async {
    final text = await rootBundle.loadString(path);

    final json = jsonDecode(text);

    themes.add(
      FFTheme.fromJson(json),
    );
  }

  Future<void> changeTheme(FFTheme theme) async {
    current = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "current_theme_id",
      theme.id,
    );
    notifyListeners();
  }
}