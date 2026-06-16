import 'package:sqflite/sqflite.dart';
import '../../models/address.dart';
import '../database_helper.dart';

class AddressDao {
  AddressDao._();
  static final AddressDao instance = AddressDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<int> insert(Address address) async {
    final db = await _db;
    if (address.isDefault) {
      await db.update('addresses', {'is_default': 0},
          where: 'user_id = ?', whereArgs: [address.userId]);
    }
    return db.insert('addresses', address.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Address>> findByUser(String userId) async {
    final db = await _db;
    final rows = await db.query('addresses',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'is_default DESC, created_at DESC');
    return rows.map(Address.fromMap).toList();
  }

  Future<Address?> getDefault(String userId) async {
    final db = await _db;
    final rows = await db.query('addresses',
        where: 'user_id = ? AND is_default = 1',
        whereArgs: [userId],
        limit: 1);
    if (rows.isEmpty) return null;
    return Address.fromMap(rows.first);
  }

  Future<int> update(Address address) async {
    final db = await _db;
    if (address.isDefault) {
      await db.update('addresses', {'is_default': 0},
          where: 'user_id = ?', whereArgs: [address.userId]);
    }
    return db.update('addresses', address.toMap(),
        where: 'id = ?', whereArgs: [address.id]);
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }
}
