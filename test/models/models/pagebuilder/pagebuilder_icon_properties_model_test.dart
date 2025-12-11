import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_icon_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderIconPropertiesModel_CopyWith", () {
    test("set code with copyWith should set code for resulting object", () {
      // Given
      const model = PageBuilderIconPropertiesModel(
          code: "25A",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FF000000");
      const expectedResult = PageBuilderIconPropertiesModel(
          code: "25B",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FF000000");
      // When
      final result = model.copyWith(code: "25B");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      const model = PageBuilderIconPropertiesModel(
          code: "25A",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FF000000");
      final expectedResult = {"code": "25A", "size": 24.0, "color": "FF000000"};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {"code": "25A", "size": 24.0, "color": "FF000000"};
      const expectedResult = PageBuilderIconPropertiesModel(
          code: "25A",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FF000000");
      // When
      final result = PageBuilderIconPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderIconPropertiesModel to PagebuilderIconProperties works",
        () {
      // Given
      const model = PageBuilderIconPropertiesModel(
          code: "25A",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FF000000");
      const expectedResult = PageBuilderIconProperties(
          code: "25A",
          size: PagebuilderResponsiveOrConstant.constant(24.0),
          color: Colors.black);
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderIconProperties to PagebuilderIconPropertiesModel works",
        () {
      // Given
      const model = PageBuilderIconProperties(
          code: "25A",
          size: PagebuilderResponsiveOrConstant.constant(24.0),
          color: Colors.black);
      const expectedResult = PageBuilderIconPropertiesModel(
          code: "25A",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FF000000");
      // When
      final result = PageBuilderIconPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_GlobalStyles", () {
    test("check if color token is resolved with globalStyles in toDomain", () {
      // Given
      const model = PageBuilderIconPropertiesModel(
          code: "E88A",
          size: PagebuilderResponsiveOrConstantModel.constant(32.0),
          color: "@primary");
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
      expect(result.code, "E88A");
    });

    test("check if secondary color token is resolved with globalStyles in toDomain", () {
      // Given
      const model = PageBuilderIconPropertiesModel(
          code: "E001",
          size: PagebuilderResponsiveOrConstantModel.constant(48.0),
          color: "@secondary");
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
      const model = PageBuilderIconPropertiesModel(
          code: "E002",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FFFF5722");
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
      const domainProperties = PageBuilderIconProperties(
          code: "E88A",
          size: PagebuilderResponsiveOrConstant.constant(32.0),
          color: Color(0xFFFF5722),
          globalColorToken: "@primary");
      // When
      final result = PageBuilderIconPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.color, "@primary");
    });

    test("check if conversion from domain without token uses hex color in fromDomain", () {
      // Given
      const domainProperties = PageBuilderIconProperties(
          code: "E88A",
          size: PagebuilderResponsiveOrConstant.constant(32.0),
          color: Color(0xFFFF5722),
          globalColorToken: null);
      // When
      final result = PageBuilderIconPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.color, "FFFF5722");
    });
  });

  group("PagebuilderIconPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      const properties1 = PageBuilderIconPropertiesModel(
          code: "25A",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FF000000");
      const properties2 = PageBuilderIconPropertiesModel(
          code: "25A",
          size: PagebuilderResponsiveOrConstantModel.constant(24.0),
          color: "FF000000");
      // Then
      expect(properties1, properties2);
    });
  });
}
