import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../model/CollectibleItem.dart';

class CollectibleProvider extends ChangeNotifier {
  final List<CollectibleItem> _items = [];

  List<CollectibleItem> get items => _items;

  Future<void> load() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/collectibles.json',
    );

    final List<dynamic> list = jsonDecode(jsonString);

    _items
      ..clear()
      ..addAll(
        list.map((e) => CollectibleItem.fromJson(e)).toList(),
      );

    notifyListeners();
  }

  CollectibleItem? getById(String id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}