import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WBISTheme {
  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color dangerRed = Color(0xFFF44336);
  static const Color hazardBlack = Color(0xFF212121);
  static const Color backgroundWhite = Color(0xFFF9FBF9);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGray = Color(0xFF757575);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: accentGreen,
          surface: backgroundWhite,
        ),
        scaffoldBackgroundColor: backgroundWhite,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(color: textDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightGreen,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryGreen, width: 2),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentGreen,
          brightness: Brightness.dark,
          primary: accentGreen,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      );
}
