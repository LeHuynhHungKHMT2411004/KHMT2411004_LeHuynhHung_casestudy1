import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('expense_manager.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        icon TEXT,
        color TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        created_at TEXT,
        updated_at TEXT,

        FOREIGN KEY (category_id)
        REFERENCES categories (id)
        ON DELETE CASCADE
      )
    ''');

    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    await db.insert(
      'categories',
      {
        'name': 'Ăn uống',
        'type': 'expense',
        'icon': 'restaurant',
        'color': '#FF751F',
      },
    );

    await db.insert(
      'categories',
      {
        'name': 'Di chuyển',
        'type': 'expense',
        'icon': 'directions_car',
        'color': '#2786EF',
      },
    );

    await db.insert(
      'categories',
      {
        'name': 'Mua sắm',
        'type': 'expense',
        'icon': 'shopping_cart',
        'color': '#A53CEB',
      },
    );

    await db.insert(
      'categories',
      {
        'name': 'Giáo dục',
        'type': 'expense',
        'icon': 'school',
        'color': '#008A8A',
      },
    );

    await db.insert(
      'categories',
      {
        'name': 'Lương',
        'type': 'income',
        'icon': 'attach_money',
        'color': '#239A4A',
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
  Future<int> insertTransaction(
      TransactionModel transaction,
      ) async {
    final db = await database;

    return await db.insert(
      'transactions',
      transaction.toMap(),
    );
  }
  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final result = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return result
        .map((map) => TransactionModel.fromMap(map))
        .toList();
  }
  Future<int> updateTransaction(
      TransactionModel transaction,
      ) async {
    final db = await database;

    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}