import '../../model/tag.dart';
import 'DBManager.dart';

class TagRepository {
  TagRepository._();
  static final TagRepository instance = TagRepository._();

  Future<List<Tag>> findAll() async {
    final db = DBManager.instance.database;

    final result = await db.query(
      'focus_tag',
      orderBy: 'id ASC',
    );

    return result.map(Tag.fromMap).toList();
  }

  Future<Tag?> findById(int? id) async {
    if (id == null) return null;

    final db = DBManager.instance.database;

    final result = await db.query(
      'focus_tag',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Tag.fromMap(result.first);
  }

  Future<List<Tag>> findByIds(Iterable<int> ids) async {
    if (ids.isEmpty) {
      return [];
    }

    final db = DBManager.instance.database;

    final placeholders = List.filled(ids.length, '?').join(',');

    final result = await db.query(
      'focus_tag',
      where: 'id IN ($placeholders)',
      whereArgs: ids.toList(),
      orderBy: 'id ASC',
    );

    return result.map(Tag.fromMap).toList();
  }

  Future<int> insert(Tag tag) async {
    final db = DBManager.instance.database;

    return db.insert(
      'focus_tag',
      tag.toMap(),
    );
  }

  Future<int> update(Tag tag) async {
    final db = DBManager.instance.database;

    return db.update(
      'focus_tag',
      tag.toMap(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<int> delete(int id) async {
    final db = DBManager.instance.database;

    return db.delete(
      'focus_tag',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Tag 总数量
  Future<int> count() async {
    final db = DBManager.instance.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM focus_tag',
    );

    return (result.first['count'] as num).toInt();
  }

  /// 是否存在
  Future<bool> exists(int id) async {
    final db = DBManager.instance.database;

    final result = await db.rawQuery(
      '''
      SELECT EXISTS(
        SELECT 1
        FROM focus_tag
        WHERE id = ?
      ) AS exist
      ''',
      [id],
    );

    return (result.first['exist'] as num) == 1;
  }

  /// 第一个 Tag
  Future<Tag?> first() async {
    final db = DBManager.instance.database;

    final result = await db.query(
      'focus_tag',
      orderBy: 'id ASC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Tag.fromMap(result.first);
  }

  /// 是否已有专注记录
  Future<bool> hasFocusRecord(int tagId) async {
    final db = DBManager.instance.database;

    final result = await db.rawQuery(
      '''
      SELECT EXISTS(
        SELECT 1
        FROM focus_record
        WHERE tag_id = ?
      ) AS exist
      ''',
      [tagId],
    );

    return (result.first['exist'] as num) == 1;
  }
}