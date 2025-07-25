import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: BillPodApp()));
}

class BillPodApp extends ConsumerWidget {
  const BillPodApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider); // ✅ Watch GoRouter from provider

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BillPod',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
