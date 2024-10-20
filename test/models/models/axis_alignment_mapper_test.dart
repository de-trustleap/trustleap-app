import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/axis_alignment_mapper.dart';

void main() {
  group("AxisAlignmentMapper Tests", () {
    test(
        "getStringFromMainAxisAlignment returns correct string for valid MainAxisAlignment",
        () {
      expect(
          AxisAlignmentMapper.getStringFromMainAxisAlignment(
              MainAxisAlignment.start),
          "start");
      expect(
          AxisAlignmentMapper.getStringFromMainAxisAlignment(
              MainAxisAlignment.center),
          "center");
      expect(
          AxisAlignmentMapper.getStringFromMainAxisAlignment(
              MainAxisAlignment.end),
          "end");
    });

    test("getStringFromMainAxisAlignment returns null for null input", () {
      expect(AxisAlignmentMapper.getStringFromMainAxisAlignment(null), isNull);
    });

    test(
        "getStringFromMainAxisAlignment returns null for invalid MainAxisAlignment",
        () {
      expect(
          AxisAlignmentMapper.getStringFromMainAxisAlignment(
              MainAxisAlignment.spaceBetween),
          isNull);
    });

    test(
        "getStringFromCrossAxisAlignment returns correct string for valid CrossAxisAlignment",
        () {
      expect(
          AxisAlignmentMapper.getStringFromCrossAxisAlignment(
              CrossAxisAlignment.start),
          "start");
      expect(
          AxisAlignmentMapper.getStringFromCrossAxisAlignment(
              CrossAxisAlignment.center),
          "center");
      expect(
          AxisAlignmentMapper.getStringFromCrossAxisAlignment(
              CrossAxisAlignment.end),
          "end");
    });

    test("getStringFromCrossAxisAlignment returns null for null input", () {
      expect(AxisAlignmentMapper.getStringFromCrossAxisAlignment(null), isNull);
    });

    test(
        "getStringFromCrossAxisAlignment returns null for invalid CrossAxisAlignment",
        () {
      expect(
          AxisAlignmentMapper.getStringFromCrossAxisAlignment(
              CrossAxisAlignment.stretch),
          isNull);
    });

    // Tests für getMainAxisAlignmentFromString
    test(
        "getMainAxisAlignmentFromString returns correct MainAxisAlignment for valid string",
        () {
      final mapper = AxisAlignmentMapper();
      expect(mapper.getMainAxisAlignmentFromString("start"),
          MainAxisAlignment.start);
      expect(mapper.getMainAxisAlignmentFromString("center"),
          MainAxisAlignment.center);
      expect(
          mapper.getMainAxisAlignmentFromString("end"), MainAxisAlignment.end);
    });

    test("getMainAxisAlignmentFromString returns null for invalid string", () {
      final mapper = AxisAlignmentMapper();
      expect(mapper.getMainAxisAlignmentFromString("invalid"), isNull);
    });

    test("getMainAxisAlignmentFromString returns null for null input", () {
      final mapper = AxisAlignmentMapper();
      expect(mapper.getMainAxisAlignmentFromString(null), isNull);
    });

    test(
        "getCrossAxisAlignmentFromString returns correct CrossAxisAlignment for valid string",
        () {
      final mapper = AxisAlignmentMapper();
      expect(mapper.getCrossAxisAlignmentFromString("start"),
          CrossAxisAlignment.start);
      expect(mapper.getCrossAxisAlignmentFromString("center"),
          CrossAxisAlignment.center);
      expect(mapper.getCrossAxisAlignmentFromString("end"),
          CrossAxisAlignment.end);
    });

    test("getCrossAxisAlignmentFromString returns null for invalid string", () {
      final mapper = AxisAlignmentMapper();
      expect(mapper.getCrossAxisAlignmentFromString("invalid"), isNull);
    });

    test("getCrossAxisAlignmentFromString returns null for null input", () {
      final mapper = AxisAlignmentMapper();
      expect(mapper.getCrossAxisAlignmentFromString(null), isNull);
    });
  });
}
