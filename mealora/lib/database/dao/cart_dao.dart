import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

/// Một dòng giỏ hàng đơn giản trả về từ DB (meal_id + quantity).
class CartRow {
  final String mealId;
  final int quantity;
  const CartRow({required this.mealId, required this.quantity});
}

class CartDao {
  CartDao._();
  static final CartDao instance = CartDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<List<CartRow>> getItems(String userId) async {
    final db = await _db;
    final rows = await db.query('cart_items',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at ASC');
    return rows
        .map((r) => CartRow(
              mealId: r['meal_id'] as String,
              quantity: r['quantity'] as int,
            ))
        .toList();
  }

  /// Thêm hoặc cập nhật số lượng (UPSERT).
  Future<void> upsert(String userId, String mealId, int quantity) async {
    final db = await _db;
    final existing = await db.query('cart_items',
        where: 'user_id = ? AND meal_id = ?',
        whereArgs: [userId, mealId],
        limit: 1);
    if (existing.isEmpty) {
      await db.insert('cart_items', {
        'user_id': userId,
        'meal_id': mealId,
        'quantity': quantity,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      await db.update(
        'cart_items',
        {'quantity': quantity},
        where: 'user_id = ? AND meal_id = ?',
        whereArgs: [userId, mealId],
      );
    }
  }

  Future<void> removeItem(String userId, String mealId) async {
    final db = await _db;
    await db.delete('cart_items',
        where: 'user_id = ? AND meal_id = ?', whereArgs: [userId, mealId]);
  }

  Future<void> clearCart(String userId) async {
    final db = await _db;
    await db.delete('cart_items', where: 'user_id = ?', whereArgs: [userId]);
  }
}
