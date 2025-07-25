import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NeomorphicButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const NeomorphicButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : AppColors.base,
          borderRadius: BorderRadius.circular(16),
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
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
