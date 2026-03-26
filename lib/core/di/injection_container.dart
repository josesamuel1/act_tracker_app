import 'package:act_tracker/core/di/db_injection.dart';
import 'package:act_tracker/features/auth/di/di.dart';
import 'package:act_tracker/features/home/di/di.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Core
  await initDatabase();

  // Features
  await initAuth();
  await initHome();
}
