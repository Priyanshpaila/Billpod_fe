import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static final light = ThemeData(
    scaffoldBackgroundColor: AppColors.base,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textDark),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.base,
      elevation: 0,
    ),
  );

  static final dark = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
    ),
    cardColor: const Color(0xFF2C2C2C),
    iconTheme: const IconThemeData(color: Colors.white70),
  );
}
