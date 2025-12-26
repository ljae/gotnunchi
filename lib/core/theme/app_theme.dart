import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors inspired by the logo
  static const Color primaryTeal = Color(0xFF2D7A78);
  static const Color darkTeal = Color(0xFF1B5F5D);
  static const Color lightTeal = Color(0xFF4FA9A7);
  static const Color accentGold = Color(0xFFD4A574);
  static const Color warmCream = Color(0xFFF5E6D3);
  static const Color lightCream = Color(0xFFFFF8F0);
  static const Color deepOrange = Color(0xFFE07856);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryTeal,
      onPrimary: Colors.white,
      secondary: accentGold,
      onSecondary: Color(0xFF2A2A2A),
      tertiary: deepOrange,
      surface: Colors.white,
      onSurface: Color(0xFF2A2A2A),
      surfaceContainerHighest: lightCream,
      outline: Color(0xFFE5D5C3),
      primaryContainer: Color(0xFFE8F5F4),
    ),
    scaffoldBackgroundColor: lightCream,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF2A2A2A),
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.outfit(
        color: const Color(0xFF2A2A2A),
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFE5D5C3).withValues(alpha: 0.5)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryTeal,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: warmCream,
      selectedColor: primaryTeal.withValues(alpha: 0.15),
      labelStyle: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2A2A2A),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: primaryTeal.withValues(alpha: 0.12),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      height: 70,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: primaryTeal,
          );
        }
        return GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF8A8A8A),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primaryTeal, size: 26);
        }
        return const IconThemeData(color: Color(0xFF8A8A8A), size: 24);
      }),
    ),
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        color: Color(0xFF2A2A2A),
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: Color(0xFF2A2A2A),
      ),
      titleLarge: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: Color(0xFF2A2A2A),
      ),
      titleMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: Color(0xFF2A2A2A),
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.6,
        letterSpacing: 0.2,
        color: Color(0xFF4A4A4A),
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.1,
        color: Color(0xFF6A6A6A),
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Color(0xFF2A2A2A),
      ),
    ),
  );
}
