import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/helpers/pagebuilder_global_styles_reverse_resolver.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderGlobalStylesReverseResolver", () {
    const globalStyles = PageBuilderGlobalStyles(
      colors: PageBuilderGlobalColors(
        primary: Color(0xFFFF5722),
        secondary: Color(0xFF2196F3),
        tertiary: Color(0xFF4CAF50),
        background: Color(0xFFF5F5F5),
        surface: Color(0xFFFFFFFF),
      ),
      fonts: null,
    );

    late PagebuilderGlobalStylesReverseResolver resolver;

    setUp(() {
      resolver = PagebuilderGlobalStylesReverseResolver(globalStyles);
    });

    group("applyTokensToMap_SimpleColors", () {
      test("should convert primary color hex to @primary token", () {
        // Given
        final map = {
          "color": "FFFF5722", // primary color
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@primary");
      });

      test("should convert secondary color hex to @secondary token", () {
        // Given
        final map = {
          "color": "FF2196F3", // secondary color
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@secondary");
      });

      test("should convert tertiary color hex to @tertiary token", () {
        // Given
        final map = {
          "color": "FF4CAF50", // tertiary color
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@tertiary");
      });

      test("should convert background color hex to @background token", () {
        // Given
        final map = {
          "backgroundColor": "FFF5F5F5", // background color
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["backgroundColor"], "@background");
      });

      test("should convert surface color hex to @surface token", () {
        // Given
        final map = {
          "color": "FFFFFFFF", // surface color
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@surface");
      });

      test("should keep hex color unchanged if it doesn't match any global style", () {
        // Given
        final map = {
          "color": "FF123456", // not a global style color
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "FF123456");
      });

      test("should handle 6-digit hex colors (add FF alpha)", () {
        // Given
        final map = {
          "color": "FF5722", // 6-digit hex, should match primary
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@primary");
      });

      test("should handle hex colors with # prefix", () {
        // Given
        final map = {
          "color": "#FFFF5722", // with # prefix
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@primary");
      });

      test("should handle 7-character hex with # prefix (6 digits + #)", () {
        // Given
        final map = {
          "color": "#FF5722", // 7 chars with #
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@primary");
      });
    });

    group("applyTokensToMap_FieldNames", () {
      test("should convert color in textColor field", () {
        // Given
        final map = {
          "textColor": "FFFF5722", // primary color
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["textColor"], "@primary");
      });

      test("should convert color in primaryColor field", () {
        // Given
        final map = {
          "primaryColor": "FF2196F3", // secondary color
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["primaryColor"], "@secondary");
      });

      test("should NOT convert hex in non-color fields", () {
        // Given
        final map = {
          "id": "FFFF5722", // not a color field
          "name": "FF2196F3", // not a color field
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["id"], "FFFF5722"); // unchanged
        expect(result["name"], "FF2196F3"); // unchanged
      });
    });

    group("applyTokensToMap_NestedStructures", () {
      test("should convert colors in nested maps", () {
        // Given
        final map = {
          "widget": {
            "properties": {
              "color": "FFFF5722", // primary
            }
          }
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["widget"]["properties"]["color"], "@primary");
      });

      test("should convert colors in lists of maps", () {
        // Given
        final map = {
          "widgets": [
            {"color": "FFFF5722"}, // primary
            {"color": "FF2196F3"}, // secondary
          ]
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["widgets"][0]["color"], "@primary");
        expect(result["widgets"][1]["color"], "@secondary");
      });

      test("should convert colors in deeply nested structures", () {
        // Given
        final map = {
          "sections": [
            {
              "widgets": [
                {
                  "properties": {
                    "color": "FFFF5722", // primary
                    "backgroundColor": "FF2196F3", // secondary
                  }
                }
              ]
            }
          ]
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["sections"][0]["widgets"][0]["properties"]["color"], "@primary");
        expect(result["sections"][0]["widgets"][0]["properties"]["backgroundColor"], "@secondary");
      });

      test("should handle mixed color and non-color fields in nested structures", () {
        // Given
        final map = {
          "widget": {
            "id": "widget1",
            "type": "text",
            "properties": {
              "text": "Hello",
              "color": "FFFF5722", // primary
              "fontSize": 16,
            }
          }
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["widget"]["id"], "widget1");
        expect(result["widget"]["type"], "text");
        expect(result["widget"]["properties"]["text"], "Hello");
        expect(result["widget"]["properties"]["color"], "@primary");
        expect(result["widget"]["properties"]["fontSize"], 16);
      });
    });

    group("applyTokensToMap_EdgeCases", () {
      test("should handle empty map", () {
        // Given
        final map = <String, dynamic>{};
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result, <String, dynamic>{});
      });

      test("should handle map with null values", () {
        // Given
        final map = {
          "color": null,
          "backgroundColor": null,
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], null);
        expect(result["backgroundColor"], null);
      });

      test("should handle map with non-string color values", () {
        // Given
        final map = {
          "color": 12345, // number, not string
          "backgroundColor": true, // boolean, not string
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], 12345);
        expect(result["backgroundColor"], true);
      });

      test("should preserve already tokenized colors", () {
        // Given
        final map = {
          "color": "@primary",
          "backgroundColor": "@secondary",
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@primary");
        expect(result["backgroundColor"], "@secondary");
      });

      test("should handle empty lists", () {
        // Given
        final map = {
          "widgets": <dynamic>[],
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["widgets"], <dynamic>[]);
      });

      test("should handle nested empty maps", () {
        // Given
        final map = {
          "widget": <String, dynamic>{},
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["widget"], <String, dynamic>{});
      });
    });

    group("applyTokensToMap_NoGlobalColors", () {
      test("should keep hex colors unchanged when globalStyles has no colors", () {
        // Given
        const emptyGlobalStyles = PageBuilderGlobalStyles(
          colors: null,
          fonts: null,
        );
        final emptyResolver = PagebuilderGlobalStylesReverseResolver(emptyGlobalStyles);
        final map = {
          "color": "FFFF5722",
        };
        // When
        final result = emptyResolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "FFFF5722");
      });

      test("should keep hex colors unchanged when global color is null", () {
        // Given
        const partialGlobalStyles = PageBuilderGlobalStyles(
          colors: PageBuilderGlobalColors(
            primary: Color(0xFFFF5722),
            secondary: null, // null
            tertiary: null,
            background: null,
            surface: null,
          ),
          fonts: null,
        );
        final partialResolver = PagebuilderGlobalStylesReverseResolver(partialGlobalStyles);
        final map = {
          "color": "FF2196F3", // would be secondary, but secondary is null
        };
        // When
        final result = partialResolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "FF2196F3");
      });
    });

    group("applyTokensToMap_CaseInsensitivity", () {
      test("should handle lowercase field names", () {
        // Given
        final map = {
          "color": "FFFF5722",
          "backgroundcolor": "FF2196F3",
          "textcolor": "FF4CAF50",
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["color"], "@primary");
        expect(result["backgroundcolor"], "@secondary");
        expect(result["textcolor"], "@tertiary");
      });

      test("should handle uppercase field names", () {
        // Given
        final map = {
          "COLOR": "FFFF5722",
          "BACKGROUNDCOLOR": "FF2196F3",
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["COLOR"], "@primary");
        expect(result["BACKGROUNDCOLOR"], "@secondary");
      });

      test("should handle mixed case field names", () {
        // Given
        final map = {
          "Color": "FFFF5722",
          "BackgroundColor": "FF2196F3",
          "textColor": "FF4CAF50",
        };
        // When
        final result = resolver.applyTokensToMap(map);
        // Then
        expect(result["Color"], "@primary");
        expect(result["BackgroundColor"], "@secondary");
        expect(result["textColor"], "@tertiary");
      });
    });
  });
}
