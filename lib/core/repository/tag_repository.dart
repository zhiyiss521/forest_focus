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

    return result
        .map(Tag.fromMap)
        .toList();
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

    return result
        .map(Tag.fromMap)
        .toList();
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
}