import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';

void main() {
  group("PagebuilderButtonPropertiesModel_CopyWith", () {
    test("set height with copyWith should set height for resulting object", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          backgroundPaint: null,
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(80.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          backgroundPaint: null,
          textProperties: {"text": "Test", "fontSize": 16.0});
      // When
      final result = model.copyWith(height: const PagebuilderResponsiveOrConstantModel.constant(80.0));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = {
        "width": 200.0,
        "height": 60.0,
        "border": {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
        "backgroundPaint": {"color": "FFFFFFFF"},
        "textProperties": {"text": "Test", "fontSize": 16.0}
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "width": 200.0,
        "height": 60.0,
        "border": {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
        "backgroundPaint": {"color": "FFFFFFFF"},
        "textProperties": {"text": "Test", "fontSize": 16.0}
      };
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {"text": "Test", "fontSize": 16.0});
      // When
      final result = PageBuilderButtonPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderButtonPropertiesModel to PagebuilderButtonProperties works",
        () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = PageBuilderButtonProperties(
          width: const PagebuilderResponsiveOrConstant.constant(200.0),
          height: const PagebuilderResponsiveOrConstant.constant(60.0),
          minWidthPercent: null,
          contentPadding: null,
          border: PagebuilderBorder(radius: 12.0, width: 2.0, color: Color(0xFFFF6B00)),
          backgroundPaint: const PagebuilderPaint.color(Colors.white),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: null,
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderButtonProperties to PagebuilderButtonPropertiesModel works",
        () {
      // Given
      final model = PageBuilderButtonProperties(
          width: const PagebuilderResponsiveOrConstant.constant(200.0),
          height: const PagebuilderResponsiveOrConstant.constant(60.0),
          minWidthPercent: null,
          contentPadding: null,
          border: PagebuilderBorder(radius: 12.0, width: 2.0, color: Color(0xFFFF6B00)),
          backgroundPaint: const PagebuilderPaint.color(Colors.white),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: null,
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {
            "text": "Test",
            "fontSize": 16.0,
            "alignment": "left"
          });
      // When
      final result = PageBuilderButtonPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_GlobalStyles", () {
    test("check if background color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: null,
          backgroundPaint: {"color": "@primary"},
          textProperties: {"text": "Click Me", "fontSize": 18.0});
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
      expect(result.backgroundPaint?.color, Color(0xFFFF5722));
      expect(result.backgroundPaint?.globalColorToken, "@primary");
    });

    test("check if border color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "@secondary"},
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {"text": "Click Me", "fontSize": 18.0});
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
      expect(result.border?.color, Color(0xFF2196F3));
      expect(result.border?.globalColorToken, "@secondary");
    });

    test("check if text color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: null,
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {"text": "Click Me", "fontSize": 18.0, "color": "@primary"});
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
      expect(result.textProperties?.color, Color(0xFFFF5722));
      expect(result.textProperties?.globalColorToken, "@primary");
    });

    test("check if multiple color tokens are resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "@primary"},
          backgroundPaint: {"color": "@secondary"},
          textProperties: {"text": "Click Me", "fontSize": 18.0, "color": "@surface"});
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: Color(0xFF2196F3),
          tertiary: null,
          background: null,
          surface: Color(0xFFFFFFFF),
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.border?.color, Color(0xFFFF5722));
      expect(result.border?.globalColorToken, "@primary");
      expect(result.backgroundPaint?.color, Color(0xFF2196F3));
      expect(result.backgroundPaint?.globalColorToken, "@secondary");
      expect(result.textProperties?.color, Color(0xFFFFFFFF));
      expect(result.textProperties?.globalColorToken, "@surface");
    });

    test("check if conversion from domain with tokens preserves tokens in fromDomain", () {
      // Given
      final domainProperties = PageBuilderButtonProperties(
          width: const PagebuilderResponsiveOrConstant.constant(200.0),
          height: const PagebuilderResponsiveOrConstant.constant(60.0),
          minWidthPercent: null,
          contentPadding: null,
          border: PagebuilderBorder(
            radius: 12.0,
            width: 2.0,
            color: Color(0xFFFF5722),
            globalColorToken: "@primary",
          ),
          backgroundPaint: const PagebuilderPaint.color(
            Color(0xFF2196F3),
            globalColorToken: "@secondary",
          ),
          textProperties: PageBuilderTextProperties(
              text: "Click Me",
              fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
              fontFamily: null,
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Color(0xFFFFFFFF),
              globalColorToken: "@surface",
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      // When
      final result = PageBuilderButtonPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.border?["color"], "@primary");
      expect(result.backgroundPaint?["color"], "@secondary");
      expect(result.textProperties?["color"], "@surface");
    });
  });

  group("PagebuilderButtonPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {
            "text": "Test",
            "fontSize": 16.0,
            "alignment": "left"
          });
      final properties2 = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          minWidthPercent: null, contentPadding: null,
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {
            "text": "Test",
            "fontSize": 16.0,
            "alignment": "left"
          });
      // Then
      expect(properties1, properties2);
    });
  });
}
