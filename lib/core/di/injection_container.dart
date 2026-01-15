import 'package:act_tracker/features/auth/di/di.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Features
  await initAuth();
}
