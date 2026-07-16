import '../../model/collectible_item.dart';
import 'DBManager.dart';

class CollectibleRepository {
  CollectibleRepository._();
  static final CollectibleRepository instance = CollectibleRepository._();

  Future<List<CollectibleItem>> findAll() async {
    final db = DBManager.instance.database;

    final result = await db.query(
      'collectible',
      orderBy: 'id ASC',
    );

    return result
        .map(CollectibleItem.fromMap)
        .toList();
  }

  Future<CollectibleItem?> findById(int? id) async {
    if (id == null) return null;

    final db = DBManager.instance.database;

    final result = await db.query(
      'collectible',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return CollectibleItem.fromMap(result.first);
  }

  Future<List<CollectibleItem>> findByIds( Iterable<int> ids,) async {
    if (ids.isEmpty) {
      return [];
    }

    final db = DBManager.instance.database;

    final placeholders = List.filled(ids.length, '?').join(',');

    final result = await db.query(
      'collectible',
      where: 'id IN ($placeholders)',
      whereArgs: ids.toList(),
      orderBy: 'id ASC',
    );

    return result
        .map(CollectibleItem.fromMap)
        .toList();
  }
}