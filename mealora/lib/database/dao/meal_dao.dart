import 'package:sqflite/sqflite.dart';
import '../../models/food_item.dart';
import '../database_helper.dart';

class MealDao {
  MealDao._();
  static final MealDao instance = MealDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  /// Lưu món ăn cùng danh sách nguyên liệu trong một transaction.
  Future<void> upsert(FoodItem meal) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.insert('meals', meal.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      await txn.delete('ingredients',
          where: 'meal_id = ?', whereArgs: [meal.id]);
      for (final name in meal.ingredients) {
        await txn.insert('ingredients', {
          'meal_id': meal.id,
          'name': name,
        });
      }
    });
  }

  Future<List<FoodItem>> findAll() async {
    final db = await _db;
    final rows = await db.query('meals', orderBy: 'name ASC');
    return Future.wait(rows.map(_rowToItem));
  }

  Future<List<FoodItem>> findByCategory(String category) async {
    final db = await _db;
    final rows = await db
        .query('meals', where: 'category = ?', whereArgs: [category]);
    return Future.wait(rows.map(_rowToItem));
  }

  Future<FoodItem?> findById(String id) async {
    final db = await _db;
    final rows = await db.query('meals', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return _rowToItem(rows.first);
  }

  Future<FoodItem> _rowToItem(Map<String, dynamic> row) async {
    final db = await _db;
    final ingRows = await db.query('ingredients',
        where: 'meal_id = ?', whereArgs: [row['id']]);
    final ingredients = ingRows.map((r) => r['name'] as String).toList();
    return FoodItem.fromMap(row).copyWithIngredients(ingredients);
  }

  Future<int> delete(String id) async {
    final db = await _db;
    return db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }
}
