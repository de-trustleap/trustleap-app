import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_paint_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderPaintModel_CopyWith", () {
    test("set color with copyWith should set color for resulting object", () {
      // Given
      const model = PagebuilderPaintModel(color: "FF0000FF");
      const expectedResult = PagebuilderPaintModel(color: "FFFF0000");
      // When
      final result = model.copyWith(color: "FFFF0000");
      // Then
      expect(result, expectedResult);
    });

    test("set gradient with copyWith should set gradient for resulting object", () {
      // Given
      const model = PagebuilderPaintModel(color: "FF0000FF");
      final gradientMap = {
        "type": "linear",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": 0.0},
        "end": {"x": 1.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final expectedResult = PagebuilderPaintModel(color: "FF0000FF", gradient: gradientMap);
      // When
      final result = model.copyWith(gradient: gradientMap);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPaintModel_ToMap", () {
    test("check if color model is successfully converted to a map", () {
      // Given
      const model = PagebuilderPaintModel(color: "FF0000FF");
      final expectedResult = {
        "color": "FF0000FF",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if gradient model is successfully converted to a map", () {
      // Given
      final gradientMap = {
        "type": "linear",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": 0.0},
        "end": {"x": 1.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final model = PagebuilderPaintModel(gradient: gradientMap);
      final expectedResult = {
        "gradient": gradientMap,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if empty model is successfully converted to empty map", () {
      // Given
      const model = PagebuilderPaintModel();
      const expectedResult = <String, dynamic>{};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPaintModel_FromMap", () {
    test("check if map with color is successfully converted to model", () {
      // Given
      final map = {
        "color": "FF0000FF",
      };
      const expectedResult = PagebuilderPaintModel(color: "FF0000FF");
      // When
      final result = PagebuilderPaintModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with gradient is successfully converted to model", () {
      // Given
      final gradientMap = {
        "type": "linear",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": 0.0},
        "end": {"x": 1.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final map = {
        "gradient": gradientMap,
      };
      final expectedResult = PagebuilderPaintModel(gradient: gradientMap);
      // When
      final result = PagebuilderPaintModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if empty map is successfully converted to empty model", () {
      // Given
      final map = <String, dynamic>{};
      const expectedResult = PagebuilderPaintModel();
      // When
      final result = PagebuilderPaintModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with both color and gradient only processes existing values", () {
      // Given
      final gradientMap = {
        "type": "radial",
        "stops": [
          {"color": "FF00FF00", "position": 0.0},
          {"color": "FFFFFF00", "position": 1.0},
        ],
        "begin": {"x": 0.0, "y": 0.0},
        "end": {"x": 0.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.7,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final map = {
        "color": "FF0000FF",
        "gradient": gradientMap,
      };
      final expectedResult = PagebuilderPaintModel(
        color: "FF0000FF",
        gradient: gradientMap,
      );
      // When
      final result = PagebuilderPaintModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPaintModel_ToDomain", () {
    test("check if conversion from color model to color paint works", () {
      // Given
      const model = PagebuilderPaintModel(color: "FF0000FF");
      const expectedResult = PagebuilderPaint.color(Color(0xFF0000FF));
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from gradient model to gradient paint works", () {
      // Given
      final gradientMap = {
        "type": "linear",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": -1.0},
        "end": {"x": 1.0, "y": 1.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final model = PagebuilderPaintModel(gradient: gradientMap);
      final expectedGradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        center: Alignment.center,
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final expectedResult = PagebuilderPaint.gradient(expectedGradient);
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from empty model returns transparent color", () {
      // Given
      const model = PagebuilderPaintModel();
      const expectedResult = PagebuilderPaint.color(Colors.transparent);
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion prioritizes color over gradient when both are set", () {
      // Given
      final gradientMap = {
        "type": "linear",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": 0.0},
        "end": {"x": 1.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final model = PagebuilderPaintModel(
        color: "FF00FF00",
        gradient: gradientMap,
      );
      const expectedResult = PagebuilderPaint.color(Color(0xFF00FF00));
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });

    test("check if token color is resolved with globalStyles", () {
      // Given
      const model = PagebuilderPaintModel(color: "@primary");
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
      final expectedResult = PagebuilderPaint.color(
        Color(0xFFFF5722),
        globalColorToken: "@primary",
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.color, expectedResult.color);
      expect(result.globalColorToken, "@primary");
    });

    test("check if token is preserved and color is resolved correctly", () {
      // Given
      const model = PagebuilderPaintModel(color: "@secondary");
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: Color(0xFF4CAF50),
          tertiary: Color(0xFF2196F3),
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.color, Color(0xFF4CAF50));
      expect(result.globalColorToken, "@secondary");
    });

    test("check if hex color does not create token", () {
      // Given
      const model = PagebuilderPaintModel(color: "FFFF5722");
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
      expect(result.globalColorToken, null); // Should NOT have a token
    });
  });

  group("PagebuilderPaintModel_FromDomain", () {
    test("check if conversion from color paint to color model works", () {
      // Given
      const domainPaint = PagebuilderPaint.color(Color(0xFF0000FF));
      const expectedResult = PagebuilderPaintModel(color: "FF0000FF");
      // When
      final result = PagebuilderPaintModel.fromDomain(domainPaint);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from gradient paint to gradient model works", () {
      // Given
      final domainGradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        center: Alignment.center,
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final domainPaint = PagebuilderPaint.gradient(domainGradient);
      final expectedResult = PagebuilderPaintModel(
        color: null,
        gradient: {
          "type": "linear",
          "stops": [
            {"color": "FF0000FF", "position": 0.0},
            {"color": "FFFF0000", "position": 1.0},
          ],
          "begin": {"x": -1.0, "y": -1.0},
          "end": {"x": 1.0, "y": 1.0},
          "center": {"x": 0.0, "y": 0.0},
          "radius": 0.5,
          "startAngle": 0.0,
          "endAngle": 6.283185307179586,
        },
      );
      // When
      final result = PagebuilderPaintModel.fromDomain(domainPaint);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from radial gradient paint works", () {
      // Given
      final domainGradient = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF00FF00), position: 0.2),
          PagebuilderGradientStop(color: Color(0xFFFFFF00), position: 0.8),
        ],
        begin: Alignment.center,
        end: Alignment.center,
        center: Alignment.topCenter,
        radius: 0.7,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final domainPaint = PagebuilderPaint.gradient(domainGradient);
      final expectedResult = PagebuilderPaintModel(
        color: null,
        gradient: {
          "type": "radial",
          "stops": [
            {"color": "FF00FF00", "position": 0.2},
            {"color": "FFFFFF00", "position": 0.8},
          ],
          "begin": {"x": 0.0, "y": 0.0},
          "end": {"x": 0.0, "y": 0.0},
          "center": {"x": 0.0, "y": -1.0},
          "radius": 0.7,
          "startAngle": 0.0,
          "endAngle": 6.283185307179586,
        },
      );
      // When
      final result = PagebuilderPaintModel.fromDomain(domainPaint);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from sweep gradient paint works", () {
      // Given
      final domainGradient = PagebuilderGradient(
        type: PagebuilderGradientType.sweep,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF800080), position: 0.1),
          PagebuilderGradientStop(color: Color(0xFFFFA500), position: 0.9),
        ],
        begin: Alignment.center,
        end: Alignment.center,
        center: Alignment.bottomLeft,
        radius: 0.5,
        startAngle: 1.0,
        endAngle: 5.0,
      );
      final domainPaint = PagebuilderPaint.gradient(domainGradient);
      final expectedResult = PagebuilderPaintModel(
        color: null,
        gradient: {
          "type": "sweep",
          "stops": [
            {"color": "FF800080", "position": 0.1},
            {"color": "FFFFA500", "position": 0.9},
          ],
          "begin": {"x": 0.0, "y": 0.0},
          "end": {"x": 0.0, "y": 0.0},
          "center": {"x": -1.0, "y": 1.0},
          "radius": 0.5,
          "startAngle": 1.0,
          "endAngle": 5.0,
        },
      );
      // When
      final result = PagebuilderPaintModel.fromDomain(domainPaint);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from empty paint returns transparent model", () {
      // Given
      const domainPaint = PagebuilderPaint();
      const expectedResult = PagebuilderPaintModel(color: "00000000");
      // When
      final result = PagebuilderPaintModel.fromDomain(domainPaint);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from paint with token preserves token", () {
      // Given
      const domainPaint = PagebuilderPaint.color(
        Color(0xFFFF5722),
        globalColorToken: "@primary",
      );
      const expectedResult = PagebuilderPaintModel(color: "@primary");
      // When
      final result = PagebuilderPaintModel.fromDomain(domainPaint);
      // Then
      expect(result.color, "@primary");
    });

    test("check if conversion from paint without token uses hex", () {
      // Given
      const domainPaint = PagebuilderPaint.color(
        Color(0xFFFF5722),
        globalColorToken: null,
      );
      const expectedResult = PagebuilderPaintModel(color: "FFFF5722");
      // When
      final result = PagebuilderPaintModel.fromDomain(domainPaint);
      // Then
      expect(result.color, "FFFF5722");
    });
  });

  group("PagebuilderPaintModel_Props", () {
    test("check if value equality works for color models", () {
      // Given
      const model1 = PagebuilderPaintModel(color: "FF0000FF");
      const model2 = PagebuilderPaintModel(color: "FF0000FF");
      // Then
      expect(model1, model2);
    });

    test("check if value equality works for gradient models", () {
      // Given
      final gradientMap = {
        "type": "linear",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": 0.0},
        "end": {"x": 1.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final model1 = PagebuilderPaintModel(gradient: gradientMap);
      final model2 = PagebuilderPaintModel(gradient: gradientMap);
      // Then
      expect(model1, model2);
    });

    test("check if value inequality works for different colors", () {
      // Given
      const model1 = PagebuilderPaintModel(color: "FF0000FF");
      const model2 = PagebuilderPaintModel(color: "FFFF0000");
      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value inequality works for different gradients", () {
      // Given
      final gradientMap1 = {
        "type": "linear",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": 0.0},
        "end": {"x": 1.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final gradientMap2 = {
        "type": "radial",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": 0.0},
        "end": {"x": 1.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final model1 = PagebuilderPaintModel(gradient: gradientMap1);
      final model2 = PagebuilderPaintModel(gradient: gradientMap2);
      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value inequality works between color and gradient models", () {
      // Given
      const colorModel = PagebuilderPaintModel(color: "FF0000FF");
      final gradientMap = {
        "type": "linear",
        "stops": [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        "begin": {"x": -1.0, "y": 0.0},
        "end": {"x": 1.0, "y": 0.0},
        "center": {"x": 0.0, "y": 0.0},
        "radius": 0.5,
        "startAngle": 0.0,
        "endAngle": 6.283185307179586,
      };
      final gradientModel = PagebuilderPaintModel(gradient: gradientMap);
      // Then
      expect(colorModel, isNot(equals(gradientModel)));
    });

    test("check if value equality works for empty models", () {
      // Given
      const model1 = PagebuilderPaintModel();
      const model2 = PagebuilderPaintModel();
      // Then
      expect(model1, model2);
    });
  });
}