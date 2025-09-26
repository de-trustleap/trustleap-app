import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_gradient_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderGradientStopModel_CopyWith", () {
    test("set color with copyWith should set color for resulting object", () {
      // Given
      const model = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 0.5,
      );
      const expectedResult = PagebuilderGradientStopModel(
        color: "FFFF0000",
        position: 0.5,
      );
      // When
      final result = model.copyWith(color: "FFFF0000");
      // Then
      expect(result, expectedResult);
    });

    test("set position with copyWith should set position for resulting object", () {
      // Given
      const model = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 0.5,
      );
      const expectedResult = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 0.8,
      );
      // When
      final result = model.copyWith(position: 0.8);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientStopModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      const model = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 0.5,
      );
      final expectedResult = {
        "color": "FF0000FF",
        "position": 0.5,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientStopModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "color": "FF0000FF",
        "position": 0.5,
      };
      const expectedResult = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 0.5,
      );
      // When
      final result = PagebuilderGradientStopModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("should handle position as int", () {
      // Given
      final map = {
        "color": "FF0000FF",
        "position": 1,
      };
      const expectedResult = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 1.0,
      );
      // When
      final result = PagebuilderGradientStopModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientStopModel_ToDomain", () {
    test("check if conversion from PagebuilderGradientStopModel to PagebuilderGradientStop works", () {
      // Given
      const model = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 0.5,
      );
      const expectedResult = PagebuilderGradientStop(
        color: Color(0xFF0000FF), // Pure blue, not MaterialColor
        position: 0.5,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientStopModel_FromDomain", () {
    test("check if conversion from PagebuilderGradientStop to PagebuilderGradientStopModel works", () {
      // Given
      const domainStop = PagebuilderGradientStop(
        color: Colors.blue,
        position: 0.5,
      );
      const expectedResult = PagebuilderGradientStopModel(
        color: "FF2196F3",
        position: 0.5,
      );
      // When
      final result = PagebuilderGradientStopModel.fromDomain(domainStop);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientStopModel_Props", () {
    test("check if value equality works", () {
      // Given
      const model1 = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 0.5,
      );
      const model2 = PagebuilderGradientStopModel(
        color: "FF0000FF",
        position: 0.5,
      );
      // Then
      expect(model1, model2);
    });
  });

  group("PagebuilderGradientModel_CopyWith", () {
    test("set type with copyWith should set type for resulting object", () {
      // Given
      final model = PagebuilderGradientModel(
        type: "linear",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final expectedResult = PagebuilderGradientModel(
        type: "radial",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // When
      final result = model.copyWith(type: "radial");
      // Then
      expect(result, expectedResult);
    });

    test("set radius with copyWith should set radius for resulting object", () {
      // Given
      final model = PagebuilderGradientModel(
        type: "radial",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final expectedResult = PagebuilderGradientModel(
        type: "radial",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.8,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // When
      final result = model.copyWith(radius: 0.8);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderGradientModel(
        type: "linear",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final expectedResult = {
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
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
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
      final expectedResult = PagebuilderGradientModel(
        type: "linear",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // When
      final result = PagebuilderGradientModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("should handle numeric values as int", () {
      // Given
      final map = {
        "type": "radial",
        "stops": [
          {"color": "FF0000FF", "position": 0},
          {"color": "FFFF0000", "position": 1},
        ],
        "begin": {"x": -1, "y": 0},
        "end": {"x": 1, "y": 0},
        "center": {"x": 0, "y": 0},
        "radius": 1,
        "startAngle": 0,
        "endAngle": 6,
      };
      final expectedResult = PagebuilderGradientModel(
        type: "radial",
        stops: [
          {"color": "FF0000FF", "position": 0},
          {"color": "FFFF0000", "position": 1},
        ],
        begin: {"x": -1, "y": 0},
        end: {"x": 1, "y": 0},
        center: {"x": 0, "y": 0},
        radius: 1.0,
        startAngle: 0.0,
        endAngle: 6.0,
      );
      // When
      final result = PagebuilderGradientModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientModel_ToDomain", () {
    test("check if conversion from PagebuilderGradientModel to PagebuilderGradient works for linear gradient", () {
      // Given
      final model = PagebuilderGradientModel(
        type: "linear",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": -1.0},
        end: {"x": 1.0, "y": 1.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final expectedResult = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0), // Blue
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0), // Red
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        center: Alignment.center,
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion works for radial gradient", () {
      // Given
      final model = PagebuilderGradientModel(
        type: "radial",
        stops: [
          {"color": "FF00FF00", "position": 0.2},
          {"color": "FFFFFF00", "position": 0.8},
        ],
        begin: {"x": 0.0, "y": 0.0},
        end: {"x": 0.0, "y": 0.0},
        center: {"x": 0.0, "y": -1.0},
        radius: 0.7,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final expectedResult = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF00FF00), position: 0.2), // Green
          PagebuilderGradientStop(color: Color(0xFFFFFF00), position: 0.8), // Yellow
        ],
        begin: Alignment.center,
        end: Alignment.center,
        center: Alignment.topCenter,
        radius: 0.7,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion works for sweep gradient", () {
      // Given
      final model = PagebuilderGradientModel(
        type: "sweep",
        stops: [
          {"color": "FF800080", "position": 0.1},
          {"color": "FFFFA500", "position": 0.9},
        ],
        begin: {"x": 0.0, "y": 0.0},
        end: {"x": 0.0, "y": 0.0},
        center: {"x": -1.0, "y": 1.0},
        radius: 0.5,
        startAngle: 1.0,
        endAngle: 5.0,
      );
      final expectedResult = PagebuilderGradient(
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
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("should default to linear for unknown type", () {
      // Given
      final model = PagebuilderGradientModel(
        type: "unknown",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": 0.0, "y": 0.0},
        end: {"x": 0.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result.type, PagebuilderGradientType.linear);
    });
  });

  group("PagebuilderGradientModel_FromDomain", () {
    test("check if conversion from PagebuilderGradient to PagebuilderGradientModel works for linear gradient", () {
      // Given
      final domainGradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0), // Blue
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0), // Red
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        center: Alignment.center,
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final expectedResult = PagebuilderGradientModel(
        type: "linear",
        stops: [
          {"color": "FF0000FF", "position": 0.0}, // Pure Blue
          {"color": "FFFF0000", "position": 1.0}, // Pure Red
        ],
        begin: {"x": -1.0, "y": -1.0},
        end: {"x": 1.0, "y": 1.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // When
      final result = PagebuilderGradientModel.fromDomain(domainGradient);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion works for radial gradient", () {
      // Given
      final domainGradient = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF00FF00), position: 0.2), // Green
          PagebuilderGradientStop(color: Color(0xFFFFFF00), position: 0.8), // Yellow
        ],
        begin: Alignment.center,
        end: Alignment.center,
        center: Alignment.topCenter,
        radius: 0.7,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final expectedResult = PagebuilderGradientModel(
        type: "radial",
        stops: [
          {"color": "FF00FF00", "position": 0.2}, // Pure Green
          {"color": "FFFFFF00", "position": 0.8}, // Pure Yellow
        ],
        begin: {"x": 0.0, "y": 0.0},
        end: {"x": 0.0, "y": 0.0},
        center: {"x": 0.0, "y": -1.0},
        radius: 0.7,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // When
      final result = PagebuilderGradientModel.fromDomain(domainGradient);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion works for sweep gradient", () {
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
      final expectedResult = PagebuilderGradientModel(
        type: "sweep",
        stops: [
          {"color": "FF800080", "position": 0.1},
          {"color": "FFFFA500", "position": 0.9},
        ],
        begin: {"x": 0.0, "y": 0.0},
        end: {"x": 0.0, "y": 0.0},
        center: {"x": -1.0, "y": 1.0},
        radius: 0.5,
        startAngle: 1.0,
        endAngle: 5.0,
      );
      // When
      final result = PagebuilderGradientModel.fromDomain(domainGradient);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientModel_Props", () {
    test("check if value equality works", () {
      // Given
      final model1 = PagebuilderGradientModel(
        type: "linear",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final model2 = PagebuilderGradientModel(
        type: "linear",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // Then
      expect(model1, model2);
    });

    test("check if value inequality works for different properties", () {
      // Given
      final model1 = PagebuilderGradientModel(
        type: "linear",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      final model2 = PagebuilderGradientModel(
        type: "radial",
        stops: [
          {"color": "FF0000FF", "position": 0.0},
          {"color": "FFFF0000", "position": 1.0},
        ],
        begin: {"x": -1.0, "y": 0.0},
        end: {"x": 1.0, "y": 0.0},
        center: {"x": 0.0, "y": 0.0},
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 6.283185307179586,
      );
      // Then
      expect(model1, isNot(equals(model2)));
    });
  });
}