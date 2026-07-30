import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {
  static const Color emerald = Color(0xFF0B8A5E);
  static const Color gold = Color(0xFFD4AF37);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightBg = Color(0xFFF8F9FA);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: emerald,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: emerald,
        secondary: gold,
        background: lightBg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: emerald,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: emerald,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: emerald,
        ),
        bodyLarge: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: emerald,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
      ),
    );
  }
}
