import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_shadow_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderShadowModel_CopyWith", () {
    test(
        "set blurRadius with copyWith should set blurRadius for resulting object",
        () {
      // Given
      final model = PageBuilderShadowModel(
          color: "FF000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      final expectedResult = PageBuilderShadowModel(
          color: "FF000000",
          spreadRadius: 2.0,
          blurRadius: 5.0,
          offset: {"y": 5.0, "x": 2.0});
      // When
      final result = model.copyWith(blurRadius: 5.0);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderShadowModel(
          color: "FF000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      final expectedResult = {
        "color": "FF000000",
        "spreadRadius": 2.0,
        "blurRadius": 2.0,
        "offset": {"y": 5.0, "x": 2.0}
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "color": "FF000000",
        "spreadRadius": 2.0,
        "blurRadius": 2.0,
        "offset": {"y": 5.0, "x": 2.0}
      };
      final expectedResult = PageBuilderShadowModel(
          color: "FF000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      // When
      final result = PageBuilderShadowModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderShadowModel to PagebuilderShadow works",
        () {
      // Given
      final model = PageBuilderShadowModel(
          color: "FF000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      final expectedResult = PageBuilderShadow(
          color: Colors.black,
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: Offset(2.0, 5.0));
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_GlobalStyles", () {
    test("check if color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderShadowModel(
          color: "@primary",
          spreadRadius: 2.0,
          blurRadius: 4.0,
          offset: {"y": 3.0, "x": 3.0});
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.color, Color(0xFFFF5722));
      expect(result.globalColorToken, "@primary");
      expect(result.spreadRadius, 2.0);
      expect(result.blurRadius, 4.0);
    });

    test("check if secondary color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderShadowModel(
          color: "@secondary",
          spreadRadius: 1.0,
          blurRadius: 2.0,
          offset: {"y": 1.0, "x": 1.0});
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: Color(0xFF2196F3),
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.color, Color(0xFF2196F3));
      expect(result.globalColorToken, "@secondary");
    });

    test("check if hex color does not create token even with globalStyles present", () {
      // Given
      final model = PageBuilderShadowModel(
          color: "FFFF5722",
          spreadRadius: 2.0,
          blurRadius: 4.0,
          offset: {"y": 2.0, "x": 2.0});
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.color, Color(0xFFFF5722));
      expect(result.globalColorToken, null);
    });

    test("check if conversion from domain with token preserves token in fromDomain", () {
      // Given
      final domainShadow = PageBuilderShadow(
          color: Color(0xFFFF5722),
          globalColorToken: "@primary",
          spreadRadius: 2.0,
          blurRadius: 4.0,
          offset: Offset(3.0, 3.0));
      // When
      final result = PageBuilderShadowModel.fromDomain(domainShadow);
      // Then
      expect(result.color, "@primary");
    });

    test("check if conversion from domain without token uses hex color in fromDomain", () {
      // Given
      final domainShadow = PageBuilderShadow(
          color: Color(0xFFFF5722),
          globalColorToken: null,
          spreadRadius: 2.0,
          blurRadius: 4.0,
          offset: Offset(3.0, 3.0));
      // When
      final result = PageBuilderShadowModel.fromDomain(domainShadow);
      // Then
      expect(result.color, "FFFF5722");
    });

    test("check if null color is handled correctly with globalStyles", () {
      // Given
      final model = PageBuilderShadowModel(
          color: null,
          spreadRadius: 2.0,
          blurRadius: 4.0,
          offset: {"y": 2.0, "x": 2.0});
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.color, null);
      expect(result.globalColorToken, null);
    });
  });

  group("PagebuilderShadowModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderShadow to PagebuilderShadowModel works",
        () {
      // Given
      final model = PageBuilderShadow(
          color: Colors.black,
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: Offset(2.0, 5.0));
      final expectedResult = PageBuilderShadowModel(
          color: "FF000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      // When
      final result = PageBuilderShadowModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderShadowModel(
          color: "FF000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      final properties2 = PageBuilderShadowModel(
          color: "FF000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      // Then
      expect(properties1, properties2);
    });
  });
}
