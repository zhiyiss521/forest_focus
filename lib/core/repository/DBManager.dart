import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {

  DBManager._();

  static final DBManager instance = DBManager._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {

    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'forest_focus.db'),
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
        CREATE TABLE focus_record(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          start_time INTEGER NOT NULL,
          end_time INTEGER NOT NULL,
          target_seconds INTEGER NOT NULL,
          actual_seconds INTEGER NOT NULL,
          completed INTEGER NOT NULL,
          reward_id TEXT,
          created_at INTEGER NOT NULL
        )
        ''');
      },
    );
  }
}