import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_container_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderContainerPropertiesModel_CopyWith", () {
    test("set shadow with copyWith should set shadow for resulting object", () {
      // Given
      final model = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          shadow: {
            "color": "FF000000",
            "spreadRadius": 2,
            "blurRadius": 1,
            "offset": {"x": 5, "y": 5}
          },
          width: null,
          height: null);
      final expectedResult = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          shadow: {
            "color": "FF000000",
            "spreadRadius": 5,
            "blurRadius": 5,
            "offset": {"x": 5, "y": 6}
          },
          width: null,
          height: null);
      // When
      final result = model.copyWith(shadow: {
        "color": "FF000000",
        "spreadRadius": 5,
        "blurRadius": 5,
        "offset": {"x": 5, "y": 6}
      });
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          shadow: {
            "color": "FF000000",
            "spreadRadius": 2,
            "blurRadius": 1,
            "offset": {"x": 5, "y": 5}
          },
          width: null,
          height: null);
      final expectedResult = {
        "border": {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
        "shadow": {
          "color": "FF000000",
          "spreadRadius": 2,
          "blurRadius": 1,
          "offset": {"x": 5, "y": 5}
        }
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "border": {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
        "shadow": {
          "color": "FF000000",
          "spreadRadius": 2,
          "blurRadius": 1,
          "offset": {"x": 5, "y": 5}
        }
      };
      final expectedResult = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          shadow: {
            "color": "FF000000",
            "spreadRadius": 2,
            "blurRadius": 1,
            "offset": {"x": 5, "y": 5}
          },
          width: null,
          height: null);
      // When
      final result = PageBuilderContainerPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderContainerPropertiesModel to PagebuilderContainerProperties works",
        () {
      // Given
      final model = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          shadow: {
            "color": "FF000000",
            "spreadRadius": 2.0,
            "blurRadius": 1.0,
            "offset": {"x": 5.0, "y": 5.0}
          },
          width: null,
          height: null);
      final expectedResult = PageBuilderContainerProperties(
          border: PagebuilderBorder(radius: 12.0, width: 2.0, color: Color(0xFFFF6B00)),
          shadow: PageBuilderShadow(
              color: Color(0xFF000000),
              spreadRadius: 2,
              blurRadius: 1,
              offset: Offset(5, 5)),
          width: null,
          height: null);
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderContainerProperties to PagebuilderContainerPropertiesModel works",
        () {
      // Given
      final model = PageBuilderContainerProperties(
          border: PagebuilderBorder(radius: 12.0, width: 2.0, color: Color(0xFFFF6B00)),
          shadow: PageBuilderShadow(
              color: Color(0xFF000000),
              spreadRadius: 2,
              blurRadius: 1,
              offset: Offset(5, 5)),
          width: null,
          height: null);
      final expectedResult = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          shadow: {
            "color": "FF000000",
            "spreadRadius": 2.0,
            "blurRadius": 1.0,
            "offset": {"x": 5.0, "y": 5.0}
          },
          width: null,
          height: null);
      // When
      final result = PageBuilderContainerPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_GlobalStyles", () {
    test("check if border color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "@primary"},
          shadow: null,
          width: null,
          height: null);
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
      expect(result.border?.color, Color(0xFFFF5722));
      expect(result.border?.globalColorToken, "@primary");
    });

    test("check if shadow color token is resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderContainerPropertiesModel(
          border: null,
          shadow: {
            "color": "@secondary",
            "spreadRadius": 2.0,
            "blurRadius": 4.0,
            "offset": {"x": 2.0, "y": 2.0}
          },
          width: null,
          height: null);
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
      expect(result.shadow?.color, Color(0xFF2196F3));
      expect(result.shadow?.globalColorToken, "@secondary");
    });

    test("check if both border and shadow color tokens are resolved with globalStyles in toDomain", () {
      // Given
      final model = PageBuilderContainerPropertiesModel(
          border: {"radius": 8.0, "width": 1.0, "color": "@primary"},
          shadow: {
            "color": "@secondary",
            "spreadRadius": 1.0,
            "blurRadius": 3.0,
            "offset": {"x": 1.0, "y": 1.0}
          },
          width: null,
          height: null);
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
      expect(result.border?.color, Color(0xFFFF5722));
      expect(result.border?.globalColorToken, "@primary");
      expect(result.shadow?.color, Color(0xFF2196F3));
      expect(result.shadow?.globalColorToken, "@secondary");
    });

    test("check if hex colors do not create tokens even with globalStyles present", () {
      // Given
      final model = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF5722"},
          shadow: {
            "color": "FF2196F3",
            "spreadRadius": 2.0,
            "blurRadius": 1.0,
            "offset": {"x": 5.0, "y": 5.0}
          },
          width: null,
          height: null);
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
      expect(result.border?.color, Color(0xFFFF5722));
      expect(result.border?.globalColorToken, null);
      expect(result.shadow?.color, Color(0xFF2196F3));
      expect(result.shadow?.globalColorToken, null);
    });

    test("check if conversion from domain with tokens preserves tokens in fromDomain", () {
      // Given
      final domainProperties = PageBuilderContainerProperties(
          border: PagebuilderBorder(
            radius: 12.0,
            width: 2.0,
            color: Color(0xFFFF5722),
            globalColorToken: "@primary",
          ),
          shadow: PageBuilderShadow(
            color: Color(0xFF2196F3),
            globalColorToken: "@secondary",
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(5, 5),
          ),
          width: null,
          height: null);
      // When
      final result = PageBuilderContainerPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.border?["color"], "@primary");
      expect(result.shadow?["color"], "@secondary");
    });
  });

  group("PagebuilderContainerPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          shadow: {
            "color": "FF000000",
            "spreadRadius": 2.0,
            "blurRadius": 1.0,
            "offset": {"x": 5.0, "y": 5.0}
          },
          width: null,
          height: null);
      final properties2 = PageBuilderContainerPropertiesModel(
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          shadow: {
            "color": "FF000000",
            "spreadRadius": 2.0,
            "blurRadius": 1.0,
            "offset": {"x": 5.0, "y": 5.0}
          },
          width: null,
          height: null);
      // Then
      expect(properties1, properties2);
    });
  });
}
