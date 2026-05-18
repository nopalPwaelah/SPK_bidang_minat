import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF10B981);
  static const Color lightPrimaryDark = Color(0xFF059669);
  static const Color lightAccent = Color(0xFF3B82F6);
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color lightCardBg = Colors.white;
  static const Color lightText = Color(0xFF1F2937);
  static const Color lightSubtext = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF10B981);
  static const Color darkPrimaryDark = Color(0xFF059669);
  static const Color darkAccent = Color(0xFF3B82F6);
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkCardBg = Color(0xFF1F2937);
  static const Color darkText = Color(0xFFF9FAFB);
  static const Color darkSubtext = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // 'Segoe UI' adalah font Windows dan tidak tersedia secara native
    // di Android/iOS. Gunakan font yang didaftarkan di pubspec.yaml,
    // atau hapus baris ini untuk fallback ke font sistem masing-masing platform.
    // fontFamily: 'YourCustomFont',

    // ColorScheme — di Material 3, ini sumber utama warna untuk semua widget
    colorScheme: ColorScheme.fromSeed(
      seedColor: lightPrimary,
      brightness: Brightness.light,
      primary: lightPrimary,
      onPrimary: Colors.white,
      secondary: lightAccent,
      onSecondary: Colors.white,
      surface: lightCardBg,
      onSurface: lightText,
      error: Color(0xFFEF4444),
      onError: Colors.white,
    ),

    // primaryColor tetap diisi untuk kompatibilitas widget lama
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: lightCardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightPrimary,
        side: const BorderSide(color: lightPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPrimary,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      labelStyle: const TextStyle(color: lightSubtext),
      hintStyle: const TextStyle(color: lightSubtext),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: lightBorder,
      thickness: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: lightText,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return lightPrimary;
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightPrimary.withOpacity(0.4);
        }
        return lightBorder;
      }),
    ),

    // Text Themes
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: lightText,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: lightText,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: lightText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: lightText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: lightText,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: lightText,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: lightSubtext,
        fontSize: 12,
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // fontFamily: 'YourCustomFont',

    // ColorScheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkPrimary,
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: Colors.white,
      secondary: darkAccent,
      onSecondary: Colors.white,
      surface: darkCardBg,
      onSurface: darkText,
      error: Color(0xFFEF4444),
      onError: Colors.white,
    ),

    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: darkCardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimary,
        side: const BorderSide(color: darkPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimary,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      labelStyle: const TextStyle(color: darkSubtext),
      hintStyle: const TextStyle(color: darkSubtext),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: darkBorder,
      thickness: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: darkText,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return darkPrimary;
        return darkSubtext;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkPrimary.withOpacity(0.4);
        }
        return darkBorder;
      }),
    ),

    // Text Themes
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: darkText,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: darkText,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: darkText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: darkText,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: darkText,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: darkSubtext,
        fontSize: 12,
      ),
    ),
  );
}
