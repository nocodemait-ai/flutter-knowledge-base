import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF4A7C59);
  static const Color secondary = Color(0xFF8FBC8F);
  static const Color background = Color(0xFFF5F0E8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF2D3B2D);
  static const Color error = Color(0xFFB00020);
  static const Color onError = Color(0xFFFFFFFF);

  static ThemeData get appTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
      onPrimary: Colors.white,
      onSecondary: onSurface,
      onSurface: onSurface,
      onError: onError,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(),
    scaffoldBackgroundColor: background,
    cardTheme: const CardThemeData(
      color: surface,
      elevation: 2,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
