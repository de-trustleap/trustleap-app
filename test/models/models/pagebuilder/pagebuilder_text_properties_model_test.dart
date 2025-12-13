import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderTextPropertiesModel_CopyWith", () {
    test(
        "set lineHeight with copyWith should set lineHeight for resulting object",
        () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.2),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      // When
      final result = model.copyWith(lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.2));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      final expectedResult = {
        "text": "Test",
        "fontSize": 20.0,
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "FF000000",
        "alignment": "center"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "text": "Test",
        "fontSize": 20.0,
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "FF000000",
        "alignment": "center"
      };
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      // When
      final result = PageBuilderTextPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderTextPropertiesModel to PagebuilderTextProperties works",
        () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      final expectedResult = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center));
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderTextProperties to PagebuilderTextPropertiesModel works",
        () {
      // Given
      final model = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center));
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      // When
      final result = PageBuilderTextPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_GlobalStyles", () {
    test("check if color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "@primary",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
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
      final expectedResult = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Color(0xFFFF5722),
          globalColorToken: "@primary",
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center));
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.color, expectedResult.color);
      expect(result.globalColorToken, expectedResult.globalColorToken);
      expect(result.text, expectedResult.text);
    });

    test("check if secondary color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(16.0),
          fontFamily: "Roboto",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.2),
          letterSpacing: null,
          textShadow: null,
          color: "@secondary",
          alignment: PagebuilderResponsiveOrConstantModel.constant("left"));
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
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FFFF5722",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
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
      final domainProperties = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Color(0xFFFF5722),
          globalColorToken: "@primary",
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center));
      // When
      final result = PageBuilderTextPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.color, "@primary");
    });

    test("check if conversion from domain without token uses hex color in fromDomain", () {
      // Given
      final domainProperties = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Color(0xFFFF5722),
          globalColorToken: null,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center));
      // When
      final result = PageBuilderTextPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.color, "FFFF5722");
    });

    test("check if headline font token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "@headline",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: PageBuilderGlobalFonts(
          headline: "Merriweather",
          text: "Roboto",
        ),
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.fontFamily, "Merriweather");
    });

    test("check if text font token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "@text",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: PageBuilderGlobalFonts(
          headline: "Merriweather",
          text: "Poppins",
        ),
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.fontFamily, "Poppins");
    });

    test("check if font token falls back to Roboto when token cannot be resolved", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "@headline",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.fontFamily, "Roboto");
    });

    test("check if direct font name works without token resolution", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: PageBuilderGlobalFonts(
          headline: "Merriweather",
          text: "Roboto",
        ),
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.fontFamily, "Poppins");
    });

    test("check if font token is preserved in model when using direct font", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "@headline",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      // When - toDomain and back to model
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: PageBuilderGlobalFonts(
          headline: "Merriweather",
          text: "Roboto",
        ),
      );
      final domainResult = model.toDomain(globalStyles);
      // Then - fontFamily should be resolved in domain
      expect(domainResult.fontFamily, "Merriweather");
      // And - the original model should still have the token
      expect(model.fontFamily, "@headline");
    });

    test("check if globalFontToken is stored when toDomain converts font token", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "@headline",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: PageBuilderGlobalFonts(
          headline: "Merriweather",
          text: "Roboto",
        ),
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.globalFontToken, "@headline");
      expect(result.fontFamily, "Merriweather");
    });

    test("check if conversion from domain with font token preserves token in fromDomain", () {
      // Given
      final domainProperties = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Merriweather",
          globalFontToken: "@headline",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center));
      // When
      final result = PageBuilderTextPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.fontFamily, "@headline");
    });

    test("check if conversion from domain without font token uses direct font in fromDomain", () {
      // Given
      final domainProperties = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          globalFontToken: null,
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center));
      // When
      final result = PageBuilderTextPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.fontFamily, "Poppins");
    });
  });

  group("PagebuilderTextPropertiesModel_GetTextAlignFromString", () {
    test("check if returns correct text align from string", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      final alignment = "right";
      final expectedResult = TextAlign.right;
      // When
      final result = model.getTextAlignFromString(alignment);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      final properties2 = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      // Then
      expect(properties1, properties2);
    });
  });

  group("PagebuilderTextPropertiesModel_Responsive", () {
    test("should handle responsive fontSize in toMap", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": 14.0,
            "tablet": 16.0,
            "desktop": 20.0
          }),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      final expectedResult = {
        "text": "Test",
        "fontSize": {
          "mobile": 14.0,
          "tablet": 16.0,
          "desktop": 20.0
        },
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "FF000000",
        "alignment": "center"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("should handle responsive fontSize in fromMap", () {
      // Given
      final map = {
        "text": "Test",
        "fontSize": {
          "mobile": 14.0,
          "tablet": 16.0,
          "desktop": 20.0
        },
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "FF000000",
        "alignment": "center"
      };
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": 14.0,
            "tablet": 16.0,
            "desktop": 20.0
          }),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));
      // When
      final result = PageBuilderTextPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("should handle responsive alignment in toDomain", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": "left",
            "tablet": "center",
            "desktop": "right"
          }));
      final expectedResult = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.responsive({
            "mobile": TextAlign.left,
            "tablet": TextAlign.center,
            "desktop": TextAlign.right
          }));
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });

    test("should handle responsive alignment in fromDomain", () {
      // Given
      final model = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.responsive({
            "mobile": TextAlign.left,
            "tablet": TextAlign.center,
            "desktop": TextAlign.right
          }));
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": "left",
            "tablet": "center",
            "desktop": "right"
          }));
      // When
      final result = PageBuilderTextPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });

    test("should handle mixed responsive and constant values", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": 12.0,
            "tablet": 14.0,
            "desktop": 16.0
          }),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": 1.2,
            "tablet": 1.4,
            "desktop": 1.6
          }),
          letterSpacing: PagebuilderResponsiveOrConstantModel.constant(0.5),
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"));

      // When - convert to map and back
      final map = model.toMap();
      final result = PageBuilderTextPropertiesModel.fromMap(map);

      // Then
      expect(result, model);
    });
  });
}
