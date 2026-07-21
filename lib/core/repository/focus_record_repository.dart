import 'package:flutter/material.dart';
import '../../model/focus_record.dart';
import '../../model/sta_range.dart';
import 'DBManager.dart';

class FocusRecordRepository {

  FocusRecordRepository._();
  static final FocusRecordRepository instance = FocusRecordRepository._();

  Future<int> insert(FocusRecord record) async {
    final db = await DBManager.instance.database;

    return db.insert(
      'focus_record',
      record.toMap(),
    );
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

  Future<int> delete(int id) async {
    final db = await DBManager.instance.database;

    return db.delete(
      'focus_record',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await DBManager.instance.database;

    await db.delete('focus_record');
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

  Future<List<FocusRecord>> findAll() async {
    final db = await DBManager.instance.database;

    final result = await db.query(
      'focus_record',
      orderBy: 'start_time DESC',
    );

    return result.map(FocusRecord.fromMap).toList();
  }

  Future<List<FocusRecord>> findByDateRange({
    required DateTime start,
    required DateTime end,
    bool completedOnly = false,
  }) async {
    final db = await DBManager.instance.database;

    final where = <String>[
      'start_time >= ?',
      'start_time < ?',
    ];

    final args = <Object>[
      start.millisecondsSinceEpoch,
      end.millisecondsSinceEpoch,
    ];

    if (completedOnly) {
      where.add('completed = 1');
    }

    final result = await db.query(
      'focus_record',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'start_time DESC',
    );

    return result.map(FocusRecord.fromMap).toList();
  }
}

// 统计
extension FocusRecordStatistics on FocusRecordRepository {

  Future<int> getRecordCount({DateTime? start, DateTime? end,}) async {
    final db = await DBManager.instance.database;

    final where = <String>[];
    final args = <Object>[];

    if (start != null) {
      where.add("start_time >= ?");
      args.add(start.millisecondsSinceEpoch);
    }

    if (end != null) {
      where.add("start_time < ?");
      args.add(end.millisecondsSinceEpoch);
    }

    final sql = StringBuffer()
      ..write("SELECT COUNT(*) AS count FROM focus_record");

    if (where.isNotEmpty) {
      sql.write(" WHERE ${where.join(" AND ")}");
    }

    final result = await db.rawQuery(sql.toString(), args);

    return (result.first["count"] as num).toInt();
  }

  Future<int> getCompletedCount({DateTime? start, DateTime? end,}) async {
    final db = await DBManager.instance.database;

    final where = <String>[
      "completed = 1",
    ];

    final args = <Object>[];

    if (start != null) {
      where.add("start_time >= ?");
      args.add(start.millisecondsSinceEpoch);
    }

    if (end != null) {
      where.add("start_time < ?");
      args.add(end.millisecondsSinceEpoch);
    }

    final result = await db.rawQuery(
      """
      SELECT COUNT(*) AS count
      FROM focus_record
      WHERE ${where.join(" AND ")}
      """,
      args,
    );

    return (result.first["count"] as num).toInt();
  }

  Future<int> getFailedCount({DateTime? start, DateTime? end,}) async {
    final db = await DBManager.instance.database;

    final where = <String>[
      "completed = 0",
    ];

    final args = <Object>[];

    if (start != null) {
      where.add("start_time >= ?");
      args.add(start.millisecondsSinceEpoch);
    }

    if (end != null) {
      where.add("start_time < ?");
      args.add(end.millisecondsSinceEpoch);
    }

    final result = await db.rawQuery(
      """
      SELECT COUNT(*) AS count
      FROM focus_record
      WHERE ${where.join(" AND ")}
      """,
      args,
    );

    return (result.first["count"] as num).toInt();
  }

  Future<int> getTotalFocusSeconds({DateTime? start, DateTime? end,}) async {
    debugPrint("start = $start");
    debugPrint("end = $end");
    final db = await DBManager.instance.database;

    final where = <String>[
      "completed = 1",
    ];

    final args = <Object>[];

    if (start != null) {
      where.add("start_time >= ?");
      args.add(start.millisecondsSinceEpoch);
    }

    if (end != null) {
      where.add("start_time < ?");
      args.add(end.millisecondsSinceEpoch);
    }

    final result = await db.rawQuery(
      """
      SELECT IFNULL(SUM(actual_seconds),0) AS total
      FROM focus_record
      WHERE ${where.join(" AND ")}
      """,
      args,
    );

    return (result.first["total"] as num).toInt();
  }

  Future<int> getAverageFocusSeconds({
    DateTime? start,
    DateTime? end,
  }) async {
    final db = await DBManager.instance.database;

    final where = <String>[
      "completed = 1",
    ];

    final args = <Object>[];

    if (start != null) {
      where.add("start_time >= ?");
      args.add(start.millisecondsSinceEpoch);
    }

    if (end != null) {
      where.add("start_time < ?");
      args.add(end.millisecondsSinceEpoch);
    }

    final result = await db.rawQuery(
      """
      SELECT IFNULL(AVG(actual_seconds),0) AS avg
      FROM focus_record
      WHERE ${where.join(" AND ")}
      """,
      args,
    );

    return (result.first["avg"] as num).round();
  }

  Future<double> getCompletionRate({
    DateTime? start,
    DateTime? end,
  }) async {
    final db = await DBManager.instance.database;

    final where = <String>[];
    final args = <Object>[];

    if (start != null) {
      where.add("start_time >= ?");
      args.add(start.millisecondsSinceEpoch);
    }

    if (end != null) {
      where.add("start_time < ?");
      args.add(end.millisecondsSinceEpoch);
    }

    final sql = StringBuffer()
      ..write("""
      SELECT
        COUNT(*) AS total,
        SUM(CASE WHEN completed = 1 THEN 1 ELSE 0 END) AS completed
      FROM focus_record
      """);

    if (where.isNotEmpty) {
      sql.write(" WHERE ${where.join(" AND ")}");
    }

    final result = await db.rawQuery(
      sql.toString(),
      args,
    );

    final total = (result.first["total"] as num).toInt();

    if (total == 0) {
      return 0;
    }

    final completed =
    ((result.first["completed"] ?? 0) as num).toInt();

    return completed / total;
  }
}

// 图表
extension FocusRecordChart on FocusRecordRepository {
  Future<List<int>> getChartData(
      StaRange range,
      DateTime date,
      ) {
    switch (range) {
      case StaRange.day:
        return _dayChart(date);

      case StaRange.week:
        return _weekChart(date);

      case StaRange.month:
        return _monthChart(date);

      case StaRange.year:
        return _yearChart(date);
    }
  }

  Future<List<int>> _dayChart(DateTime date) async {
    final db = await DBManager.instance.database;

    final start = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final end = start.add(const Duration(days: 1));

    final result = await db.rawQuery(
      '''
      SELECT
        strftime('%H', datetime(start_time/1000,'unixepoch','localtime')) AS hour,
        SUM(actual_seconds) AS seconds
      FROM focus_record
      WHERE completed = 1
        AND start_time >= ?
        AND start_time < ?
      GROUP BY hour
      ''',
      [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    final data = List<int>.filled(24, 0);

    for (final row in result) {
      final hour = int.parse(row["hour"].toString());
      data[hour] = (row["seconds"] as num).toInt();
    }

    return data;
  }

  Future<List<int>> _weekChart(DateTime date) async {
    final db = await DBManager.instance.database;

    final monday = DateTime(
      date.year,
      date.month,
      date.day - (date.weekday - 1),
    );

    final nextMonday = monday.add(const Duration(days: 7));

    final result = await db.rawQuery(
      '''
      SELECT
        date(datetime(start_time/1000,'unixepoch','localtime')) AS day,
        SUM(actual_seconds) AS seconds
      FROM focus_record
      WHERE completed = 1
        AND start_time >= ?
        AND start_time < ?
      GROUP BY day
      ORDER BY day
      ''',
      [
        monday.millisecondsSinceEpoch,
        nextMonday.millisecondsSinceEpoch,
      ],
    );

    final data = List<int>.filled(7, 0);

    for (final row in result) {
      final day = DateTime.parse(row["day"].toString());

      final index = day.difference(monday).inDays;

      if (index >= 0 && index < 7) {
        data[index] = (row["seconds"] as num).toInt();
      }
    }

    return data;
  }

  Future<List<int>> _monthChart(DateTime date) async {
    final db = await DBManager.instance.database;

    final start = DateTime(
      date.year,
      date.month,
    );

    final end = DateTime(
      date.year,
      date.month + 1,
    );

    final result = await db.rawQuery(
      '''
      SELECT
        strftime('%d', datetime(start_time/1000,'unixepoch','localtime')) AS day,
        SUM(actual_seconds) AS seconds
      FROM focus_record
      WHERE completed = 1
        AND start_time >= ?
        AND start_time < ?
      GROUP BY day
      ''',
      [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    final days = DateUtils.getDaysInMonth(
      date.year,
      date.month,
    );

    final data = List<int>.filled(days, 0);

    for (final row in result) {
      final day = int.parse(row["day"].toString());
      data[day - 1] = (row["seconds"] as num).toInt();
    }

    return data;
  }

  Future<List<int>> _yearChart(DateTime date) async {
    final db = await DBManager.instance.database;

    final start = DateTime(date.year);

    final end = DateTime(date.year + 1);

    final result = await db.rawQuery(
      '''
      SELECT
        strftime('%m', datetime(start_time/1000,'unixepoch','localtime')) AS month,
        SUM(actual_seconds) AS seconds
      FROM focus_record
      WHERE completed = 1
        AND start_time >= ?
        AND start_time < ?
      GROUP BY month
      ''',
      [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    final data = List<int>.filled(12, 0);

    for (final row in result) {
      final month = int.parse(row["month"].toString());
      data[month - 1] = (row["seconds"] as num).toInt();
    }

    return data;
  }
}