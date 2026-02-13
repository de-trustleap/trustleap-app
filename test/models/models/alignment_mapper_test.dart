import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:finanzbegleiter/features/page_builder/infrastructure/model_helper/alignment_mapper.dart";

void main() {
  group("AlignmentMapper tests", () {
    // Test für getAlignmentFromString
    test("getAlignmentFromString returns correct Alignment for valid strings",
        () {
      expect(
          AlignmentMapper.getAlignmentFromString("topLeft"), Alignment.topLeft);
      expect(AlignmentMapper.getAlignmentFromString("topCenter"),
          Alignment.topCenter);
      expect(AlignmentMapper.getAlignmentFromString("topRight"),
          Alignment.topRight);
      expect(AlignmentMapper.getAlignmentFromString("centerLeft"),
          Alignment.centerLeft);
      expect(
          AlignmentMapper.getAlignmentFromString("center"), Alignment.center);
      expect(AlignmentMapper.getAlignmentFromString("centerRight"),
          Alignment.centerRight);
      expect(AlignmentMapper.getAlignmentFromString("bottomLeft"),
          Alignment.bottomLeft);
      expect(AlignmentMapper.getAlignmentFromString("bottomCenter"),
          Alignment.bottomCenter);
      expect(AlignmentMapper.getAlignmentFromString("bottomRight"),
          Alignment.bottomRight);
    });

    test("getAlignmentFromString returns default Alignment for invalid strings",
        () {
      expect(AlignmentMapper.getAlignmentFromString("invalidString"),
          Alignment.center);
    });

    test("getAlignmentFromString returns null for null input", () {
      expect(AlignmentMapper.getAlignmentFromString(null), isNull);
    });

    // Test für getStringFromAlignment
    test("getStringFromAlignment returns correct string for valid Alignment",
        () {
      expect(
          AlignmentMapper.getStringFromAlignment(Alignment.topLeft), "topLeft");
      expect(AlignmentMapper.getStringFromAlignment(Alignment.topCenter),
          "topCenter");
      expect(AlignmentMapper.getStringFromAlignment(Alignment.topRight),
          "topRight");
      expect(AlignmentMapper.getStringFromAlignment(Alignment.centerLeft),
          "centerLeft");
      expect(
          AlignmentMapper.getStringFromAlignment(Alignment.center), "center");
      expect(AlignmentMapper.getStringFromAlignment(Alignment.centerRight),
          "centerRight");
      expect(AlignmentMapper.getStringFromAlignment(Alignment.bottomLeft),
          "bottomLeft");
      expect(AlignmentMapper.getStringFromAlignment(Alignment.bottomCenter),
          "bottomCenter");
      expect(AlignmentMapper.getStringFromAlignment(Alignment.bottomRight),
          "bottomRight");
    });

    test("getStringFromAlignment returns null for null input", () {
      expect(AlignmentMapper.getStringFromAlignment(null), isNull);
    });

    test(
        "getStringFromAlignment returns default string center for invalid Alignment",
        () {
      expect(AlignmentMapper.getStringFromAlignment(Alignment(2, 2)), "center");
    });

    // Test für getAlignmentFromTextAlignment
    test('should return Alignment.centerLeft for TextAlign.left', () {
      final alignment =
          AlignmentMapper.getAlignmentFromTextAlignment(TextAlign.left);
      expect(alignment, Alignment.centerLeft);
    });

    test('should return Alignment.centerRight for TextAlign.right', () {
      final alignment =
          AlignmentMapper.getAlignmentFromTextAlignment(TextAlign.right);
      expect(alignment, Alignment.centerRight);
    });

    test('should return Alignment.center for TextAlign.center', () {
      final alignment =
          AlignmentMapper.getAlignmentFromTextAlignment(TextAlign.center);
      expect(alignment, Alignment.center);
    });

    test('should return Alignment.center for null', () {
      final alignment = AlignmentMapper.getAlignmentFromTextAlignment(null);
      expect(alignment, Alignment.center);
    });

    test('should return Alignment.center for an unsupported TextAlign value',
        () {
      final alignment =
          AlignmentMapper.getAlignmentFromTextAlignment(TextAlign.justify);
      expect(alignment, Alignment.center);
    });
  });
}
