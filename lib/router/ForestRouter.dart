import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FFRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigator => navigatorKey.currentState!;

  static Future<T?> pushNamed<T>(String name, {Object? arguments}) {
    return navigator.pushNamed<T>(name, arguments: arguments);
  }

  static Future<T?> push<T>(Widget page) {
    return navigator.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void pop<T>([T? result]) {
    navigator.pop(result);
  }

  static void back() {
    navigator.pop();
  }

  static Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
          (route) => false,
    );
  }

}