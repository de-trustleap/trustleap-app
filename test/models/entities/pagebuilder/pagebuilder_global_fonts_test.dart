import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_fonts.dart';

void main() {
  group("PageBuilderGlobalFonts_CopyWith", () {
    test("set headline with copyWith should set headline for resulting object",
        () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const expectedResult = PageBuilderGlobalFonts(
        headline: "Arial",
        text: null,
      );
      // When
      final result = fonts.copyWith(headline: "Arial");
      // Then
      expect(result, expectedResult);
    });

    test("set text with copyWith should set text for resulting object", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const expectedResult = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Lato",
      );
      // When
      final result = fonts.copyWith(text: "Lato");
      // Then
      expect(result, expectedResult);
    });

    test("set both fonts with copyWith should update both fonts", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const expectedResult = PageBuilderGlobalFonts(
        headline: "Arial",
        text: "Lato",
      );
      // When
      final result = fonts.copyWith(
        headline: "Arial",
        text: "Lato",
      );
      // Then
      expect(result, expectedResult);
    });

    test("copyWith without parameters should return identical object", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      // When
      final result = fonts.copyWith();
      // Then
      expect(result, fonts);
    });
  });

  group("PageBuilderGlobalFonts_Props", () {
    test("check if value equality works for same fonts", () {
      // Given
      const fonts1 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const fonts2 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      // Then
      expect(fonts1, fonts2);
    });

    test("check if value inequality works for different fonts", () {
      // Given
      const fonts1 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const fonts2 = PageBuilderGlobalFonts(
        headline: "Arial",
        text: "Open Sans",
      );
      // Then
      expect(fonts1, isNot(equals(fonts2)));
    });

    test("check if value equality works for partial fonts", () {
      // Given
      const fonts1 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const fonts2 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      // Then
      expect(fonts1, fonts2);
    });

    test("check if value equality works for empty fonts", () {
      // Given
      const fonts1 = PageBuilderGlobalFonts(
        headline: null,
        text: null,
      );
      const fonts2 = PageBuilderGlobalFonts(
        headline: null,
        text: null,
      );
      // Then
      expect(fonts1, fonts2);
    });

    test("check if value inequality works when headline differs", () {
      // Given
      const fonts1 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const fonts2 = PageBuilderGlobalFonts(
        headline: "Lato",
        text: "Open Sans",
      );
      // Then
      expect(fonts1, isNot(equals(fonts2)));
    });

    test("check if value inequality works when text differs", () {
      // Given
      const fonts1 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const fonts2 = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Lato",
      );
      // Then
      expect(fonts1, isNot(equals(fonts2)));
    });
  });
}
