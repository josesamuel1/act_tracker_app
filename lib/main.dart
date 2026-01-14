import 'package:act_tracker/core/di/injection_container.dart';
import 'package:act_tracker/core/navigation/navigation.dart';
import 'package:act_tracker/core/strings/core_strings.dart';
import 'package:act_tracker/features/auth/presentation/cubit/auth_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => getIt<AuthPageCubit>())],
      child: ActTracker(),
    ),
  );
}

class ActTracker extends StatelessWidget {
  final appRouter = AppRouter();

  ActTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(navigatorObservers: () => [AppRouteObserver()]),
      title: CoreStrings.appName,
      restorationScopeId: 'app',
    );
  }
}
