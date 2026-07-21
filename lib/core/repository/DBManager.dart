import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  DBManager._();
  static final DBManager instance = DBManager._();
  Database? _db;

  Future<void> init() async {
    if (_db != null) return;
    final db = await _openDatabase();
    await _initTables(db);
    await _insertDefaultTags(db);
    await _insertDefaultCollectibles(db);
    _db = db;
  }

  Database get database {
    if (_db == null) {
      throw Exception(
        'DBManager has not been initialized. '
        'Call DBManager.instance.init() before using the database.',
      );
    }
    return _db!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'forest_focus.db'),
      version: 1,
    );
  }

  Future<void> _initTables(Database db) async {
    await _createTagTable(db);
    await _createCollectibleTable(db);
    await _createFocusRecordTable(db);
  }

  /// 专注记录
  Future<void> _createFocusRecordTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS focus_record(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_time INTEGER NOT NULL,
        end_time INTEGER NOT NULL,
        target_seconds INTEGER NOT NULL,
        actual_seconds INTEGER NOT NULL,
        completed INTEGER NOT NULL,
        collectible_item_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  /// 标签
  Future<void> _createTagTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS focus_tag(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      color INTEGER NOT NULL,
      icon TEXT NOT NULL
    )
  ''');


  }

  /// 奖励的
  Future<void> _createCollectibleTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS collectible(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      icon TEXT NOT NULL,
      desc TEXT NOT NULL,
      type TEXT NOT NULL
    )
  ''');
  }

  /// 插入默认标签
  Future<void> _insertDefaultTags(Database db) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM focus_tag',
    );

    final count = Sqflite.firstIntValue(result) ?? 0;

    if (count > 0) {
      return;
    }

    final batch = db.batch();

    const tags = [
      {
        'name': '学习',
        'color': 0xFF4CAF50,
        'icon': '📚',
      },
      {
        'name': '工作',
        'color': 0xFF2196F3,
        'icon': '💼',
      },
      {
        'name': '阅读',
        'color': 0xFFFF9800,
        'icon': '📖',
      },
      {
        'name': '运动',
        'color': 0xFFF44336,
        'icon': '🏃',
      },
      {
        'name': '写作',
        'color': 0xFF9C27B0,
        'icon': '✍️',
      },
      {
        'name': '编程',
        'color': 0xFF607D8B,
        'icon': '💻',
      },
    ];

    for (final tag in tags) {
      batch.insert('focus_tag', tag);
    }

    await batch.commit(noResult: true);
  }

  /// 插入默认奖励
  Future<void> _insertDefaultCollectibles(Database db) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM collectible',
    );

    final count = Sqflite.firstIntValue(result) ?? 0;

    if (count > 0) {
      return;
    }

    final jsonString = await rootBundle.loadString(
      'assets/data/collectibles.json',
    );
    final List<dynamic> list = jsonDecode(jsonString);

    final batch = db.batch();

    for (final item in list) {
      batch.insert('collectible', {
        'name': item['name'],
        'icon': item['icon'],
        'desc': item['desc'],
        'type': item['type'],
      });
    }

    await batch.commit(noResult: true);
  }
}