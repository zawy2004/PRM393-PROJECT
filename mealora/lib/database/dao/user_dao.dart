import 'package:sqflite/sqflite.dart';
import '../../models/user.dart';
import '../database_helper.dart';

class UserDao {
  UserDao._();
  static final UserDao instance = UserDao._();

  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<int> insert(User user) async {
    final db = await _db;
    return db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<User?> findByEmail(String email) async {
    final db = await _db;
    final rows =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  Future<User?> findById(String id) async {
    final db = await _db;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  Future<int> update(User user) async {
    final db = await _db;
    return db.update('users', user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> delete(String id) async {
    final db = await _db;
    return db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
