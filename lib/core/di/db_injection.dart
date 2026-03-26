import 'package:act_tracker/core/database/app_database.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

Future<void> initDatabase() async {
  final db = await AppDatabase.init();

  // Register the database in the GetIt container
  getIt.registerLazySingleton<Database>(() => db);
}
