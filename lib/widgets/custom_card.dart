import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF054bb4); // Cobalt
  static const Color backgroundColor = Color(0xFF658cc2); // Ship Cove
  static const Color textColor = Color(0xFF5d6169); // Shuttle Gray
  static const Color subtleTextColor = Color(0xFF2e5caf); // Azure
  static const Color errorColor = Colors.red;

  static const TextStyle headlineStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: 'TimesNewRoman',
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textColor,
    fontFamily: 'TimesNewRoman',
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: subtleTextColor,
    fontFamily: 'TimesNewRoman',
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      textTheme: TextTheme(
        displayLarge: headlineStyle,
        bodyLarge: bodyTextStyle,
        bodyMedium: bodyTextStyle, // 추가
        bodySmall: captionStyle, // 추가
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: subtleTextColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        hintStyle: TextStyle(color: subtleTextColor),
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: subtleTextColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        background: backgroundColor,
        onBackground: textColor,
        surface: Colors.white,
        onSurface: textColor,
      ).copyWith(background: backgroundColor),
    );
  }
}
