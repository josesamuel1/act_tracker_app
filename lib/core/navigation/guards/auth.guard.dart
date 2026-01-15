import 'package:act_tracker/core/data/mixins/user.mixin.dart';
import 'package:act_tracker/core/navigation/app_router.dart';
import 'package:auto_route/auto_route.dart';

class AuthGuard extends AutoRouteGuard with UserMixin {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final user = await currentUser;

    if (user != null) {
      resolver.next();
      return;
    }

    router.replace(AuthRoute());
  }
}
