import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderGradientStop_CopyWith", () {
    test(
        "set color and position with copyWith should set color and position for resulting object",
        () {
      // Given
      final stop = PagebuilderGradientStop(
        color: Colors.blue,
        position: 0.0,
        globalColorToken: null,
      );
      final expectedResult = PagebuilderGradientStop(
        color: Colors.red,
        position: 0.5,
        globalColorToken: null,
      );
      // When
      final result = stop.copyWith(color: Colors.red, position: 0.5);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradientStop_DeepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const originalStop = PagebuilderGradientStop(
        color: Color(0xFF2196F3), // Using Color instead of MaterialColor
        position: 0.3,
        globalColorToken: null,
      );

      // When
      final copy = originalStop.deepCopy();

      // Then
      expect(copy, isNot(same(originalStop)));
      expect(copy.color.value, equals(originalStop.color.value));
      expect(copy.position, equals(originalStop.position));
    });
  });

  group("PagebuilderGradientStop_Props", () {
    test("check if value equality works", () {
      // Given
      const stop1 = PagebuilderGradientStop(
        color: Colors.blue,
        position: 0.5,
        globalColorToken: null,
      );
      const stop2 = PagebuilderGradientStop(
        color: Colors.blue,
        position: 0.5,
        globalColorToken: null,
      );
      // Then
      expect(stop1, stop2);
    });
  });

  group("PagebuilderGradient_CopyWith", () {
    test(
        "set type and stops with copyWith should set type and stops for resulting object",
        () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Colors.blue, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.red, position: 1.0, globalColorToken: null),
        ],
      );
      final expectedResult = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Colors.green, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.yellow, position: 1.0, globalColorToken: null),
        ],
      );
      // When
      final result = gradient.copyWith(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Colors.green, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.yellow, position: 1.0, globalColorToken: null),
        ],
      );
      // Then
      expect(result, expectedResult);
    });

    test(
        "set center and radius with copyWith should set center and radius for resulting object",
        () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Colors.blue, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.red, position: 1.0, globalColorToken: null),
        ],
        center: Alignment.center,
        radius: 0.5,
      );
      final expectedResult = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Colors.blue, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.red, position: 1.0, globalColorToken: null),
        ],
        center: Alignment.topLeft,
        radius: 0.8,
      );
      // When
      final result = gradient.copyWith(
        center: Alignment.topLeft,
        radius: 0.8,
      );
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderGradient_DefaultFactories", () {
    test("defaultLinear should create linear gradient with default properties", () {
      // When
      final gradient = PagebuilderGradient.defaultLinear();

      // Then
      expect(gradient.type, PagebuilderGradientType.linear);
      expect(gradient.stops.length, 2);
      expect(gradient.stops[0].color, Colors.blue);
      expect(gradient.stops[0].position, 0.0);
      expect(gradient.stops[1].color, Colors.red);
      expect(gradient.stops[1].position, 1.0);
      expect(gradient.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
    });

    test("defaultRadial should create radial gradient with default properties", () {
      // When
      final gradient = PagebuilderGradient.defaultRadial();

      // Then
      expect(gradient.type, PagebuilderGradientType.radial);
      expect(gradient.stops.length, 2);
      expect(gradient.stops[0].color, Colors.blue);
      expect(gradient.stops[0].position, 0.0);
      expect(gradient.stops[1].color, Colors.red);
      expect(gradient.stops[1].position, 1.0);
      expect(gradient.center, Alignment.center);
      expect(gradient.radius, 0.5);
    });

    test("defaultSweep should create sweep gradient with default properties", () {
      // When
      final gradient = PagebuilderGradient.defaultSweep();

      // Then
      expect(gradient.type, PagebuilderGradientType.sweep);
      expect(gradient.stops.length, 2);
      expect(gradient.stops[0].color, Colors.blue);
      expect(gradient.stops[0].position, 0.0);
      expect(gradient.stops[1].color, Colors.red);
      expect(gradient.stops[1].position, 1.0);
      expect(gradient.center, Alignment.center);
      expect(gradient.startAngle, 0.0);
      expect(gradient.endAngle, 6.283185307179586); // 2 * pi
    });
  });

  group("PagebuilderGradient_ToFlutterGradient", () {
    test("should create LinearGradient for linear type", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Colors.blue, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.red, position: 1.0, globalColorToken: null),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      // When
      final flutterGradient = gradient.toFlutterGradient();

      // Then
      expect(flutterGradient, isA<LinearGradient>());
      final linearGradient = flutterGradient as LinearGradient;
      expect(linearGradient.begin, Alignment.topLeft);
      expect(linearGradient.end, Alignment.bottomRight);
      expect(linearGradient.colors, [Colors.blue, Colors.red]);
      expect(linearGradient.stops, [0.0, 1.0]);
    });

    test("should create RadialGradient for radial type", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Colors.green, position: 0.2, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.yellow, position: 0.8, globalColorToken: null),
        ],
        center: Alignment.topCenter,
        radius: 0.7,
      );

      // When
      final flutterGradient = gradient.toFlutterGradient();

      // Then
      expect(flutterGradient, isA<RadialGradient>());
      final radialGradient = flutterGradient as RadialGradient;
      expect(radialGradient.center, Alignment.topCenter);
      expect(radialGradient.radius, 0.7);
      expect(radialGradient.colors, [Colors.green, Colors.yellow]);
      expect(radialGradient.stops, [0.2, 0.8]);
    });

    test("should create SweepGradient for sweep type", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.sweep,
        stops: [
          PagebuilderGradientStop(color: Colors.purple, position: 0.1, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.orange, position: 0.9, globalColorToken: null),
        ],
        center: Alignment.bottomLeft,
        startAngle: 1.0,
        endAngle: 5.0,
      );

      // When
      final flutterGradient = gradient.toFlutterGradient();

      // Then
      expect(flutterGradient, isA<SweepGradient>());
      final sweepGradient = flutterGradient as SweepGradient;
      expect(sweepGradient.center, Alignment.bottomLeft);
      expect(sweepGradient.startAngle, 1.0);
      expect(sweepGradient.endAngle, 5.0);
      expect(sweepGradient.colors, [Colors.purple, Colors.orange]);
      expect(sweepGradient.stops, [0.1, 0.9]);
    });
  });

  group("PagebuilderGradient_DeepCopy", () {
    test('should create independent copies (mutation test)', () {
      // Given
      final originalStops = [
        PagebuilderGradientStop(color: Color(0xFFF44336), position: 0.0, globalColorToken: null), // Red
        PagebuilderGradientStop(color: Color(0xFF2196F3), position: 1.0, globalColorToken: null), // Blue
      ];

      final original = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: originalStops,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        center: Alignment.center,
        radius: 0.5,
        startAngle: 0.0,
        endAngle: 3.14159,
      );

      // When
      final copy = original.deepCopy();

      // Then - verify the copy is not the same object
      expect(copy, isNot(same(original)));
      expect(copy.stops, isNot(same(original.stops)));

      // Then - verify properties are copied correctly
      expect(copy.type, equals(original.type));
      expect(copy.stops.length, equals(original.stops.length));
      expect(copy.stops[0].color.value, equals(original.stops[0].color.value));
      expect(copy.stops[0].position, equals(original.stops[0].position));
      expect(copy.stops[1].color.value, equals(original.stops[1].color.value));
      expect(copy.stops[1].position, equals(original.stops[1].position));
      expect(copy.begin, equals(original.begin));
      expect(copy.end, equals(original.end));
      expect(copy.center, equals(original.center));
      expect(copy.radius, equals(original.radius));
      expect(copy.startAngle, equals(original.startAngle));
      expect(copy.endAngle, equals(original.endAngle));

      // Then - verify stops are independent copies
      for (int i = 0; i < copy.stops.length; i++) {
        expect(copy.stops[i], isNot(same(original.stops[i])));
      }
    });
  });

  group("PagebuilderGradient_Props", () {
    test("check if value equality works", () {
      // Given
      final gradient1 = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Colors.blue, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.red, position: 1.0, globalColorToken: null),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      final gradient2 = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Colors.blue, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.red, position: 1.0, globalColorToken: null),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      // Then
      expect(gradient1, gradient2);
    });

    test("check if value inequality works for different properties", () {
      // Given
      final gradient1 = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Colors.blue, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.red, position: 1.0, globalColorToken: null),
        ],
      );
      final gradient2 = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Colors.blue, position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Colors.red, position: 1.0, globalColorToken: null),
        ],
      );
      // Then
      expect(gradient1, isNot(equals(gradient2)));
    });
  });
}