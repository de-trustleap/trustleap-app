import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

void main() {
  group("PageBuilderGlobalColors_CopyWith", () {
    test("set primary with copyWith should set primary for resulting object",
        () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColors(
        primary: Color(0xFF00FF00),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      // When
      final result = colors.copyWith(primary: Color(0xFF00FF00));
      // Then
      expect(result, expectedResult);
    });

    test("set secondary with copyWith should set secondary for resulting object",
        () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: null,
        background: null,
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF0000FF),
        tertiary: null,
        background: null,
        surface: null,
      );
      // When
      final result = colors.copyWith(secondary: Color(0xFF0000FF));
      // Then
      expect(result, expectedResult);
    });

    test("set multiple colors with copyWith should update all specified colors",
        () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: null,
        background: Color(0xFFFFFFFF),
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColors(
        primary: Color(0xFF0000FF),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFFFFFF00),
        background: Color(0xFF000000),
        surface: Color(0xFFF0F0F0),
      );
      // When
      final result = colors.copyWith(
        primary: Color(0xFF0000FF),
        tertiary: Color(0xFFFFFF00),
        background: Color(0xFF000000),
        surface: Color(0xFFF0F0F0),
      );
      // Then
      expect(result, expectedResult);
    });

    test("copyWith without parameters should return identical object", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      // When
      final result = colors.copyWith();
      // Then
      expect(result, colors);
    });
  });

  group("PageBuilderGlobalColors_Props", () {
    test("check if value equality works for same colors", () {
      // Given
      const colors1 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const colors2 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      // Then
      expect(colors1, colors2);
    });

    test("check if value inequality works for different colors", () {
      // Given
      const colors1 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const colors2 = PageBuilderGlobalColors(
        primary: Color(0xFF0000FF),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      // Then
      expect(colors1, isNot(equals(colors2)));
    });

    test("check if value equality works for partial colors", () {
      // Given
      const colors1 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: Color(0xFF0000FF),
        background: null,
        surface: null,
      );
      const colors2 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: Color(0xFF0000FF),
        background: null,
        surface: null,
      );
      // Then
      expect(colors1, colors2);
    });

    test("check if value equality works for empty colors", () {
      // Given
      const colors1 = PageBuilderGlobalColors(
        primary: null,
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const colors2 = PageBuilderGlobalColors(
        primary: null,
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      // Then
      expect(colors1, colors2);
    });

    test("check if value inequality works when one color differs", () {
      // Given
      const colors1 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const colors2 = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFF000000),
      );
      // Then
      expect(colors1, isNot(equals(colors2)));
    });
  });
}
