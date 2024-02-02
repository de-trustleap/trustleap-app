import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightPrimaryColor = Color(0xff3fb488);
  static const Color _lightBackgroundColor = Color(0xfff5f5f5);
  static const Color _lightTextColor = Color(0xff333333);
  static const Color _lightSecondaryColor = Color(0xfff07f5e);

  static const Color _darkPrimaryColor = Color(0xff3fb488);
  static const Color _darkBackgroundColor = Color(0xff536895);
  static const Color _darkTextColor = Color(0xfff5f5f5);
  static const Color _darkSecondaryColor = Color(0xfff07f5e);

  static const TextStyle _lightHeadlineLargeText =
      TextStyle(color: _lightTextColor, fontFamily: "Poppins", fontSize: 16);
  static const TextStyle _lightBodyLargeText =
      TextStyle(color: _lightTextColor, fontFamily: "Poppins");

  static final TextStyle _darkHeadlineLargeText =
      _lightHeadlineLargeText.copyWith(color: _darkTextColor);
  static final TextStyle _darkBodyLargeText =
      _lightBodyLargeText.copyWith(color: _darkTextColor);

  static const TextTheme _lightTextTheme = TextTheme(
      headlineLarge: _lightHeadlineLargeText, bodyLarge: _lightBodyLargeText);

  static final TextTheme _darkTextTheme = TextTheme(
      headlineLarge: _darkHeadlineLargeText, bodyLarge: _darkBodyLargeText);

  static const IconThemeData _lightIconTheme = IconThemeData(
    color: _lightTextColor
  );

  static const IconThemeData _darkIconTheme = IconThemeData(
    color: _darkTextColor
  );

  static final ThemeData lightTheme = ThemeData(
      colorScheme: const ColorScheme.light(
          primary: _lightPrimaryColor,
          background: _lightBackgroundColor,
          secondary: _lightSecondaryColor),
      textTheme: _lightTextTheme,
      iconTheme: _lightIconTheme);

  static final ThemeData darkTheme = ThemeData(
      colorScheme: const ColorScheme.light(
          primary: _darkPrimaryColor,
          background: _darkBackgroundColor,
          secondary: _darkSecondaryColor),
      textTheme: _darkTextTheme,
      iconTheme: _darkIconTheme);
}
