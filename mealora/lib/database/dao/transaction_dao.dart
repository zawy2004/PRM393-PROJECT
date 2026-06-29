import 'package:sqflite/sqflite.dart';
import '../../models/transaction.dart';
import '../database_helper.dart';

class TransactionDao {
  TransactionDao._();
  static final TransactionDao instance = TransactionDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<void> insert(PaymentTransaction tx) async {
    final db = await _db;
    await db.insert('transactions', tx.toMap());
  }

  Future<List<PaymentTransaction>> findByUser(String userId) async {
    final db = await _db;
    final rows = await db.query('transactions',
        where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return rows.map(PaymentTransaction.fromMap).toList();
  }
}
