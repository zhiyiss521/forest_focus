import 'package:flutter/material.dart';

import '../../../core/repository/tag_repository.dart';
import '../../../model/tag.dart';
import '../../widget/hud.dart';

class TagProvider extends ChangeNotifier {
  final List<Tag> _items = [];

  bool _loading = false;
  bool get loading => _loading;

  List<Tag> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    final list = await TagRepository.instance.findAll();

    _items
      ..clear()
      ..addAll(list);

    _loading = false;
    notifyListeners();
  }

  Future<void> reload() => load();

  Tag? getById(int? id) {
    if (id == null) {
      return null;
    }

    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  Tag getByIdOrThrow(int id) {
    return _items.firstWhere((e) => e.id == id);
  }

  List<Tag> getByIds(Iterable<int> ids) {
    if (ids.isEmpty) {
      return [];
    }

    final idSet = ids.toSet();

    return _items.where((e) => idSet.contains(e.id)).toList();
  }

  bool contains(int id) {
    return _items.any((e) => e.id == id);
  }

  Future<Tag?> first() {
    return TagRepository.instance.first();
  }

  Future<void> add(Tag tag) async {
    await TagRepository.instance.insert(tag);
    await load();
  }

  Future<void> update(Tag tag) async {
    await TagRepository.instance.update(tag);
    await load();
  }

  Future<void> delete(int id) async {
    final total = await TagRepository.instance.count();
    if (total <= 1) {
      HUD.showError("至少保留一个标签");
      return;
    }
    if (await TagRepository.instance.hasFocusRecord(id)) {
      HUD.showError("当前有记录已经使用了此标签");
      return;
    }

    await TagRepository.instance.delete(id);

    await load();
  }
}