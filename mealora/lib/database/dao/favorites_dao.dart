import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class FavoritesDao {
  FavoritesDao._();
  static final FavoritesDao instance = FavoritesDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<List<String>> getMealIds(String userId) async {
    final db = await _db;
    final rows = await db.query('favorites',
        columns: ['meal_id'],
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC');
    return rows.map((r) => r['meal_id'] as String).toList();
  }

  Future<bool> isFavorite(String userId, String mealId) async {
    final db = await _db;
    final rows = await db.query('favorites',
        where: 'user_id = ? AND meal_id = ?',
        whereArgs: [userId, mealId],
        limit: 1);
    return rows.isNotEmpty;
  }

  Future<void> add(String userId, String mealId) async {
    final db = await _db;
    await db.insert(
      'favorites',
      {
        'user_id': userId,
        'meal_id': mealId,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> remove(String userId, String mealId) async {
    final db = await _db;
    await db.delete('favorites',
        where: 'user_id = ? AND meal_id = ?', whereArgs: [userId, mealId]);
  }

  Future<void> toggle(String userId, String mealId) async {
    if (await isFavorite(userId, mealId)) {
      await remove(userId, mealId);
    } else {
      await add(userId, mealId);
    }
  }

  Future<void> clearAll(String userId) async {
    final db = await _db;
    await db.delete('favorites', where: 'user_id = ?', whereArgs: [userId]);
  }
}
