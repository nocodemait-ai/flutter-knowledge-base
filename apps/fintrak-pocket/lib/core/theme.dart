import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF2E7D32);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF121212);
  static const Color background = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFB00020);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          onPrimary: Colors.white,
          secondary: const Color(0xFF4CAF50),
          onSecondary: Colors.white,
          surface: surface,
          onSurface: onSurface,
          error: error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: background,
        textTheme: TextTheme(
          headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: onSurface,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          surfaceTintColor: surface,
        ),
      );
}
