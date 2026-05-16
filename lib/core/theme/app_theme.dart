import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color kBg = Color(0xFFF5EEE5);
  static const Color kSurface = Color(0xFFFFFBF7);
  static const Color kAccent = Color(0xFF6F4E37);
  static const Color kTerracotta = Color(0xFFC67C4E);
  static const Color kAncientBlue = Color(0xFF7B9E89);
  static const Color kParchment = Color(0xFF2F241D);
  static const Color kGlass = Color(0xFFF0E4D8);
  static const Color kGlassBorder = Color(0xFFE0D1C0);

  static const Color primaryColor = kAccent;
  static const Color secondaryColor = kTerracotta;
  static const Color accentColor = kAccent;
  static const Color backgroundColor = kBg;
  static const Color surfaceColor = kSurface;
  static const Color errorColor = Color(0xFFBA4A38);
  static const Color textDark = kParchment;
  static const Color textLight = Color(0xFF7A685B);
  static const Color textWhite = Colors.white;

  static const Color viewerColor = kAccent;
  static const Color contributorColor = kTerracotta;
  static const Color adminColor = kAncientBlue;

  static ThemeData get darkGlassTheme {
    final baseTextTheme = GoogleFonts.dmSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: kBg,
      colorScheme: const ColorScheme.light(
        primary: kAccent,
        secondary: kTerracotta,
        tertiary: kAncientBlue,
        surface: kSurface,
        onPrimary: Colors.white,
        onSurface: kParchment,
        error: errorColor,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w800,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w800,
        ),
        displaySmall: baseTextTheme.displaySmall?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w800,
          fontSize: 32,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: kParchment,
          height: 1.45,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: textLight,
          height: 1.4,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          color: kAccent,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.dmSans(
          color: kParchment,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: const IconThemeData(color: kParchment),
      ),
      cardTheme: CardThemeData(
        color: kSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: kGlassBorder),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kGlass,
        selectedColor: kAccent,
        secondarySelectedColor: kAccent,
        labelStyle: GoogleFonts.dmSans(
          color: kParchment,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: GoogleFonts.dmSans(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        side: const BorderSide(color: kGlassBorder),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 54),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kAccent,
          side: const BorderSide(color: kGlassBorder),
          minimumSize: const Size(64, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kAccent,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kAccent,
          textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: kGlassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: kGlassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: kAccent, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textLight),
        hintStyle: const TextStyle(color: textLight),
        prefixIconColor: kAccent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kSurface,
        indicatorColor: kGlass,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
          Set<WidgetState> states,
        ) {
          final color = states.contains(WidgetState.selected)
              ? kAccent
              : textLight;
          return IconThemeData(color: color);
        }),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      dividerColor: kGlassBorder,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: kParchment,
        contentTextStyle: GoogleFonts.dmSans(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
