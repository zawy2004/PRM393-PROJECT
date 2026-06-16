import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton mở và quản lý vòng đời của SQLite database.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'mealora.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  /// Bật foreign-key enforcement (tắt mặc định trong SQLite).
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id         TEXT PRIMARY KEY,
        email      TEXT UNIQUE NOT NULL,
        password   TEXT NOT NULL,
        full_name  TEXT NOT NULL,
        phone      TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE meals (
        id           TEXT PRIMARY KEY,
        name         TEXT NOT NULL,
        category     TEXT NOT NULL,
        description  TEXT NOT NULL DEFAULT '',
        calories     INTEGER NOT NULL DEFAULT 0,
        protein      INTEGER NOT NULL DEFAULT 0,
        carbs        INTEGER NOT NULL DEFAULT 0,
        fat          INTEGER NOT NULL DEFAULT 0,
        price        INTEGER NOT NULL DEFAULT 0,
        image_url    TEXT,
        rating       REAL NOT NULL DEFAULT 0.0,
        review_count INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE ingredients (
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_id TEXT NOT NULL,
        name    TEXT NOT NULL,
        FOREIGN KEY (meal_id) REFERENCES meals (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_id    TEXT NOT NULL,
        user_id    TEXT,
        author     TEXT NOT NULL,
        initials   TEXT NOT NULL,
        rating     REAL NOT NULL,
        comment    TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (meal_id) REFERENCES meals (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id    TEXT NOT NULL,
        meal_id    TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        UNIQUE (user_id, meal_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE addresses (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id    TEXT NOT NULL,
        label      TEXT NOT NULL,
        detail     TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE payment_methods (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id    TEXT NOT NULL,
        label      TEXT NOT NULL,
        detail     TEXT NOT NULL DEFAULT '',
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cart_items (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id    TEXT NOT NULL,
        meal_id    TEXT NOT NULL,
        quantity   INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL,
        UNIQUE (user_id, meal_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id             TEXT PRIMARY KEY,
        user_id        TEXT NOT NULL,
        subtotal       INTEGER NOT NULL,
        discount       INTEGER NOT NULL DEFAULT 0,
        shipping_fee   INTEGER NOT NULL DEFAULT 0,
        total          INTEGER NOT NULL,
        delivery_plan  TEXT NOT NULL,
        address_detail TEXT NOT NULL,
        payment_label  TEXT NOT NULL,
        status         TEXT NOT NULL DEFAULT 'delivering',
        created_at     INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id  TEXT NOT NULL,
        meal_id   TEXT NOT NULL,
        meal_name TEXT NOT NULL,
        price     INTEGER NOT NULL,
        quantity  INTEGER NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id     TEXT NOT NULL,
        title       TEXT NOT NULL,
        description TEXT NOT NULL,
        icon_label  TEXT NOT NULL DEFAULT 'notifications',
        is_read     INTEGER NOT NULL DEFAULT 0,
        created_at  INTEGER NOT NULL
      )
    ''');
  }

  /// Xóa toàn bộ DB (dùng khi debug).
  Future<void> deleteDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    await databaseFactory.deleteDatabase(path);
    _db = null;
  }
}
