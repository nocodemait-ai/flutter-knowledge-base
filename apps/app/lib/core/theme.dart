import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFFF57C00);
  static const secondary = Color(0xFFFFB300);
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF212121);
  static const background = Color(0xFFFFFBF8);
  static const error = Color(0xFFD32F2F);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: surface,
      onSurface: onSurface,
      background: background,
      error: error,
      onPrimary: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: background,
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: surface,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: const Size(double.infinity, 56),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: surface,
    ),
  );
}