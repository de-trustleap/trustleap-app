import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  group("PageBuilderGlobalStyles_CopyWith", () {
    test("set colors with copyWith should set colors for resulting object", () {
      // Given
      const colors1 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const colors2 = PageBuilderGlobalColors(
        primary: Color(0xFF00FF00),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors1,
        fonts: null,
      );
      const expectedResult = PageBuilderGlobalStyles(
        colors: colors2,
        fonts: null,
      );
      // When
      final result = styles.copyWith(colors: colors2);
      // Then
      expect(result, expectedResult);
    });

    test("set fonts with copyWith should set fonts for resulting object", () {
      // Given
      const fonts1 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const fonts2 = PageBuilderGlobalFonts(
        headline: "Arial",
        text: null,
      );
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts1,
      );
      const expectedResult = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts2,
      );
      // When
      final result = styles.copyWith(fonts: fonts2);
      // Then
      expect(result, expectedResult);
    });

    test("set both colors and fonts with copyWith should update both", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      const expectedResult = PageBuilderGlobalStyles(
        colors: colors,
        fonts: fonts,
      );
      // When
      final result = styles.copyWith(
        colors: colors,
        fonts: fonts,
      );
      // Then
      expect(result, expectedResult);
    });

    test("copyWith without parameters should return identical object", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: fonts,
      );
      // When
      final result = styles.copyWith();
      // Then
      expect(result, styles);
    });
  });

  group("PageBuilderGlobalStyles_ResolveColorReference", () {
    test("should resolve primary color reference", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("@primary");
      // Then
      expect(result, Color(0xFFFF0000));
    });

    test("should resolve secondary color reference", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("@secondary");
      // Then
      expect(result, Color(0xFF00FF00));
    });

    test("should resolve tertiary color reference", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("@tertiary");
      // Then
      expect(result, Color(0xFF0000FF));
    });

    test("should resolve background color reference", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("@background");
      // Then
      expect(result, Color(0xFFFFFFFF));
    });

    test("should resolve surface color reference", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("@surface");
      // Then
      expect(result, Color(0xFFF0F0F0));
    });

    test("should return null for non-reference value", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("#FF0000");
      // Then
      expect(result, null);
    });

    test("should return null for unknown color reference", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("@unknown");
      // Then
      expect(result, null);
    });

    test("should return null when colors is null", () {
      // Given
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("@primary");
      // Then
      expect(result, null);
    });

    test("should return null when referenced color is null", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: null,
        secondary: Color(0xFF00FF00),
        tertiary: null,
        background: null,
        surface: null,
      );
      const styles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final result = styles.resolveColorReference("@primary");
      // Then
      expect(result, null);
    });
  });

  group("PageBuilderGlobalStyles_ResolveFontReference", () {
    test("should resolve headline font reference", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      // When
      final result = styles.resolveFontReference("@headline");
      // Then
      expect(result, "Roboto");
    });

    test("should resolve text font reference", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      // When
      final result = styles.resolveFontReference("@text");
      // Then
      expect(result, "Open Sans");
    });

    test("should return null for non-reference value", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      // When
      final result = styles.resolveFontReference("Arial");
      // Then
      expect(result, null);
    });

    test("should return null for unknown font reference", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      // When
      final result = styles.resolveFontReference("@unknown");
      // Then
      expect(result, null);
    });

    test("should return null when fonts is null", () {
      // Given
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      // When
      final result = styles.resolveFontReference("@headline");
      // Then
      expect(result, null);
    });

    test("should return null when referenced font is null", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: null,
        text: "Open Sans",
      );
      const styles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      // When
      final result = styles.resolveFontReference("@headline");
      // Then
      expect(result, null);
    });
  });

  group("PageBuilderGlobalStyles_Props", () {
    test("check if value equality works for same styles", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const styles1 = PageBuilderGlobalStyles(
        colors: colors,
        fonts: fonts,
      );
      const styles2 = PageBuilderGlobalStyles(
        colors: colors,
        fonts: fonts,
      );
      // Then
      expect(styles1, styles2);
    });

    test("check if value inequality works for different colors", () {
      // Given
      const colors1 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const colors2 = PageBuilderGlobalColors(
        primary: Color(0xFF00FF00),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const styles1 = PageBuilderGlobalStyles(
        colors: colors1,
        fonts: null,
      );
      const styles2 = PageBuilderGlobalStyles(
        colors: colors2,
        fonts: null,
      );
      // Then
      expect(styles1, isNot(equals(styles2)));
    });

    test("check if value inequality works for different fonts", () {
      // Given
      const fonts1 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const fonts2 = PageBuilderGlobalFonts(
        headline: "Arial",
        text: null,
      );
      const styles1 = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts1,
      );
      const styles2 = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts2,
      );
      // Then
      expect(styles1, isNot(equals(styles2)));
    });

    test("check if value equality works for empty styles", () {
      // Given
      const styles1 = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      const styles2 = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      // Then
      expect(styles1, styles2);
    });

    test("check if value equality works with partial data", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const styles1 = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      const styles2 = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // Then
      expect(styles1, styles2);
    });
  });
}
