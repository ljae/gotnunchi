import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF979585), // Extracted from logo
      brightness: Brightness.light,
      primary: const Color(0xFF979585),
      // Remove hardcoded secondary/surface to let seedColor generate harmonious palette
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAF9), // Warm grey/stone 50
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF979585)), // Use logo color for icons
      titleTextStyle: GoogleFonts.outfit(
        color: const Color(0xFF4A4941), // Darker version of logo color for contrast
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    fontFamily: GoogleFonts.outfit().fontFamily,
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      headlineLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
      headlineMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
      ),
      titleMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF334155),
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        color: Color(0xFF334155),
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: Color(0xFF475569),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF979585),
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
