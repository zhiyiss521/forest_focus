import 'package:flutter/material.dart';
import '../../../core/repository/collectible_repository.dart';
import '../../../model/collectible_item.dart';

// 这里会一次性读取出来，相当于全局变量了
class CollectibleProvider extends ChangeNotifier {
  final List<CollectibleItem> _items = [];

  List<CollectibleItem> get items => List.unmodifiable(_items);

  Future<void> load() async {
    final list = await CollectibleRepository.instance.findAll();

    _items
      ..clear()
      ..addAll(list);

    notifyListeners();
  }

  CollectibleItem? getById(int? id) {
    if (id == null) return null;

    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  List<CollectibleItem> getByIds(Iterable<int> ids) {
    if (ids.isEmpty) return [];

    final idSet = ids.toSet();

    return _items.where((e) => idSet.contains(e.id)).toList();
  }
}