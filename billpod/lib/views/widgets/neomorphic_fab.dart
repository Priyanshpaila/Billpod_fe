import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NeomorphicFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const NeomorphicFAB({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : AppColors.base,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: isDark ? Colors.black87 : AppColors.shadowDark,
                offset: const Offset(6, 6),
                blurRadius: 12),
            BoxShadow(
                color: isDark ? Colors.grey.shade800 : AppColors.shadowLight,
                offset: const Offset(-6, -6),
                blurRadius: 12),
          ],
        ),
        child: Icon(icon, color: isDark ? Colors.white : AppColors.textDark),
      ),
    );
  }
}

