import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/model/use_cases/auth_providers.dart';
import 'package:habit_app/presentation/screens/login_screen.dart';
import 'package:habit_app/presentation/screens/main_screen.dart';

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final userState = ref.watch(userStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final userStateValue = userState.value ?? (null, false);
      final (user, verified) = userStateValue;

      // ログインしていない場合はログイン画面へ遷移
      if (user == null) {
        return '/login';
      }

      //  認証済みの場合はホーム画面へ遷移
      if (verified) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MainScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ],
  );
});
