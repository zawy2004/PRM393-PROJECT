import 'package:sqflite/sqflite.dart';
import '../../models/payment_method.dart';
import '../database_helper.dart';

class PaymentMethodDao {
  PaymentMethodDao._();
  static final PaymentMethodDao instance = PaymentMethodDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<int> insert(PaymentMethod method) async {
    final db = await _db;
    return db.insert('payment_methods', method.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PaymentMethod>> findByUser(String userId) async {
    final db = await _db;
    final rows = await db.query('payment_methods',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at ASC');
    return rows.map(PaymentMethod.fromMap).toList();
  }

  Future<int> update(PaymentMethod method) async {
    final db = await _db;
    return db.update('payment_methods', method.toMap(),
        where: 'id = ?', whereArgs: [method.id]);
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return db.delete('payment_methods', where: 'id = ?', whereArgs: [id]);
  }
}
