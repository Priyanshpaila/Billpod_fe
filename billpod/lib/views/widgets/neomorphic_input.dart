import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NeomorphicInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  const NeomorphicInput({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: isDark ? Colors.white : AppColors.textDark),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.grey : AppColors.textLight),
        ),
      ),
    );
  }
}

