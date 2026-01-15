import 'package:act_tracker/features/auth/auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initAuth() async {
  // Data
  getIt.registerLazySingleton<AuthLocalDatasource>(() => AuthLocalDatasourceImpl());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(local: getIt()));

  // UseCases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));

  // Cubit
  getIt.registerFactory(() => AuthPageCubit(loginUseCase: getIt(), registerUseCase: getIt()));
}
