import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_global_colors_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

void main() {
  group("PageBuilderGlobalColorsModel_CopyWith", () {
    test("set primary with copyWith should set primary for resulting object",
        () {
      // Given
      const model = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColorsModel(
        primary: "#00FF00",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      // When
      final result = model.copyWith(primary: "#00FF00");
      // Then
      expect(result, expectedResult);
    });

    test("set multiple colors with copyWith should update all specified colors",
        () {
      // Given
      const model = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: null,
        background: null,
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColorsModel(
        primary: "#0000FF",
        secondary: "#00FF00",
        tertiary: "#FFFF00",
        background: null,
        surface: null,
      );
      // When
      final result = model.copyWith(
        primary: "#0000FF",
        tertiary: "#FFFF00",
      );
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalColorsModel_ToMap", () {
    test("check if model with all colors is successfully converted to a map",
        () {
      // Given
      const model = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: "#0000FF",
        background: "#FFFFFF",
        surface: "#F0F0F0",
      );
      final expectedResult = {
        "primary": "#FF0000",
        "secondary": "#00FF00",
        "tertiary": "#0000FF",
        "background": "#FFFFFF",
        "surface": "#F0F0F0",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with partial colors is successfully converted to a map",
        () {
      // Given
      const model = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: "#0000FF",
        background: null,
        surface: null,
      );
      final expectedResult = {
        "primary": "#FF0000",
        "tertiary": "#0000FF",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if empty model is successfully converted to empty map", () {
      // Given
      const model = PageBuilderGlobalColorsModel(
        primary: null,
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const expectedResult = <String, dynamic>{};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalColorsModel_FromMap", () {
    test("check if map with all colors is successfully converted to model", () {
      // Given
      final map = {
        "primary": "#FF0000",
        "secondary": "#00FF00",
        "tertiary": "#0000FF",
        "background": "#FFFFFF",
        "surface": "#F0F0F0",
      };
      const expectedResult = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: "#0000FF",
        background: "#FFFFFF",
        surface: "#F0F0F0",
      );
      // When
      final result = PageBuilderGlobalColorsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with partial colors is successfully converted to model",
        () {
      // Given
      final map = {
        "primary": "#FF0000",
        "tertiary": "#0000FF",
      };
      const expectedResult = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: "#0000FF",
        background: null,
        surface: null,
      );
      // When
      final result = PageBuilderGlobalColorsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if empty map is successfully converted to empty model", () {
      // Given
      final map = <String, dynamic>{};
      const expectedResult = PageBuilderGlobalColorsModel(
        primary: null,
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      // When
      final result = PageBuilderGlobalColorsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalColorsModel_ToDomain", () {
    test(
        "check if conversion from PageBuilderGlobalColorsModel to PageBuilderGlobalColors works",
        () {
      // Given
      const model = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: "#0000FF",
        background: "#FFFFFF",
        surface: "#F0F0F0",
      );
      const expectedResult = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test(
        "check if conversion with partial colors from model to domain works",
        () {
      // Given
      const model = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: "#0000FF",
        background: null,
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: Color(0xFF0000FF),
        background: null,
        surface: null,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion handles 6-character hex colors correctly", () {
      // Given
      const model = PageBuilderGlobalColorsModel(
        primary: "FF0000",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalColorsModel_FromDomain", () {
    test(
        "check if conversion from PageBuilderGlobalColors to PageBuilderGlobalColorsModel works",
        () {
      // Given
      const domain = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const expectedResult = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: "#0000FF",
        background: "#FFFFFF",
        surface: "#F0F0F0",
      );
      // When
      final result = PageBuilderGlobalColorsModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });

    test(
        "check if conversion with partial colors from domain to model works",
        () {
      // Given
      const domain = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: Color(0xFF0000FF),
        background: null,
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: "#0000FF",
        background: null,
        surface: null,
      );
      // When
      final result = PageBuilderGlobalColorsModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from empty domain returns empty model", () {
      // Given
      const domain = PageBuilderGlobalColors(
        primary: null,
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const expectedResult = PageBuilderGlobalColorsModel(
        primary: null,
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      // When
      final result = PageBuilderGlobalColorsModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalColorsModel_Props", () {
    test("check if value equality works for same colors", () {
      // Given
      const model1 = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: "#0000FF",
        background: "#FFFFFF",
        surface: "#F0F0F0",
      );
      const model2 = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: "#0000FF",
        background: "#FFFFFF",
        surface: "#F0F0F0",
      );
      // Then
      expect(model1, model2);
    });

    test("check if value inequality works for different colors", () {
      // Given
      const model1 = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: "#0000FF",
        background: "#FFFFFF",
        surface: "#F0F0F0",
      );
      const model2 = PageBuilderGlobalColorsModel(
        primary: "#0000FF",
        secondary: "#00FF00",
        tertiary: "#0000FF",
        background: "#FFFFFF",
        surface: "#F0F0F0",
      );
      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value equality works for empty models", () {
      // Given
      const model1 = PageBuilderGlobalColorsModel(
        primary: null,
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const model2 = PageBuilderGlobalColorsModel(
        primary: null,
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      // Then
      expect(model1, model2);
    });
  });
}
