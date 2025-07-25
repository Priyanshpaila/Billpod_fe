import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:billpod/models/group_model.dart';
import 'package:billpod/services/auth_service.dart';
import 'package:billpod/views/splash/splash_screen.dart';
import 'package:billpod/views/auth/auth_selection_screen.dart';
import 'package:billpod/views/auth/login_screen.dart';
import 'package:billpod/views/auth/signup_screen.dart';
import 'package:billpod/views/dashboard/home_screen.dart';
import 'package:billpod/views/group/create_group_screen.dart';
import 'package:billpod/views/group/group_detail_screen.dart';
import 'package:billpod/views/expense/add_expense_screen.dart';
import 'package:billpod/views/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import 'auth_guard.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: routerKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authProvider.notifier).stream,
    ),
    redirect: (context, state) {
      final isAuth = auth.status == AuthStatus.authenticated;
      final isLoggingIn = [
        '/auth',
        '/login',
        '/signup',
      ].contains(state.uri.toString());

      if (!isAuth && !isLoggingIn) return '/auth';
      if (isAuth && isLoggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthSelectionScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/create-group',
        builder: (context, state) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: '/group',
        builder: (context, state) {
          final group = state.extra as GroupModel;
          return GroupDetailScreen(group: group);
        },
      ),
      GoRoute(
        path: '/add-expense',
        builder: (context, state) {
          final group = state.extra as GroupModel;
          return AddExpenseScreen(group: group);
        },
      ),
      AuthGuard.protected(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // Notifications
      // GoRoute(
      //   path: '/notifications',
      //   builder: (context, state) => const NotificationScreen(),
      // ),

      // Reports
      // GoRoute(
      //   path: '/reports',
      //   builder: (context, state) => const ReportScreen(),
      // ),
      GoRoute(
        path: '/logout',
        builder: (context, state) {
          // Defer the call to avoid "setState after dispose"
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await AuthService.logout(); // optional backend call
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');

            context.go('/auth');
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    ],
  );
});
