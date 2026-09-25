import 'package:flutter/material.dart';

class AppTheme {
  // Exact Color Palette from Figma Screenshots
  static const Color primaryTeal = Color(0xFF005C53);
  static const Color darkTeal = Color(0xFF004D40);
  static const Color textDark = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textLight = Color(0xFF8A94A6);
  static const Color backgroundColor = Colors.white;
  static const Color sliderBlue = Color(0xFF00A3FF);

  // Property Aliases for Compatibility Across Widgets
  static const Color primaryColor = primaryTeal;
  static const Color secondaryColor = Color(0xFF3D7E8A);
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = textDark;
  static const Color border = Color(0xFFE2E8F0);

  // Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);

  // Result Badge Colors
  static const Color successBadgeGreen = Color(0xFF80E8A7);
  static const Color failBadgeRed = Color(0xFFFF3B00);

  // Exact Pastel Background Colors for Category Cards (from Figma design)
  static const Map<String, Color> categoryColors = {
    'general knowledge': Color(0xFFC0D4FF), // Soft Blue
    'books': Color(0xFFC2F7CE),              // Soft Green
    'history': Color(0xFFFFF5B0),            // Soft Yellow
    'science & nature': Color(0xFFF4CAFF),   // Soft Purple
    'art': Color(0xFFFFC1C1),                // Soft Pink/Red
    'vehicles': Color(0xFFFFE2B3),           // Soft Orange
  };

  // Fallback Pastels for other categories
  static const List<Color> categoryBgColors = [
    Color(0xFFC0D4FF),
    Color(0xFFC2F7CE),
    Color(0xFFFFF5B0),
    Color(0xFFF4CAFF),
    Color(0xFFFFC1C1),
    Color(0xFFFFE2B3),
    Color(0xFFD0F0FD),
    Color(0xFFE5D0FF),
    Color(0xFFFFE6D0),
    Color(0xFFD0FFEB),
  ];

  static Color getCategoryBgColor(String categoryName, int index) {
    final lowerName = categoryName.toLowerCase();
    for (var entry in categoryColors.entries) {
      if (lowerName.contains(entry.key)) {
        return entry.value;
      }
    }
    return categoryBgColors[index % categoryBgColors.length];
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'sans-serif',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        surface: backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
