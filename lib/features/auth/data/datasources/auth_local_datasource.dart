import 'package:act_tracker/core/core.dart';
import 'package:act_tracker/features/auth/data/models/user.model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AuthLocalDatasource {
  Future<void> register({required UserModel user});
  Future<UserModel?> login({required String username, required String passwordHash});
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final Database _db;

  AuthLocalDatasourceImpl(this._db);

  // Register a new user in the database
  @override
  Future<void> register({required UserModel user}) async {
    final userJson = user.toJson();

    await _db.insert(UserTable.tableName, userJson, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  // Login a user and return the user if found, otherwise return null
  @override
  Future<UserModel?> login({required String username, required String passwordHash}) async {
    final result = await _db.query(
      UserTable.tableName,
      where: '${UserTable.username} = ? AND ${UserTable.passwordHash} = ?',
      whereArgs: [username, passwordHash],
    );

    if (result.isEmpty) return null;

    final user = UserModel.fromJson(result.first);

    return user;
  }
}
