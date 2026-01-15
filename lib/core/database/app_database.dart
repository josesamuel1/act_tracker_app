import 'package:act_tracker/core/database/tables/user_table.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get instance async {
    /// If the database already exists, return it.
    /// Otherwise, create it.
    _db ??= await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final dbPath = path.join(await getDatabasesPath(), 'act_tracker.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, _) async {
        await db.execute(UserTable.createTable);
      },
    );
  }
}
