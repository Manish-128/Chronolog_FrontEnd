import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define the color palette
class AppTheme {
  static const Color primaryColor = Color(0xFF6200EA); // Vibrant purple
  static const Color accentColor = Color(0xFF03DAC6); // Teal accent
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light grey background
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF212121); // Dark text
  static const Color secondaryTextColor = Color(0xFF757575); // Grey text
  static const Color errorColor = Color(0xFFD32F2F); // Red for errors

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardColor,
        background: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
          bodyMedium: TextStyle(fontSize: 14, color: textColor),
          bodySmall: TextStyle(fontSize: 12, color: secondaryTextColor),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 2,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.poppins(color: textColor),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(cardColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerTheme: const DividerThemeData(
        color: secondaryTextColor,
        thickness: 1,
        space: 16,
      ),
    );
  }
}