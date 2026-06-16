import 'package:sqflite/sqflite.dart';
import '../../models/review.dart';
import '../database_helper.dart';

class ReviewDao {
  ReviewDao._();
  static final ReviewDao instance = ReviewDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<int> insert(Review review) async {
    final db = await _db;
    return db.insert('reviews', review.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Review>> findByMeal(String mealId) async {
    final db = await _db;
    final rows = await db.query('reviews',
        where: 'meal_id = ?',
        whereArgs: [mealId],
        orderBy: 'created_at DESC');
    return rows.map(Review.fromMap).toList();
  }

  Future<List<Review>> findByUser(String userId) async {
    final db = await _db;
    final rows = await db.query('reviews',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC');
    return rows.map(Review.fromMap).toList();
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }
}
