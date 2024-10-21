import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/toast.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'toasts_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE toasts(
        id INTEGER PRIMARY KEY,
        name TEXT,
        price REAL,
        currency TEXT,
        lastSold TEXT
      )
    ''');
  }

  Future<int> insertToast(Toast toast) async {
    final db = await database;
    return await db.insert('toasts', toast.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Toast>> getToasts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('toasts');
    return List.generate(maps.length, (i) {
      return Toast.fromJson(maps[i]);
    });
  }

  Future<int> updateToast(Toast toast) async {
    final db = await database;
    return await db.update('toasts', toast.toJson(),
        where: 'id = ?', whereArgs: [toast.id]);
  }

  Future<int> deleteToast(int id) async {
    final db = await database;
    return await db.delete('toasts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAlltoasts() async {
    final db = await database;
    await db.delete('toasts');
  }
}
