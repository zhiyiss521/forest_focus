import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../../model/CollectibleItem.dart';

class CollectibleProvider extends ChangeNotifier {

  List<CollectibleItem> _items = [];

  List<CollectibleItem> get items => _items;

  CollectibleItem? _selected;

  CollectibleItem? get selected => _selected;

  Future<void> load() async {

    final jsonString =
    await rootBundle.loadString(
      'assets/data/collectibles.json',
    );

    final List<dynamic> list =
    jsonDecode(jsonString);

    _items = list
        .map((e) => CollectibleItem.fromJson(e))
        .toList();

    if (_items.isNotEmpty) {
      _selected = _items.first;
    }

    notifyListeners();
  }

  void select(CollectibleItem item) {
    _selected = item;
    notifyListeners();
  }
}