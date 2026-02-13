import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/model_helper/boxfit_mapper.dart';

void main() {
  group("BoxFitMapper Tests", () {
    group("getBoxFitFromString", () {
      test("returns null when input is null", () {
        expect(BoxFitMapper.getBoxFitFromString(null), isNull);
      });

      test("returns BoxFit.fill for fill", () {
        expect(BoxFitMapper.getBoxFitFromString("fill"), BoxFit.fill);
      });

      test("returns BoxFit.contain for contain", () {
        expect(BoxFitMapper.getBoxFitFromString("contain"), BoxFit.contain);
      });

      test("returns BoxFit.cover for cover", () {
        expect(BoxFitMapper.getBoxFitFromString("cover"), BoxFit.cover);
      });

      test("returns BoxFit.cover for unknown input", () {
        expect(BoxFitMapper.getBoxFitFromString("unknown"), BoxFit.cover);
      });
    });

    group("getStringFromBoxFit", () {
      test("returns null when input is null", () {
        expect(BoxFitMapper.getStringFromBoxFit(null), isNull);
      });

      test("returns fill for BoxFit.fill", () {
        expect(BoxFitMapper.getStringFromBoxFit(BoxFit.fill), "fill");
      });

      test("returns contain for BoxFit.contain", () {
        expect(BoxFitMapper.getStringFromBoxFit(BoxFit.contain), "contain");
      });

      test("returns cover for BoxFit.cover", () {
        expect(BoxFitMapper.getStringFromBoxFit(BoxFit.cover), "cover");
      });

      test("returns cover for unsupported BoxFit values", () {
        expect(BoxFitMapper.getStringFromBoxFit(BoxFit.none), "cover");
      });
    });
  });
}