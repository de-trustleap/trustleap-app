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
  static const Color lightBackgroundContrastColor = Color(0xffebebeb);

  static const Color darkPrimaryColor = Color(0xff3fb488);
  static const Color darkBackgroundColor = Color(0xff252E42);
  static const Color darkCardColor = Color(0xff3C4A6A);
  static const Color darkTextColor = Color(0xfff5f5f5);
  static const Color darkTextSelectionColor = Color(0xffB4D5FD);
  static const Color darkSecondaryColor = Color(0xfff07f5e);
  static const Color darkErrorColor = Color(0xffFF8D8E);
  static const Color darkErrorContainerColor = Color(0xff503035);
  static const Color darkBackgroundContrastColor = Color(0xffebebeb);
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

  static final TabBarThemeData lightTabbarTheme = TabBarThemeData(
      indicatorColor: AppTheme.lightSecondaryColor,
      splashFactory: NoSplash.splashFactory,
      labelColor: AppTheme.lightTextColor,
      labelStyle:
          AppTheme.lightBodySmallText.copyWith(color: AppTheme.darkTextColor),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent));

  static final TabBarThemeData darkTabbarTheme = TabBarThemeData(
      indicatorColor: AppTheme.darkSecondaryColor,
      splashFactory: NoSplash.splashFactory,
      labelColor: AppTheme.darkTextColor,
      dividerColor: Colors.transparent,
      labelStyle:
          AppTheme.darkBodySmallText.copyWith(color: AppTheme.darkTextColor),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent));

  static const DropdownMenuThemeData lightDropDownMenuTheme =
      DropdownMenuThemeData(
          textStyle: AppTheme.lightBodyMediumText,
          menuStyle: MenuStyle(
              backgroundColor:
                  WidgetStatePropertyAll(AppTheme.lightBackgroundColor),
              shadowColor:
                  WidgetStatePropertyAll(AppTheme.lightBackgroundColor),
              surfaceTintColor:
                  WidgetStatePropertyAll(AppTheme.lightBackgroundColor),
              visualDensity: VisualDensity.comfortable));

  static final DropdownMenuThemeData darkDropDownMenuTheme =
      DropdownMenuThemeData(
          textStyle: AppTheme.darkBodyMediumText,
          menuStyle: const MenuStyle(
              backgroundColor:
                  WidgetStatePropertyAll(AppTheme.darkBackgroundColor),
              shadowColor: WidgetStatePropertyAll(AppTheme.darkBackgroundColor),
              surfaceTintColor:
                  WidgetStatePropertyAll(AppTheme.darkBackgroundColor),
              visualDensity: VisualDensity.comfortable));

  static final SegmentedButtonThemeData lightSegmentedButtonTheme =
      SegmentedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightSecondaryColor;
                } else {
                  return Colors.transparent;
                }
              }),
              iconColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightBackgroundColor;
                } else {
                  return AppTheme.lightTextColor;
                }
              }),
              side: WidgetStateProperty.all(BorderSide(
                  color: AppTheme.lightTextColor.withValues(alpha: 0.3),
                  width: 1.0,
                  style: BorderStyle.solid))));

  static final SegmentedButtonThemeData darkSegmentedButtonTheme =
      SegmentedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.darkSecondaryColor;
                } else {
                  return Colors.transparent;
                }
              }),
              iconColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.darkBackgroundColor;
                } else {
                  return AppTheme.darkTextColor;
                }
              }),
              side: WidgetStateProperty.all(BorderSide(
                  color: AppTheme.darkTextColor.withValues(alpha: 0.3),
                  width: 1.0,
                  style: BorderStyle.solid))));

  static const SearchBarThemeData lightSearchBarTheme = SearchBarThemeData(
      elevation: WidgetStatePropertyAll(1),
      backgroundColor: WidgetStatePropertyAll(AppTheme.lightCardColor),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      hintStyle: WidgetStatePropertyAll(AppTheme.lightBodySmallText),
      textStyle: WidgetStatePropertyAll(AppTheme.lightBodySmallText));

  static final SearchBarThemeData darkSearchBarTheme = SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(1),
      backgroundColor: const WidgetStatePropertyAll(AppTheme.darkCardColor),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      hintStyle: WidgetStatePropertyAll(AppTheme.darkBodySmallText),
      textStyle: WidgetStatePropertyAll(AppTheme.darkBodySmallText));

  static final RadioThemeData lightRadioTheme = RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTheme.lightSecondaryColor;
        } else {
          return AppTheme.lightTextColor.withValues(alpha: 0.7);
        }
      }),
      splashRadius: 0,
      overlayColor: const WidgetStatePropertyAll(AppTheme.lightPrimaryColor));

  static final RadioThemeData darkRadioTheme = RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTheme.darkSecondaryColor;
        } else {
          return AppTheme.darkTextColor.withValues(alpha: 0.7);
        }
      }),
      splashRadius: 0,
      overlayColor: const WidgetStatePropertyAll(AppTheme.darkPrimaryColor));

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

  static final PopupMenuThemeData lightPopupMenuTheme = PopupMenuThemeData(
      textStyle: lightBodyMediumText.copyWith(color: lightSecondaryColor),
      labelTextStyle: WidgetStatePropertyAll(
          lightBodyMediumText.copyWith(color: lightSecondaryColor)),
      iconColor: lightSecondaryColor,
      iconSize: 24,
      enableFeedback: false);

  static final PopupMenuThemeData darkPopupMenuTheme = PopupMenuThemeData(
      textStyle: darkBodyMediumText.copyWith(color: darkSecondaryColor),
      labelTextStyle: WidgetStatePropertyAll(
          darkBodyMediumText.copyWith(color: darkSecondaryColor)),
      iconColor: darkSecondaryColor,
      iconSize: 24,
      enableFeedback: false);

  static final CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
      fillColor: const WidgetStatePropertyAll(Colors.transparent),
      checkColor: const WidgetStatePropertyAll(lightSecondaryColor),
      visualDensity: VisualDensity.comfortable,
      splashRadius: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) => const BorderSide(width: 1, color: lightTextColor),
      ));

  static final CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
      fillColor: const WidgetStatePropertyAll(Colors.transparent),
      checkColor: const WidgetStatePropertyAll(darkSecondaryColor),
      visualDensity: VisualDensity.comfortable,
      splashRadius: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) => const BorderSide(width: 1, color: darkTextColor),
      ));

  static final SwitchThemeData lightSwitchTheme = SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(lightCardColor),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightSecondaryColor;
        } else {
          return lightBackgroundColor;
        }
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashRadius: 0);

  static final SwitchThemeData darkSwitchTheme = SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(darkCardColor),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightSecondaryColor;
        } else {
          return lightBackgroundColor;
        }
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      trackOutlineWidth: const WidgetStatePropertyAll(0),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashRadius: 0);

  static final ProgressIndicatorThemeData lightProgressIndicatorTheme =
      const ProgressIndicatorThemeData(
          color: lightSecondaryColor,
          linearTrackColor: lightBackgroundContrastColor);

  static final ProgressIndicatorThemeData darkProgressIndicatorTheme =
      const ProgressIndicatorThemeData(
          color: darkSecondaryColor,
          linearTrackColor: darkBackgroundContrastColor);
}

// TODO: IM PAGEBUILDER HTML TEXT EDITOR KANN MAN NICHT VERNÜNFTIG SCHREIBEN. DER CURSOR GEHT IMMER WOANDERS HIN. MEIST AN DEN ANFANG DES TEXTFELDES
