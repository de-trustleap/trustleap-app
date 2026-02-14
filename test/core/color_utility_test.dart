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
    test("should return correct 8-digit hex without prefix for opaque black",
        () {
      const color = Color(0xFF000000);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("FF000000"));
    });

    test("should return correct 8-digit hex without prefix for opaque white",
        () {
      const color = Color(0xFFFFFFFF);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("FFFFFFFF"));
    });

    test(
        "should return correct 8-digit hex without prefix for transparent black",
        () {
      const color = Color(0x00000000);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("00000000"));
    });

    test(
        "should return correct 8-digit hex without prefix for transparent blue",
        () {
      const color = Color(0x000000FF);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("000000FF"));
    });

    test(
        "should return correct 8-digit hex without prefix for semi-transparent red",
        () {
      const color = Color(0x80FF0000);
      final result = ColorUtility.colorToHex(color);
      expect(result, equals("80FF0000"));
    });

    test(
        "should return correct 8-digit hex with # prefix when includeHashPrefix is true",
        () {
      const color = Color(0xFF000000);
      final result = ColorUtility.colorToHex(color, includeHashPrefix: true);
      expect(result, equals("#FF000000"));
    });

    test(
        "should return correct 8-digit hex with # prefix for transparent color",
        () {
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

  group("ColorUtility hexToColor", () {
    test("should convert 6-digit hex without # to opaque color", () {
      const hexString = "FF0000";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0xFFFF0000)));
    });

    test("should convert 6-digit hex with # to opaque color", () {
      const hexString = "#00FF00";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0xFF00FF00)));
    });

    test("should convert 8-digit hex without # to color with alpha", () {
      const hexString = "80FF0000";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0x80FF0000)));
    });

    test("should convert 8-digit hex with # to color with alpha", () {
      const hexString = "#7F00FF00";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0x7F00FF00)));
    });

    test("should convert black color correctly", () {
      const hexString = "#000000";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0xFF000000)));
    });

    test("should convert white color correctly", () {
      const hexString = "#FFFFFF";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0xFFFFFFFF)));
    });

    test("should handle lowercase hex values", () {
      const hexString = "#aabbcc";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0xFFAABBCC)));
    });

    test("should handle mixed case hex values", () {
      const hexString = "#AaBbCc";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0xFFAABBCC)));
    });

    test("should return transparent for empty string", () {
      const hexString = "";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(Colors.transparent));
    });

    test("should return transparent for invalid hex string", () {
      const hexString = "invalid";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(Colors.transparent));
    });

    test("should return transparent for hex string with invalid length", () {
      const hexString = "#FFF";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(Colors.transparent));
    });

    test("should return transparent for hex string with too many characters",
        () {
      const hexString = "#FFFFFFFFF";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(Colors.transparent));
    });

    test("should handle fully transparent color", () {
      const hexString = "#00000000";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0x00000000)));
    });

    test("should handle semi-transparent color", () {
      const hexString = "#801B3864";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0x801B3864)));
    });

    test("should automatically add FF alpha for 6-digit hex", () {
      const hexString = "123456";
      final result = ColorUtility.hexToColor(hexString);
      expect(result.alpha, equals(255));
      expect(result.red, equals(0x12));
      expect(result.green, equals(0x34));
      expect(result.blue, equals(0x56));
    });

    test("should preserve alpha channel for 8-digit hex", () {
      const hexString = "0F123456";
      final result = ColorUtility.hexToColor(hexString);
      expect(result.alpha, equals(0x0F));
      expect(result.red, equals(0x12));
      expect(result.green, equals(0x34));
      expect(result.blue, equals(0x56));
    });

    test("should handle hex with multiple # symbols by removing all", () {
      const hexString = "##FF0000";
      final result = ColorUtility.hexToColor(hexString);
      expect(result, equals(const Color(0xFFFF0000)));
    });

    test("should round-trip with colorToHex for 6-digit hex", () {
      const originalHex = "#FF5733";
      final color = ColorUtility.hexToColor(originalHex);
      final resultHex = ColorUtility.colorToHex(color, includeHashPrefix: true);
      expect(resultHex, equals("#FFFF5733"));
    });

    test("should round-trip with colorToHex for 8-digit hex", () {
      const originalHex = "#80FF5733";
      final color = ColorUtility.hexToColor(originalHex);
      final resultHex = ColorUtility.colorToHex(color, includeHashPrefix: true);
      expect(resultHex, equals(originalHex.toUpperCase()));
    });
  });
}
