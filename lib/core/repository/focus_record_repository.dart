import '../../model/focus_record.dart';
import 'DBManager.dart';

class FocusRecordRepository {
  FocusRecordRepository._();
  static final instance = FocusRecordRepository._();

  Future<int> insert(FocusRecord record) async {
    final db = await DBManager.instance.database;
    return db.insert('focus_record', record.toMap());
  }

  Future<int> update(FocusRecord record) async {
    final db = await DBManager.instance.database;
    return db.update('focus_record', record.toMap(), where: 'id = ?', whereArgs: [record.id]);
  }

  Future<int> delete(int id) async {
    final db = await DBManager.instance.database;
    return db.delete('focus_record', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await DBManager.instance.database;
    await db.delete('focus_record');
  }

  Future<FocusRecord?> findById(int id) async {
    final db = await DBManager.instance.database;
    final result = await db.query('focus_record', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isEmpty ? null : FocusRecord.fromMap(result.first);
  }

  Future<List<FocusRecord>> findAll() async {
    final db = await DBManager.instance.database;
    final result = await db.query('focus_record', orderBy: 'start_time DESC');
    return result.map(FocusRecord.fromMap).toList();
  }

  Future<List<FocusRecord>> findByDateRange({required DateTime start, required DateTime end}) async {
    final db = await DBManager.instance.database;
    final result = await db.query(
      'focus_record',
      where: 'start_time >= ? AND start_time < ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'start_time DESC',
    );
    return result.map(FocusRecord.fromMap).toList();
  }


}