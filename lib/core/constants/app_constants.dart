class AppConstants {
  const AppConstants._();

  static const int minMinutes = 5; // 最小时间
  static const int maxMinutes = 120;// 倒计时最长时间
  static const int maxCountUpMinutes = 720;// 正计时最长时间，如果正计时无限长，则万一用户忘记打开app，数据还是有问题

  static const int step = 5;

  static const double kFocusProgressRadiusFactor = 0.8;
  static const double kFocusProgressThickness = 0.12;

  static const String kBaseUrl = "http://192.168.205.55:8080";
  static const String kBaseWSUrl = "ws://192.168.205.55:8080/ws";

}