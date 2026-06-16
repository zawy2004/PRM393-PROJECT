import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

/// Map dữ liệu thô từ bảng notifications.
typedef NotificationRow = Map<String, dynamic>;

class NotificationDao {
  NotificationDao._();
  static final NotificationDao instance = NotificationDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<int> insert({
    required String userId,
    required String title,
    required String description,
    String iconLabel = 'notifications',
  }) async {
    final db = await _db;
    return db.insert('notifications', {
      'user_id': userId,
      'title': title,
      'description': description,
      'icon_label': iconLabel,
      'is_read': 0,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<NotificationRow>> findByUser(String userId) async {
    final db = await _db;
    return db.query('notifications',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC');
  }

  Future<int> unreadCount(String userId) async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM notifications WHERE user_id = ? AND is_read = 0',
      [userId],
    );
    return (result.first['cnt'] as int?) ?? 0;
  }

  Future<void> markRead(int id) async {
    final db = await _db;
    await db
        .update('notifications', {'is_read': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markAllRead(String userId) async {
    final db = await _db;
    await db.update('notifications', {'is_read': 1},
        where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }
}
