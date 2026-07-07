import 'DBManager.dart';
import '../../model/FocusRecord.dart';

class FocusRecordRepository {

  Future<int> insert(FocusRecord record) async {

    final db = await DBManager.instance.database;

    return db.insert(
      'focus_record',
      record.toMap(),
    );
  }

  Future<List<FocusRecord>> findAll() async {

    final db = await DBManager.instance.database;

    final result = await db.query(
      'focus_record',
      orderBy: 'created_at DESC',
    );

    return result
        .map(FocusRecord.fromMap)
        .toList();
  }

  Future<int> getTotalFocusSeconds() async {
    final db = await DBManager.instance.database;

    final result = await db.rawQuery('''
    SELECT SUM(actual_seconds) as total
    FROM focus_record
    WHERE completed = 1
  ''');

    final value = result.first['total'];

    if (value == null) {
      return 0;
    }

    return value as int;
  }

  Future<int> update(FocusRecord record) async {
    final db = await DBManager.instance.database;
    return db.update(
      'focus_record',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<FocusRecord?> findById(int id) async {
    final db = await DBManager.instance.database;
    final result = await db.query(
      'focus_record',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }
    return FocusRecord.fromMap(result.first);
  }

}