import 'package:sqflite/sqflite.dart';
import '../../models/order.dart';
import '../database_helper.dart';

class OrderDao {
  OrderDao._();
  static final OrderDao instance = OrderDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  /// Lưu đơn hàng cùng danh sách món trong một transaction.
  Future<void> insertWithItems(Order order, List<OrderItem> items) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.insert('orders', order.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      for (final item in items) {
        await txn.insert('order_items', item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Order>> findByUser(String userId) async {
    final db = await _db;
    final rows = await db.query('orders',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC');
    return rows.map(Order.fromMap).toList();
  }

  Future<Order?> findById(String id) async {
    final db = await _db;
    final rows = await db.query('orders', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Order.fromMap(rows.first);
  }

  Future<List<OrderItem>> getItems(String orderId) async {
    final db = await _db;
    final rows = await db
        .query('order_items', where: 'order_id = ?', whereArgs: [orderId]);
    return rows.map(OrderItem.fromMap).toList();
  }

  Future<int> updateStatus(String orderId, String status) async {
    final db = await _db;
    return db.update('orders', {'status': status},
        where: 'id = ?', whereArgs: [orderId]);
  }
}
