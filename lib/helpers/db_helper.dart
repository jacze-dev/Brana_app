import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'noteApp.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, note TEXT, createdDate TEXT, updatedDate TEXT, isFav INTEGER, isPinned INTEGER,isUploaded INTEGER)');
      db.execute(
          'CREATE TABLE quotes(id TEXT PRIMARY KEY, title TEXT, qoute TEXT, qoutedBy TEXT, createdDate TEXT, updatedDate TEXT, isFav INTEGER, isPinned INTEGER,isUploaded INTEGER)');
    }, version: 1);
    return db;
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database();
    final rows = await db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return rows;
  }

  static Future<List<Map<String, dynamic>>> getData(
      String table, String sort) async {
    final db = await database();
    if (sort == '') {
      final lists = await db.query(
        table,
      );
      return lists;
    } else {
      final lists = await db.query(
        table,
        orderBy: sort,
      );
      return lists;
    }
  }

  static Future<int> delete(String table, String id) async {
    final db = await database();
    final rows = db.delete(table, where: 'id = ?', whereArgs: [id]);
    return rows;
  }

  static Future<int> update(
      String id, String table, Map<String, Object> note) async {
    final db = await database();
    final rows = db.update(table, note,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.rollback);
    return rows;
  }
}
