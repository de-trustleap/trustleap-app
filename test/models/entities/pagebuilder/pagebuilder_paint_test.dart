import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_gradient.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderPaint_Constructors", () {
    test("default constructor should allow both color and gradient", () {
      // Given
      const paint = PagebuilderPaint(
        color: Colors.red,
        gradient: null,
      );
      // Then
      expect(paint.color, Colors.red);
      expect(paint.gradient, null);
    });

    test("color factory constructor should create color paint", () {
      // Given
      const paint = PagebuilderPaint.color(Colors.blue);
      // Then
      expect(paint.color, Colors.blue);
      expect(paint.gradient, null);
      expect(paint.isColor, true);
      expect(paint.isGradient, false);
    });

    test("gradient factory constructor should create gradient paint", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
        ],
      );
      final paint = PagebuilderPaint.gradient(gradient);
      // Then
      expect(paint.color, null);
      expect(paint.gradient, gradient);
      expect(paint.isColor, false);
      expect(paint.isGradient, true);
    });
  });

  group("PagebuilderPaint_Getters", () {
    test("isColor should return true when color is set", () {
      // Given
      const paint = PagebuilderPaint.color(Colors.green);
      // Then
      expect(paint.isColor, true);
      expect(paint.isGradient, false);
    });

    test("isGradient should return true when gradient is set", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF00FF00), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFFFF00), position: 1.0, globalColorToken: null),
        ],
      );
      final paint = PagebuilderPaint.gradient(gradient);
      // Then
      expect(paint.isColor, false);
      expect(paint.isGradient, true);
    });

    test("both getters should return false when neither is set", () {
      // Given
      const paint = PagebuilderPaint();
      // Then
      expect(paint.isColor, false);
      expect(paint.isGradient, false);
    });
  });

  group("PagebuilderPaint_CopyWith", () {
    test("copyWith should update color", () {
      // Given
      const originalPaint = PagebuilderPaint.color(Colors.red);
      // When
      final result = originalPaint.copyWith(color: Colors.blue);
      // Then
      expect(result.color, Colors.blue);
      expect(result.gradient, null);
    });

    test("copyWith should update gradient", () {
      // Given
      const originalPaint = PagebuilderPaint.color(Colors.red);
      final newGradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
        ],
      );
      // When
      final result = originalPaint.copyWith(gradient: newGradient);
      // Then
      expect(result.color, Colors.red);
      expect(result.gradient, newGradient);
    });

    test("copyWith should set color to null when setColorNull is true", () {
      // Given
      const originalPaint = PagebuilderPaint.color(Colors.red);
      // When
      final result = originalPaint.copyWith(setColorNull: true);
      // Then
      expect(result.color, null);
      expect(result.gradient, null);
    });

    test("copyWith should set gradient to null when setGradientNull is true", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
        ],
      );
      final originalPaint = PagebuilderPaint.gradient(gradient);
      // When
      final result = originalPaint.copyWith(setGradientNull: true);
      // Then
      expect(result.color, null);
      expect(result.gradient, null);
    });

    test("copyWith should switch from color to gradient", () {
      // Given
      const originalPaint = PagebuilderPaint.color(Colors.red);
      final newGradient = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF00FF00), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFFFF00), position: 1.0, globalColorToken: null),
        ],
      );
      // When
      final result = originalPaint.copyWith(
        gradient: newGradient,
        setColorNull: true,
      );
      // Then
      expect(result.color, null);
      expect(result.gradient, newGradient);
      expect(result.isColor, false);
      expect(result.isGradient, true);
    });

    test("copyWith should switch from gradient to color", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
        ],
      );
      final originalPaint = PagebuilderPaint.gradient(gradient);
      // When
      final result = originalPaint.copyWith(
        color: Colors.green,
        setGradientNull: true,
      );
      // Then
      expect(result.color, Colors.green);
      expect(result.gradient, null);
      expect(result.isColor, true);
      expect(result.isGradient, false);
    });
  });

  group("PagebuilderPaint_DeepCopy", () {
    test("deepCopy should create independent copy of color paint", () {
      // Given
      const original = PagebuilderPaint.color(Color(0xFF123456));
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.color?.value, equals(original.color?.value));
      expect(copy.gradient, null);
    });

    test("deepCopy should create independent copy of gradient paint", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      final original = PagebuilderPaint.gradient(gradient);
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.color, null);
      expect(copy.gradient, isNot(same(original.gradient)));
      expect(copy.gradient?.type, equals(original.gradient?.type));
      expect(copy.gradient?.stops.length, equals(original.gradient?.stops.length));
      expect(copy.gradient?.begin, equals(original.gradient?.begin));
      expect(copy.gradient?.end, equals(original.gradient?.end));
    });

    test("deepCopy should handle null values", () {
      // Given
      const original = PagebuilderPaint();
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.color, null);
      expect(copy.gradient, null);
    });

    test("deepCopy should create completely independent gradient copies", () {
      // Given
      final originalStops = [
        PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
        PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
      ];
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: originalStops,
      );
      final original = PagebuilderPaint.gradient(gradient);
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy.gradient?.stops, isNot(same(original.gradient?.stops)));
      for (int i = 0; i < copy.gradient!.stops.length; i++) {
        expect(copy.gradient!.stops[i], isNot(same(original.gradient!.stops[i])));
        expect(copy.gradient!.stops[i].color.value,
               equals(original.gradient!.stops[i].color.value));
        expect(copy.gradient!.stops[i].position,
               equals(original.gradient!.stops[i].position));
      }
    });
  });

  group("PagebuilderPaint_Props", () {
    test("check if value equality works for color paints", () {
      // Given
      const paint1 = PagebuilderPaint.color(Colors.blue);
      const paint2 = PagebuilderPaint.color(Colors.blue);
      // Then
      expect(paint1, paint2);
    });

    test("check if value equality works for gradient paints", () {
      // Given
      final gradient = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
        ],
      );
      final paint1 = PagebuilderPaint.gradient(gradient);
      final paint2 = PagebuilderPaint.gradient(gradient);
      // Then
      expect(paint1, paint2);
    });

    test("check if value inequality works for different colors", () {
      // Given
      const paint1 = PagebuilderPaint.color(Colors.blue);
      const paint2 = PagebuilderPaint.color(Colors.red);
      // Then
      expect(paint1, isNot(equals(paint2)));
    });

    test("check if value inequality works for different gradients", () {
      // Given
      final gradient1 = PagebuilderGradient(
        type: PagebuilderGradientType.linear,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
        ],
      );
      final gradient2 = PagebuilderGradient(
        type: PagebuilderGradientType.radial,
        stops: [
          PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
          PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
        ],
      );
      final paint1 = PagebuilderPaint.gradient(gradient1);
      final paint2 = PagebuilderPaint.gradient(gradient2);
      // Then
      expect(paint1, isNot(equals(paint2)));
    });

    test("check if value inequality works between color and gradient paints", () {
      // Given
      const colorPaint = PagebuilderPaint.color(Colors.blue);
      final gradientPaint = PagebuilderPaint.gradient(
        PagebuilderGradient(
          type: PagebuilderGradientType.linear,
          stops: [
            PagebuilderGradientStop(color: Color(0xFF0000FF), position: 0.0, globalColorToken: null),
            PagebuilderGradientStop(color: Color(0xFFFF0000), position: 1.0, globalColorToken: null),
          ],
        ),
      );
      // Then
      expect(colorPaint, isNot(equals(gradientPaint)));
    });

    test("check if value equality works for null paints", () {
      // Given
      const paint1 = PagebuilderPaint();
      const paint2 = PagebuilderPaint();
      // Then
      expect(paint1, paint2);
    });
  });
}