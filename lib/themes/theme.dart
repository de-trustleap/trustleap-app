import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color lightPrimaryColor = Color(0xff3fb488);
  static const Color lightBackgroundColor = Color(0xfff5f5f5);
  static const Color lightCardColor = Color(0xffffffff);
  static const Color lightTextColor = Color(0xff333333);
  static const Color lightTextSelectionColor = Color(0xffB4D5FD);
  static const Color lightSecondaryColor = Color(0xfff07f5e);
  static const Color lightErrorColor = Colors.red;
  static const Color lightErrorContainerColor = Color(0xffFAADA8);

  static const Color darkPrimaryColor = Color(0xff3fb488);
  static const Color darkBackgroundColor = Color(0xff252E42);
  static const Color darkCardColor = Color(0xff3C4A6A);
  static const Color darkTextColor = Color(0xfff5f5f5);
  static const Color darkTextSelectionColor = Color(0xffB4D5FD);
  static const Color darkSecondaryColor = Color(0xfff07f5e);
  static const Color darkErrorColor = Color(0xffFF8D8E);
  static const Color darkErrorContainerColor = Color(0xff503035);
  static const String fontFamily = "Poppins";

  static const TextStyle lightHeadlineLargeText = TextStyle(
      color: AppTheme.lightTextColor,
      fontFamily: AppTheme.fontFamily,
      fontSize: 20);
  static const TextStyle lightBodyLargeText = TextStyle(
      color: AppTheme.lightTextColor,
      fontFamily: AppTheme.fontFamily,
      fontSize: 18);
  static const TextStyle lightBodyMediumText = TextStyle(
      color: AppTheme.lightTextColor,
      fontFamily: AppTheme.fontFamily,
      fontSize: 16);
  static const TextStyle lightBodySmallText = TextStyle(
      color: AppTheme.lightTextColor,
      fontFamily: AppTheme.fontFamily,
      fontSize: 14);

  static final TextStyle darkHeadlineLargeText =
      AppTheme.lightHeadlineLargeText.copyWith(color: AppTheme.darkTextColor);
  static final TextStyle darkBodyLargeText =
      AppTheme.lightBodyLargeText.copyWith(color: AppTheme.darkTextColor);
  static final TextStyle darkBodyMediumText =
      AppTheme.lightBodyMediumText.copyWith(color: AppTheme.darkTextColor);
  static final TextStyle darkBodySmallText =
      AppTheme.lightBodySmallText.copyWith(color: AppTheme.darkTextColor);

  static const TextTheme lightTextTheme = TextTheme(
      headlineLarge: AppTheme.lightHeadlineLargeText,
      bodyLarge: AppTheme.lightBodyLargeText,
      bodyMedium: AppTheme.lightBodyMediumText,
      bodySmall: AppTheme.lightBodySmallText,
      titleMedium: AppTheme.lightBodyMediumText);

  static final TextTheme darkTextTheme = TextTheme(
      headlineLarge: AppTheme.darkHeadlineLargeText,
      bodyLarge: AppTheme.darkBodyLargeText,
      bodyMedium: AppTheme.darkBodyMediumText,
      bodySmall: AppTheme.darkBodySmallText,
      titleMedium: AppTheme.darkBodyMediumText);

  static const TextSelectionThemeData lightTextSelectionTheme =
      TextSelectionThemeData(
          cursorColor: AppTheme.lightTextColor,
          selectionColor: AppTheme.lightTextSelectionColor,
          selectionHandleColor: AppTheme.lightTextSelectionColor);

  static const TextSelectionThemeData darkTextSelectionTheme =
      TextSelectionThemeData(
          cursorColor: AppTheme.darkTextColor,
          selectionColor: AppTheme.darkTextSelectionColor,
          selectionHandleColor: AppTheme.darkTextSelectionColor);

  static final InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.lightErrorColor)),
          floatingLabelStyle: const TextStyle(color: AppTheme.lightTextColor),
          labelStyle: AppTheme.lightBodyMediumText,
          hintStyle: AppTheme.lightBodyMediumText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.lightTextColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.lightTextColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.lightTextColor)),
          hoverColor: AppTheme.lightTextColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.lightTextColor)));

  static final InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
          errorBorder:
              OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.darkErrorColor)),
          floatingLabelStyle: const TextStyle(color: AppTheme.darkTextColor),
          labelStyle: AppTheme.darkBodyMediumText,
          hintStyle: AppTheme.darkBodyMediumText,
          focusedBorder:
              OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.darkTextColor)),
          focusedErrorBorder:
              OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.darkTextColor)),
          enabledBorder:
              OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.darkTextColor)),
          hoverColor: AppTheme.darkTextColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.darkTextColor)));

  static const IconThemeData lightIconTheme =
      IconThemeData(color: AppTheme.lightTextColor);

  static const IconThemeData darkIconTheme =
      IconThemeData(color: AppTheme.darkTextColor);

  static const DrawerThemeData lightDrawerTheme = DrawerThemeData(
    backgroundColor: AppTheme.lightBackgroundColor,
  );

  static const DrawerThemeData darkDrawerTheme = DrawerThemeData(
    backgroundColor: AppTheme.darkBackgroundColor,
  );

  static final SnackBarThemeData lightSnackbarTheme = SnackBarThemeData(
      backgroundColor: AppTheme.lightPrimaryColor,
      contentTextStyle: AppTheme.lightHeadlineLargeText
          .copyWith(color: AppTheme.darkTextColor, fontSize: 14));

  static final SnackBarThemeData darkSnackbarTheme = SnackBarThemeData(
      backgroundColor: AppTheme.darkPrimaryColor,
      contentTextStyle: AppTheme.lightHeadlineLargeText
          .copyWith(color: AppTheme.darkTextColor, fontSize: 14));

  static final TabBarTheme lightTabbarTheme = TabBarTheme(
      indicatorColor: AppTheme.lightSecondaryColor,
      splashFactory: NoSplash.splashFactory,
      labelColor: AppTheme.lightTextColor,
      labelStyle:
          AppTheme.lightBodySmallText.copyWith(color: AppTheme.darkTextColor),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent));

  static final TabBarTheme darkTabbarTheme = TabBarTheme(
      indicatorColor: AppTheme.darkSecondaryColor,
      splashFactory: NoSplash.splashFactory,
      labelColor: AppTheme.darkTextColor,
      dividerColor: Colors.transparent,
      labelStyle:
          AppTheme.darkBodySmallText.copyWith(color: AppTheme.darkTextColor),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent));

  static const DropdownMenuThemeData lightDropDownMenuTheme =
      DropdownMenuThemeData(
          textStyle: AppTheme.lightBodyMediumText,
          menuStyle: MenuStyle(
              backgroundColor:
                  MaterialStatePropertyAll(AppTheme.lightBackgroundColor),
              shadowColor:
                  MaterialStatePropertyAll(AppTheme.lightBackgroundColor),
              surfaceTintColor:
                  MaterialStatePropertyAll(AppTheme.lightBackgroundColor),
              visualDensity: VisualDensity.comfortable));

  static final DropdownMenuThemeData darkDropDownMenuTheme =
      DropdownMenuThemeData(
          textStyle: AppTheme.darkBodyMediumText,
          menuStyle: const MenuStyle(
              backgroundColor:
                  MaterialStatePropertyAll(AppTheme.darkBackgroundColor),
              shadowColor:
                  MaterialStatePropertyAll(AppTheme.darkBackgroundColor),
              surfaceTintColor:
                  MaterialStatePropertyAll(AppTheme.darkBackgroundColor),
              visualDensity: VisualDensity.comfortable));

  static final SegmentedButtonThemeData lightSegmentedButtonTheme =
      SegmentedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppTheme.lightSecondaryColor;
                } else {
                  return Colors.transparent;
                }
              }),
              iconColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppTheme.lightBackgroundColor;
                } else {
                  return AppTheme.lightTextColor;
                }
              }),
              side: MaterialStateProperty.all(BorderSide(
                  color: AppTheme.lightTextColor.withOpacity(0.3),
                  width: 1.0,
                  style: BorderStyle.solid))));

  static final SegmentedButtonThemeData darkSegmentedButtonTheme =
      SegmentedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppTheme.darkSecondaryColor;
                } else {
                  return Colors.transparent;
                }
              }),
              iconColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppTheme.darkBackgroundColor;
                } else {
                  return AppTheme.darkTextColor;
                }
              }),
              side: MaterialStateProperty.all(BorderSide(
                  color: AppTheme.darkTextColor.withOpacity(0.3),
                  width: 1.0,
                  style: BorderStyle.solid))));

  static const SearchBarThemeData lightSearchBarTheme = SearchBarThemeData(
      elevation: MaterialStatePropertyAll(1),
      backgroundColor: MaterialStatePropertyAll(AppTheme.lightCardColor),
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      hintStyle: MaterialStatePropertyAll(AppTheme.lightBodySmallText),
      textStyle: MaterialStatePropertyAll(AppTheme.lightBodySmallText));

  static final SearchBarThemeData darkSearchBarTheme = SearchBarThemeData(
      elevation: const MaterialStatePropertyAll(1),
      backgroundColor: const MaterialStatePropertyAll(AppTheme.darkCardColor),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      hintStyle: MaterialStatePropertyAll(AppTheme.darkBodySmallText),
      textStyle: MaterialStatePropertyAll(AppTheme.darkBodySmallText));

  static final RadioThemeData lightRadioTheme = RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTheme.lightSecondaryColor;
        } else {
          return AppTheme.lightTextColor.withOpacity(0.7);
        }
      }),
      splashRadius: 0,
      overlayColor: const MaterialStatePropertyAll(AppTheme.lightPrimaryColor));

  static final RadioThemeData darkRadioTheme = RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTheme.darkSecondaryColor;
        } else {
          return AppTheme.darkTextColor.withOpacity(0.7);
        }
      }),
      splashRadius: 0,
      overlayColor: const MaterialStatePropertyAll(AppTheme.darkPrimaryColor));

  static const ChipThemeData lightChipTheme = ChipThemeData(
      iconTheme: lightIconTheme,
      backgroundColor: lightBackgroundColor,
      deleteIconColor: lightTextColor,
      labelStyle: lightBodySmallText);

  static final ChipThemeData darkChipTheme = ChipThemeData(
      iconTheme: darkIconTheme,
      backgroundColor: darkBackgroundColor,
      deleteIconColor: darkTextColor,
      labelStyle: darkBodySmallText);
}
