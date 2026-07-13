import 'dart:convert';

import 'package:flutter/services.dart';

import '../../model/CollectibleItem.dart';

// 读取json文件
class CollectibleRepository {
  CollectibleRepository._();

  static final CollectibleRepository instance = CollectibleRepository._();

  List<CollectibleItem>? _cache;

  /// 加载所有收藏品（自动缓存）
  Future<List<CollectibleItem>> load() async {
    if (_cache != null) {
      return _cache!;
    }

    final jsonString = await rootBundle.loadString(
      'assets/data/collectibles.json',
    );

    final List<dynamic> list = jsonDecode(jsonString);

    _cache = list
        .map((e) => CollectibleItem.fromJson(e))
        .toList();

    return _cache!;
  }

  /// 根据 id 查找
  Future<CollectibleItem?> findById(String? id) async {
    if (id == null || id.isEmpty) {
      return null;
    }

    final items = await load();

    try {
      return items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 根据多个 id 查找
  Future<List<CollectibleItem>> findByIds(
      Iterable<String> ids,
      ) async {
    final items = await load();

    final idSet = ids.toSet();

    return items
        .where((e) => idSet.contains(e.id))
        .toList();
  }

  /// 获取全部
  Future<List<CollectibleItem>> findAll() async {
    return await load();
  }

  /// 清除缓存（开发调试时可用）
  void clearCache() {
    _cache = null;
  }
}