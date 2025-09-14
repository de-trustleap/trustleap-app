import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:flutter/material.dart';

void main() {
  group("ColorUtility getHexIntFromString", () {
    test(
        "should return the correct integer for a valid hex string without alpha",
        () {
      const hexString = "c133f5";
      final result = ColorUtility.getHexIntFromString(hexString);
      expect(result, equals(0xc133f5));
    });

    test("should return the correct integer for a valid hex string with alpha",
        () {
      const hexString = "FFc133f5";
      final result = ColorUtility.getHexIntFromString(hexString);
      expect(result, equals(0xFFc133f5));
    });

    test("should return the correct integer for a fully transparent hex string",
        () {
      const hexString = "00c133f5";
      final result = ColorUtility.getHexIntFromString(hexString);
      expect(result, equals(0x00c133f5));
    });

    test("should return 0x00000000 when given an invalid hex string", () {
      const hexString = "invalid_hex";
      final result = ColorUtility.getHexIntFromString(hexString);
      expect(result, equals(0x00000000));
    });

    test("should return 0x00000000 when given an empty string", () {
      const hexString = "";
      final result = ColorUtility.getHexIntFromString(hexString);
      expect(result, equals(0x00000000));
    });

    test("should return 0x00000000 when given a null string", () {
      const String? hexString = null;
      final result = ColorUtility.getHexIntFromString(hexString ?? "");
      expect(result, equals(0x00000000));
    });
  });

  group("ColorUtility colorToHex", () {
    test("should return correct 8-digit hex without prefix for opaque black", () {
      const color = Color(0xFF000000);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("FF000000"));
    });

    test("should return correct 8-digit hex without prefix for opaque white", () {
      const color = Color(0xFFFFFFFF);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("FFFFFFFF"));
    });

    test("should return correct 8-digit hex without prefix for transparent black", () {
      const color = Color(0x00000000);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("00000000"));
    });

    test("should return correct 8-digit hex without prefix for transparent blue", () {
      const color = Color(0x000000FF);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("000000FF"));
    });

    test("should return correct 8-digit hex without prefix for semi-transparent red", () {
      const color = Color(0x80FF0000);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("80FF0000"));
    });

    test("should return correct 8-digit hex with # prefix when includeHashPrefix is true", () {
      const color = Color(0xFF000000);
      final result = ColorUtility.colorToHex(color, includeHashPrefix: true);
      expect(result, equals("#FF000000"));
    });

    test("should return correct 8-digit hex with # prefix for transparent color", () {
      const color = Color(0x00000000);
      final result = ColorUtility.colorToHex(color, includeHashPrefix: true);
      expect(result, equals("#00000000"));
    });

    test("should handle edge case with maximum color value", () {
      const color = Color(0xFFFFFFFF);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("FFFFFFFF"));
    });

    test("should handle edge case with minimum color value", () {
      const color = Color(0x00000000);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("00000000"));
    });

    test("should preserve leading zeros for low alpha values", () {
      const color = Color(0x0F123456);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("0F123456"));
    });

    test("should return uppercase hex values", () {
      const color = Color(0xAABBCCDD);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("AABBCCDD"));
    });

    test("should handle custom colors correctly", () {
      const color = Color(0x7F3651C1);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("7F3651C1"));
    });
  });
}
