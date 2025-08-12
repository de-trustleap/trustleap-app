import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';

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
      const hexString = "ffc133f5";
      final result = ColorUtility.getHexIntFromString(hexString);
      expect(result, equals(0xffc133f5));
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
}
