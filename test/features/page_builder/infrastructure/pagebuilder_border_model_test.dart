import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_border_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_border.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderBorderModel_CopyWith", () {
    test("set width with copyWith should set width for resulting object", () {
      // Given
      final model = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "FFFF6B00",
      );
      final expectedResult = PagebuilderBorderModel(
        width: 5.0,
        radius: 8.0,
        color: "FFFF6B00",
      );
      // When
      final result = model.copyWith(width: 5.0);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderBorderModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "FFFF6B00",
      );
      final expectedResult = {
        "width": 2.0,
        "radius": 8.0,
        "color": "FFFF6B00",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with null values converts correctly to map", () {
      // Given
      final model = PagebuilderBorderModel(
        width: null,
        radius: 8.0,
        color: null,
      );
      final expectedResult = {
        "radius": 8.0,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderBorderModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "width": 2.0,
        "radius": 8.0,
        "color": "FFFF6B00",
      };
      final expectedResult = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "FFFF6B00",
      );
      // When
      final result = PagebuilderBorderModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with missing values converts to model with null values",
        () {
      // Given
      final map = {
        "radius": 8.0,
      };
      final expectedResult = PagebuilderBorderModel(
        width: null,
        radius: 8.0,
        color: null,
      );
      // When
      final result = PagebuilderBorderModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderBorderModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderBorderModel to PagebuilderBorder works",
        () {
      // Given
      final model = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "FFFF6B00",
      );
      final expectedResult = PagebuilderBorder(
        width: 2.0,
        radius: 8.0,
        color: Color(0xFFFF6B00),
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });

    test(
        "check if conversion from PagebuilderBorderModel with null color to PagebuilderBorder works",
        () {
      // Given
      final model = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: null,
      );
      final expectedResult = PagebuilderBorder(
        width: 2.0,
        radius: 8.0,
        color: null,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderBorderModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderBorder to PagebuilderBorderModel works",
        () {
      // Given
      final border = PagebuilderBorder(
        width: 2.0,
        radius: 8.0,
        color: Color(0xFFFF6B00),
      );
      final expectedResult = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "FFFF6B00",
      );
      // When
      final result = PagebuilderBorderModel.fromDomain(border);
      // Then
      expect(result, expectedResult);
    });

    test(
        "check if conversion from PagebuilderBorder with null color to PagebuilderBorderModel works",
        () {
      // Given
      final border = PagebuilderBorder(
        width: 2.0,
        radius: 8.0,
        color: null,
      );
      final expectedResult = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: null,
      );
      // When
      final result = PagebuilderBorderModel.fromDomain(border);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderBorderModel_GlobalStyles", () {
    test("check if color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PagebuilderBorderModel(
        width: 3.0,
        radius: 12.0,
        color: "@primary",
      );
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
      expect(result.width, 3.0);
      expect(result.radius, 12.0);
    });

    test("check if secondary color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "@secondary",
      );
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
      final model = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "FFFF5722",
      );
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
      final domainBorder = PagebuilderBorder(
        width: 3.0,
        radius: 12.0,
        color: Color(0xFFFF5722),
        globalColorToken: "@primary",
      );
      // When
      final result = PagebuilderBorderModel.fromDomain(domainBorder);
      // Then
      expect(result.color, "@primary");
    });

    test("check if conversion from domain without token uses hex color in fromDomain", () {
      // Given
      final domainBorder = PagebuilderBorder(
        width: 3.0,
        radius: 12.0,
        color: Color(0xFFFF5722),
        globalColorToken: null,
      );
      // When
      final result = PagebuilderBorderModel.fromDomain(domainBorder);
      // Then
      expect(result.color, "FFFF5722");
    });

    test("check if null color is handled correctly with globalStyles", () {
      // Given
      final model = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: null,
      );
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

  group("PagebuilderBorderModel_Props", () {
    test("check if value equality works", () {
      // Given
      final border1 = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "FFFF6B00",
      );
      final border2 = PagebuilderBorderModel(
        width: 2.0,
        radius: 8.0,
        color: "FFFF6B00",
      );
      // Then
      expect(border1, border2);
    });
  });
}
