import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class AuthGuard {
  static GoRoute protected({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      builder: (context, state) {
        return Consumer(
          builder: (context, ref, _) {
            final auth = ref.watch(authProvider);

            if (auth.status == AuthStatus.loading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (auth.status == AuthStatus.authenticated) {
              return builder(context, state);
            }

            // All unauthenticated, error, or initial cases are redirected globally
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
