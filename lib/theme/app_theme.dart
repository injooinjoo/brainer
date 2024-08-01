// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1DB954); // Spotify Green
  static const Color backgroundColor = Color(0xFFF2F2F7); // iOS Light Gray
  static const Color textColor = Color(0xFF000000);
  static const Color subtleTextColor = Color(0xFF8E8E93); // iOS Gray

  static const TextStyle headlineStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: 'SF Pro Display', // iOS-like font
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
    fontFamily: 'SF Pro Text', // iOS-like font
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: subtleTextColor,
    fontFamily: 'SF Pro Text', // iOS-like font
  );

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: headlineStyle.copyWith(fontSize: 17),
    ),
    textTheme: TextTheme(
      displayLarge: headlineStyle,
      bodyLarge: bodyStyle,
      bodySmall: captionStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
  );
}
