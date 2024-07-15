import 'package:finanzbegleiter/themes/theme.dart';
import 'package:flutter/material.dart';

class MobileAppTheme {
  MobileAppTheme._();

  static final TextStyle _lightHeadlineLargeText =
      AppTheme.lightHeadlineLargeText.copyWith(fontSize: 16);
  static final TextStyle _lightBodyLargeText =
      AppTheme.lightBodyLargeText.copyWith(fontSize: 15);
  static final TextStyle _lightBodyMediumText =
      AppTheme.lightBodyMediumText.copyWith(fontSize: 14);
  static final TextStyle _lightBodySmallText =
      AppTheme.lightBodySmallText.copyWith(fontSize: 12);

  static final TextStyle _darkHeadlineLargeText =
      _lightHeadlineLargeText.copyWith(color: AppTheme.darkTextColor);
  static final TextStyle _darkBodyLargeText =
      _lightBodyLargeText.copyWith(color: AppTheme.darkTextColor);
  static final TextStyle _darkBodyMediumText =
      _lightBodyMediumText.copyWith(color: AppTheme.darkTextColor);
  static final TextStyle _darkBodySmallText =
      _lightBodySmallText.copyWith(color: AppTheme.darkTextColor);

  static final TextTheme _lightTextTheme = TextTheme(
      headlineLarge: _lightHeadlineLargeText,
      bodyLarge: _lightBodyLargeText,
      bodyMedium: _lightBodyMediumText,
      bodySmall: _lightBodySmallText,
      titleMedium: _lightBodyMediumText);

  static final TextTheme _darkTextTheme = TextTheme(
      headlineLarge: _darkHeadlineLargeText,
      bodyLarge: _darkBodyLargeText,
      bodyMedium: _darkBodyMediumText,
      bodySmall: _darkBodySmallText,
      titleMedium: _darkBodyMediumText);

  static final InputDecorationTheme _lightInputDecorationTheme =
      AppTheme.lightInputDecorationTheme.copyWith(
          labelStyle: _lightBodyMediumText, hintStyle: _lightBodyMediumText);

  static final InputDecorationTheme _darkInputDecorationTheme =
      AppTheme.darkInputDecorationTheme.copyWith(
          labelStyle: _darkBodyMediumText, hintStyle: _darkBodyMediumText);

  static final SnackBarThemeData _lightSnackbarTheme =
      AppTheme.lightSnackbarTheme.copyWith(
          contentTextStyle:
              _lightBodySmallText.copyWith(color: AppTheme.darkTextColor));

  static final SnackBarThemeData _darkSnackbarTheme = AppTheme.darkSnackbarTheme
      .copyWith(
          contentTextStyle:
              _darkBodySmallText.copyWith(color: AppTheme.darkTextColor));

  static final TabBarTheme _lightTabbarTheme = AppTheme.lightTabbarTheme
      .copyWith(
          labelStyle:
              _lightBodySmallText.copyWith(color: AppTheme.darkTextColor));

  static final TabBarTheme _darkTabbarTheme = AppTheme.darkTabbarTheme.copyWith(
      labelStyle: _darkBodySmallText.copyWith(color: AppTheme.darkTextColor));

  static final DropdownMenuThemeData _lightDropDownMenuTheme =
      AppTheme.lightDropDownMenuTheme.copyWith(textStyle: _lightBodyMediumText);

  static final DropdownMenuThemeData _darkDropDownMenuTheme =
      AppTheme.darkDropDownMenuTheme.copyWith(textStyle: _darkBodyMediumText);

  static final SearchBarThemeData _lightSearchBarTheme =
      AppTheme.lightSearchBarTheme.copyWith(
          hintStyle: MaterialStatePropertyAll(_lightBodySmallText),
          textStyle: MaterialStatePropertyAll(_lightBodySmallText));

  static final SearchBarThemeData _darkSearchBarTheme =
      AppTheme.darkSearchBarTheme.copyWith(
          hintStyle: MaterialStatePropertyAll(_darkBodySmallText),
          textStyle: MaterialStatePropertyAll(_darkBodySmallText));

  static final ChipThemeData _lightChipTheme =
      AppTheme.lightChipTheme.copyWith(labelStyle: _lightBodySmallText);

  static final ChipThemeData _darkChipTheme =
      AppTheme.darkChipTheme.copyWith(labelStyle: _darkBodySmallText);

  static final ThemeData lightTheme = ThemeData(
      colorScheme: const ColorScheme.light(
          primary: AppTheme.lightPrimaryColor,
          background: AppTheme.lightBackgroundColor,
          onPrimaryContainer: AppTheme.lightCardColor,
          secondary: AppTheme.lightSecondaryColor,
          error: AppTheme.lightErrorColor,
          errorContainer: AppTheme.lightErrorContainerColor,
          surfaceTint: AppTheme.lightTextColor),
      textTheme: _lightTextTheme,
      iconTheme: AppTheme.lightIconTheme,
      textSelectionTheme: AppTheme.lightTextSelectionTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      drawerTheme: AppTheme.lightDrawerTheme,
      snackBarTheme: _lightSnackbarTheme,
      tabBarTheme: _lightTabbarTheme,
      dropdownMenuTheme: _lightDropDownMenuTheme,
      segmentedButtonTheme: AppTheme.lightSegmentedButtonTheme,
      searchBarTheme: _lightSearchBarTheme,
      radioTheme: AppTheme.lightRadioTheme,
      chipTheme: _lightChipTheme,
      popupMenuTheme: AppTheme.lightPopupMenuTheme,
      checkboxTheme: AppTheme.lightCheckboxTheme);

  static final ThemeData darkTheme = ThemeData(
      colorScheme: const ColorScheme.dark(
          primary: AppTheme.darkPrimaryColor,
          background: AppTheme.darkBackgroundColor,
          onPrimaryContainer: AppTheme.darkCardColor,
          secondary: AppTheme.darkSecondaryColor,
          error: AppTheme.darkErrorColor,
          errorContainer: AppTheme.darkErrorContainerColor,
          surfaceTint: AppTheme.darkTextColor),
      textTheme: _darkTextTheme,
      iconTheme: AppTheme.darkIconTheme,
      textSelectionTheme: AppTheme.darkTextSelectionTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      drawerTheme: AppTheme.darkDrawerTheme,
      snackBarTheme: _darkSnackbarTheme,
      tabBarTheme: _darkTabbarTheme,
      dropdownMenuTheme: _darkDropDownMenuTheme,
      segmentedButtonTheme: AppTheme.darkSegmentedButtonTheme,
      searchBarTheme: _darkSearchBarTheme,
      radioTheme: AppTheme.darkRadioTheme,
      chipTheme: _darkChipTheme,
      popupMenuTheme: AppTheme.darkPopupMenuTheme,
      checkboxTheme: AppTheme.darkCheckboxTheme);
}
