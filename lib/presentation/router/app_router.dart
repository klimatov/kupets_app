import 'package:go_router/go_router.dart';

import '../viewmodels/auth_view_model.dart';
import '../screens/about_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/menu_detail_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/promotions_screen.dart';

GoRouter createRouter(AuthViewModel authViewModel) {
  return GoRouter(
    initialLocation: '/menu',
    refreshListenable: authViewModel,
    redirect: (context, state) {
      final loggedIn = authViewModel.isLoggedIn;
      final onLogin = state.matchedLocation == '/login';

      if (!loggedIn && !onLogin) return '/login';
      if (loggedIn && onLogin) return '/menu';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/menu',
            builder: (_, __) => const MenuScreen(),
          ),
          GoRoute(
            path: '/promotions',
            builder: (_, __) => const PromotionsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/menu/:id',
        builder: (_, state) => MenuDetailScreen(
          itemId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/about',
        builder: (_, __) => const AboutScreen(),
      ),
    ],
  );
}
