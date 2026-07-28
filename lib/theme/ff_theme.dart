import 'ff_color_config.dart';

class FFTheme {
  final String id;
  final String name;
  final FFColorConfig colors;

  const FFTheme({
    required this.id,
    required this.name,
    required this.colors,
  });

  factory FFTheme.fromJson(Map<String, dynamic> json) {
    return FFTheme(
      id: json['id'],
      name: json['name'],
      colors: FFColorConfig.fromJson(
        json['colors'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "colors": colors.toJson(),
    };
  }
}