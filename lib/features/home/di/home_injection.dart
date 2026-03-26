import 'package:act_tracker/features/home/home.dart';
import 'package:act_tracker/features/home/presentation/cubit/home_page_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initHome() async {
  // Data
  getIt.registerLazySingleton<ActivityLocalDatasource>(() => ActivityLocalDatasourceImpl(getIt()));
  getIt.registerLazySingleton<ActivityRepository>(() => ActivityRepositoryImpl(local: getIt()));

  // UseCases
  getIt.registerLazySingleton(() => CreateEntryUseCase(getIt()));
  getIt.registerLazySingleton(() => GetEntriesByDateUseCase(getIt()));
  getIt.registerLazySingleton(() => GetEntriesByDateRangeUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateEntryUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteEntryUseCase(getIt()));

  // Cubit
  getIt.registerFactory<HomePageCubit>(
    () => HomePageCubit(
      getEntriesByDateUseCase: getIt(),
      getEntriesByDateRangeUseCase: getIt(),
      createEntryUseCase: getIt(),
      updateEntryUseCase: getIt(),
      deleteEntryUseCase: getIt(),
      userId: 1,
    ),
  );
}
