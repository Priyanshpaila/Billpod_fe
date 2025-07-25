import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class NeomorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;

  const NeomorphicAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        height: preferredSize.height,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : AppColors.base,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black87 : AppColors.shadowDark,
              offset: const Offset(4, 4),
              blurRadius: 10,
            ),
            BoxShadow(
              color: isDark ? Colors.grey.shade800 : AppColors.shadowLight,
              offset: const Offset(-4, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            if (!showBack)
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            if (showBack)
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
            const SizedBox(width: 2),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            ),
            ...?actions,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
