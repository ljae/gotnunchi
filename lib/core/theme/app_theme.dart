import 'package:flutter/material.dart';


class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F172A), // Slate 900
      brightness: Brightness.light,
      primary: const Color(0xFF0F172A),
      secondary: const Color(0xFF3B82F6), // Blue 500
      surface: const Color(0xFFF8FAFC), // Slate 50
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      titleTextStyle: const TextStyle(
        fontFamily: 'GodoRounded',
        color: Color(0xFF0F172A),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    fontFamily: 'GodoRounded',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'GodoRounded',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
      headlineMedium: TextStyle(
        fontFamily: 'GodoRounded',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
      ),
      titleMedium: TextStyle(
        fontFamily: 'GodoRounded',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF334155),
      ),
      bodyLarge: TextStyle(
        fontFamily: 'GodoRounded',
        fontSize: 16,
        color: Color(0xFF334155),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'GodoRounded',
        fontSize: 14,
        color: Color(0xFF475569),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF0F172A),
      foregroundColor: Colors.white,
    ),
    // cardTheme: CardTheme(
    //   elevation: 0,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //     side: const BorderSide(color: Color(0xFFE2E8F0)),
    //   ),
    //   color: Colors.white,
    // ),
  );
}
