import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightPrimaryColor = Color(0xff3fb488);
  static const Color _lightBackgroundColor = Color(0xfff5f5f5);
  static const Color _lightCardColor = Color(0xffffffff);
  static const Color _lightTextColor = Color(0xff333333);
  static const Color _lightTextSelectionColor = Color(0xffB4D5FD);
  static const Color _lightSecondaryColor = Color(0xfff07f5e);
  static const Color _lightErrorColor = Colors.red;
  static const Color _lightErrorContainerColor = Color(0xffFAADA8);

  static const Color _darkPrimaryColor = Color(0xff3fb488);
  static const Color _darkBackgroundColor = Color(0xff536895);
  static const Color _darkCardColor = Color(0xff7285B0);
  static const Color _darkTextColor = Color(0xfff5f5f5);
  static const Color _darkTextSelectionColor = Color(0xffB4D5FD);
  static const Color _darkSecondaryColor = Color(0xfff07f5e);
  static const Color _darkErrorColor = Color(0xffFF8D8E);
  static const Color _darkErrorContainerColor = Color(0xff503035);

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

  static const TextSelectionThemeData _lightTextSelectionTheme =
      TextSelectionThemeData(
          cursorColor: _lightTextColor,
          selectionColor: _lightTextSelectionColor,
          selectionHandleColor: _lightTextSelectionColor);

  static const TextSelectionThemeData _darkTextSelectionTheme =
      TextSelectionThemeData(
          cursorColor: _darkTextColor,
          selectionColor: _darkTextSelectionColor,
          selectionHandleColor: _darkTextSelectionColor);

  static final InputDecorationTheme _lightInputDecorationTheme =
      InputDecorationTheme(
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _lightErrorColor)),
          floatingLabelStyle: const TextStyle(color: _lightTextColor),
          labelStyle: const TextStyle(color: _lightTextColor),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _lightTextColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _lightTextColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _lightTextColor)),
          hoverColor: _lightTextColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _lightTextColor)));

  static final InputDecorationTheme _darkInputDecorationTheme =
      InputDecorationTheme(
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _darkErrorColor)),
          floatingLabelStyle: const TextStyle(color: _darkTextColor),
          labelStyle: const TextStyle(color: _darkTextColor),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _darkTextColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _darkTextColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _darkTextColor)),
          hoverColor: _darkTextColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _darkTextColor)));

  static const IconThemeData _lightIconTheme =
      IconThemeData(color: _lightTextColor);

  static const IconThemeData _darkIconTheme =
      IconThemeData(color: _darkTextColor);

  static const DrawerThemeData _lightDrawerTheme = DrawerThemeData(
    backgroundColor: _lightBackgroundColor,
  );

  static const DrawerThemeData _darkDrawerTheme = DrawerThemeData(
    backgroundColor: _darkBackgroundColor,
  );

  static final SnackBarThemeData _lightSnackbarTheme = SnackBarThemeData(
      backgroundColor: _lightPrimaryColor,
      contentTextStyle: _lightHeadlineLargeText.copyWith(
          color: _darkTextColor, fontSize: 14));

  static final SnackBarThemeData _darkSnackbarTheme = SnackBarThemeData(
      backgroundColor: _darkPrimaryColor,
      contentTextStyle: _lightHeadlineLargeText.copyWith(
          color: _darkTextColor, fontSize: 14));

  static final TabBarTheme _lightTabbarTheme = TabBarTheme(
      indicatorColor: _lightSecondaryColor,
      splashFactory: NoSplash.splashFactory,
      labelColor: _lightTextColor,
      labelStyle:
          _lightHeadlineLargeText.copyWith(color: _darkTextColor, fontSize: 14),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent));

  static final TabBarTheme _darkTabbarTheme = TabBarTheme(
      indicatorColor: _darkSecondaryColor,
      splashFactory: NoSplash.splashFactory,
      labelColor: _darkTextColor,
      labelStyle:
          _darkHeadlineLargeText.copyWith(color: _darkTextColor, fontSize: 14),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent));

  static const DropdownMenuThemeData _lightDropDownMenuTheme =
      DropdownMenuThemeData(
          textStyle: _lightBodyLargeText,
          menuStyle: MenuStyle(
              backgroundColor: MaterialStatePropertyAll(_lightBackgroundColor),
              shadowColor: MaterialStatePropertyAll(_lightBackgroundColor),
              surfaceTintColor: MaterialStatePropertyAll(_lightBackgroundColor),
              visualDensity: VisualDensity.comfortable));

  static const DropdownMenuThemeData _darkDropDownMenuTheme =
      DropdownMenuThemeData(
          textStyle: _lightBodyLargeText,
          menuStyle: MenuStyle(
              backgroundColor: MaterialStatePropertyAll(_darkBackgroundColor),
              shadowColor: MaterialStatePropertyAll(_darkBackgroundColor),
              surfaceTintColor: MaterialStatePropertyAll(_darkBackgroundColor),
              visualDensity: VisualDensity.comfortable));

  static final SegmentedButtonThemeData _lightSegmentedButtonTheme =
      SegmentedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return _lightSecondaryColor;
                } else {
                  return Colors.transparent;
                }
              }),
              iconColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return _lightBackgroundColor;
                } else {
                  return _lightTextColor;
                }
              }),
              side: MaterialStateProperty.all(BorderSide(
                  color: _lightTextColor.withOpacity(0.3),
                  width: 1.0,
                  style: BorderStyle.solid))));

  static final SegmentedButtonThemeData _darkSegmentedButtonTheme =
      SegmentedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return _darkSecondaryColor;
                } else {
                  return Colors.transparent;
                }
              }),
              iconColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return _darkBackgroundColor;
                } else {
                  return _darkTextColor;
                }
              }),
              side: MaterialStateProperty.all(BorderSide(
                  color: _darkTextColor.withOpacity(0.3),
                  width: 1.0,
                  style: BorderStyle.solid))));

  static final ThemeData lightTheme = ThemeData(
      colorScheme: const ColorScheme.light(
          primary: _lightPrimaryColor,
          background: _lightBackgroundColor,
          onPrimaryContainer: _lightCardColor,
          secondary: _lightSecondaryColor,
          error: _lightErrorColor,
          errorContainer: _lightErrorContainerColor,
          surfaceTint: _lightTextColor),
      textTheme: _lightTextTheme,
      iconTheme: _lightIconTheme,
      textSelectionTheme: _lightTextSelectionTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      drawerTheme: _lightDrawerTheme,
      snackBarTheme: _lightSnackbarTheme,
      tabBarTheme: _lightTabbarTheme,
      dropdownMenuTheme: _lightDropDownMenuTheme,
      segmentedButtonTheme: _lightSegmentedButtonTheme);

  static final ThemeData darkTheme = ThemeData(
      colorScheme: const ColorScheme.dark(
          primary: _darkPrimaryColor,
          background: _darkBackgroundColor,
          onPrimaryContainer: _darkCardColor,
          secondary: _darkSecondaryColor,
          error: _darkErrorColor,
          errorContainer: _darkErrorContainerColor,
          surfaceTint: _darkTextColor),
      textTheme: _darkTextTheme,
      iconTheme: _darkIconTheme,
      textSelectionTheme: _darkTextSelectionTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      drawerTheme: _darkDrawerTheme,
      snackBarTheme: _darkSnackbarTheme,
      tabBarTheme: _darkTabbarTheme,
      dropdownMenuTheme: _darkDropDownMenuTheme,
      segmentedButtonTheme: _darkSegmentedButtonTheme);
}
