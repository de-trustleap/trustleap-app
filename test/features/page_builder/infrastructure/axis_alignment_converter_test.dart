import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/model_helper/axis_alignment_converter.dart';

void main() {
  group("AxisAlignmentConverter Tests", () {
    group("mainAxisToCrossAxis", () {
      test("converts MainAxisAlignment.start to CrossAxisAlignment.start", () {
        expect(
          AxisAlignmentConverter.mainAxisToCrossAxis(MainAxisAlignment.start),
          CrossAxisAlignment.start,
        );
      });

      test("converts MainAxisAlignment.end to CrossAxisAlignment.end", () {
        expect(
          AxisAlignmentConverter.mainAxisToCrossAxis(MainAxisAlignment.end),
          CrossAxisAlignment.end,
        );
      });

      test("converts MainAxisAlignment.center to CrossAxisAlignment.center",
          () {
        expect(
          AxisAlignmentConverter.mainAxisToCrossAxis(MainAxisAlignment.center),
          CrossAxisAlignment.center,
        );
      });

      test(
          "converts MainAxisAlignment.spaceBetween to CrossAxisAlignment.center",
          () {
        expect(
          AxisAlignmentConverter.mainAxisToCrossAxis(
              MainAxisAlignment.spaceBetween),
          CrossAxisAlignment.center,
        );
      });

      test(
          "converts MainAxisAlignment.spaceAround to CrossAxisAlignment.center",
          () {
        expect(
          AxisAlignmentConverter.mainAxisToCrossAxis(
              MainAxisAlignment.spaceAround),
          CrossAxisAlignment.center,
        );
      });

      test(
          "converts MainAxisAlignment.spaceEvenly to CrossAxisAlignment.center",
          () {
        expect(
          AxisAlignmentConverter.mainAxisToCrossAxis(
              MainAxisAlignment.spaceEvenly),
          CrossAxisAlignment.center,
        );
      });
    });

    group("crossAxisToMainAxis", () {
      test("converts CrossAxisAlignment.start to MainAxisAlignment.start", () {
        expect(
          AxisAlignmentConverter.crossAxisToMainAxis(CrossAxisAlignment.start),
          MainAxisAlignment.start,
        );
      });

      test("converts CrossAxisAlignment.end to MainAxisAlignment.end", () {
        expect(
          AxisAlignmentConverter.crossAxisToMainAxis(CrossAxisAlignment.end),
          MainAxisAlignment.end,
        );
      });

      test("converts CrossAxisAlignment.center to MainAxisAlignment.center",
          () {
        expect(
          AxisAlignmentConverter.crossAxisToMainAxis(
              CrossAxisAlignment.center),
          MainAxisAlignment.center,
        );
      });

      test("converts CrossAxisAlignment.stretch to MainAxisAlignment.start",
          () {
        expect(
          AxisAlignmentConverter.crossAxisToMainAxis(
              CrossAxisAlignment.stretch),
          MainAxisAlignment.start,
        );
      });

      test("converts CrossAxisAlignment.baseline to MainAxisAlignment.start",
          () {
        expect(
          AxisAlignmentConverter.crossAxisToMainAxis(
              CrossAxisAlignment.baseline),
          MainAxisAlignment.start,
        );
      });
    });
  });
}
