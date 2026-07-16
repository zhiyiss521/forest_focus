import 'package:flutter/material.dart';
import '../../../core/repository/tag_repository.dart';
import '../../../model/tag.dart';

class TagProvider extends ChangeNotifier {
  final List<Tag> _items = [];

  List<Tag> get items => List.unmodifiable(_items);

  Future<void> load() async {
    final list = await TagRepository.instance.findAll();

    _items
      ..clear()
      ..addAll(list);

    notifyListeners();
  }

  Tag? getById(int? id) {
    if (id == null) return null;

    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  List<Tag> getByIds(Iterable<int> ids) {
    if (ids.isEmpty) {
      return [];
    }

    final idSet = ids.toSet();

    return _items.where((e) => idSet.contains(e.id)).toList();
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
    await TagRepository.instance.delete(id);
    await load();
  }
}