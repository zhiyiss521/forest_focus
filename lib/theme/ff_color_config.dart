import 'package:flutter/material.dart';

class FFColorConfig {
  final String background; // 主题色
  final String card; // cell，卡片色
  final String text; // 文字色
  final String textSecondary; // placeholder的
  final String primary; // 确认按钮的颜色
  final String onPrimary; // 确认，error按钮上的文字色
  final String secondary; // cancel按钮的颜色
  final String surface; // 进图条中间的背景色
  final String danger; // error按钮的颜色

  const FFColorConfig({
    required this.background,
    required this.card,
    required this.text,
    required this.textSecondary,
    required this.primary,
    required this.secondary,
    required this.danger,
    required this.surface,
    required this.onPrimary
  });

  factory FFColorConfig.fromJson(Map<String, dynamic> json) {
    return FFColorConfig(
      background: json['background'],
      card: json['card'],
      text: json['text'],
      textSecondary: json['textSecondary'],
      primary: json['primary'],
      secondary: json['secondary'],
      danger: json['danger'],
      surface: json['surface'],
      onPrimary: json['onPrimary']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "background": background,
      "card": card,
      "text": text,
      "textSecondary": textSecondary,
      "primary": primary,
      "secondary": secondary,
      "danger": danger,
      "surface":surface,
      "onPrimary":onPrimary
    };
  }

  Color get backgroundColor => _parse(background);
  Color get cardColor => _parse(card);
  Color get textColor => _parse(text);
  Color get textSecondaryColor => _parse(textSecondary);
  Color get primaryColor => _parse(primary);
  Color get secondaryColor => _parse(secondary);
  Color get dangerColor => _parse(danger);
  Color get surfaceColor => _parse(surface);
  Color get onPrimaryColor => _parse(onPrimary);

  Color _parse(String value) {
    return Color(
      int.parse(value.replaceFirst("#", "0xFF")),
    );
  }
}