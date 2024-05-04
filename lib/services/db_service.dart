import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBService {
  // static Future<Database> oldatabase() async {
  //   //get the path to the database
  //   final dbPath = await sql.getDatabasesPath();

  //   //open the database
  //   return sql.openDatabase(path.join(dbPath, 'todo.db'),
  //       //create the database if it does not exist
  //       onCreate: (db, version) {
  //     //create the table
  //     return db.execute(
  //         'CREATE TABLE user_notes(id TEXT PRIMARY KEY, title TEXT, msg TEXT, date TEXT)');
  //   }, version: 1);
  // }

  static Future<Database> database() async {
    //get the path to save the database
    final dbPath = await sql.getDatabasesPath();

    //open the database
    return sql.openDatabase(_dbFullPath(dbPath),
        onCreate: _createDb, version: 1);
  }

  static String _dbFullPath(String dbPath) {
    return path.join(dbPath, 'todo.db');
  }

  static Future _createDb(Database db, int key) async {
    //create the table
    return db.execute(
        'CREATE TABLE todo(id TEXT PRIMARY KEY, title TEXT, description TEXT, eventType TEXT,creationDate TEXT, scheduleDate TEXT)');
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    //get the database
    final db = await DBService.database();

    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBService.database();
    return db.query(table);
  }

  static Future<void> deleteData(String table, String id) async {
    final db = await DBService.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
