import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqliteUtility {
  static Database? _db;

  static Future<Database> get _database async {
    return _db != null ? _db! : await _initDatabase();
  }

  static Future<Database> _initDatabase() async {
    final Directory appSupportDirectory = await getApplicationSupportDirectory();
    final String path = '${appSupportDirectory.path}/app.db';

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE preferences(
                        key TEXT PRIMARY KEY NOT NULL,
                        value TEXT,
                        createdAt TEXT,
                        updatedAt TEXT
                    )''');

    await db.execute('''CREATE TABLE users(
                        id INTEGER PRIMARY KEY NOT NULL,
                        name TEXT NOT NULL,
                        email TEXT NOT NULL UNIQUE,
                        emailVerifiedAt TEXT,
                        password TEXT NOT NULL,
                        createdAt TEXT,
                        updatedAt TEXT
                    )''');
  }

  static Future<bool> clearData() async {
    final Database db = await _database;

    await db.delete('preferences');
    await db.delete('users');

    return true;
  }

  static Future<List<T>> get<T>({required String table, required T Function(Map<String, dynamic>) fromMap, String? orderBy}) async {
    final Database db = await _database;
    final List<Map<String, Object?>> result = await db.query(table, orderBy: orderBy);

    return result.isEmpty ? <T>[] : result.map((e) => fromMap(e)).toList();
  }

  static Future<bool> insertData({required String table, required Map<String, Object?> data}) async {
    final Database db = await _database;
    final int result = await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);

    if (result == 1) return true;
    throw Exception('Failed to save data');
  }

  static Future<bool> update({required String table, required String key, required Map<String, Object?> data}) async {
    final Database db = await _database;
    final int result = await db.update(table, data, where: '$key = ?', whereArgs: [data[key]], conflictAlgorithm: ConflictAlgorithm.replace);

    if (result == 1) return true;
    throw Exception('Failed to update data');
  }

  static Future<bool> delete({required String table, required String key, required String value}) async {
    final Database db = await _database;
    final int result = await db.delete(table, where: '$key = ?', whereArgs: [value]);

    if (result == 1) return true;
    throw Exception('Failed to delete data');
  }
}
