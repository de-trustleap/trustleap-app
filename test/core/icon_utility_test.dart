import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/helpers/icon_utility.dart';

void main() {
  group("IconUtility getIconFromHexCode", () {
    test("should return a valid IconData for a valid hex code", () {
      const String hexCode = "0xe87c";
      final IconData icon = IconUtility.getIconFromHexCode(hexCode);

      expect(icon.codePoint, equals(0xe87c));
      expect(icon.fontFamily, equals("MaterialIcons"));
    });

    test("should return a default IconData for a null input", () {
      final IconData icon = IconUtility.getIconFromHexCode(null);

      expect(icon.codePoint, equals(0));
      expect(icon.fontFamily, equals("MaterialIcons"));
    });

    test("should return a default IconData for an empty string", () {
      final IconData icon = IconUtility.getIconFromHexCode('');

      expect(icon.codePoint, equals(0));
      expect(icon.fontFamily, equals("MaterialIcons"));
    });

    test("should return a default IconData for an invalid hex code", () {
      const String invalidHexCode = 'invalid';
      final IconData icon = IconUtility.getIconFromHexCode(invalidHexCode);

      expect(icon.codePoint, equals(0));
      expect(icon.fontFamily, equals("MaterialIcons"));
    });

    test("should handle hex codes without the 0x prefix", () {
      const String hexCode = 'e87c';
      final IconData icon = IconUtility.getIconFromHexCode(hexCode);

      expect(icon.codePoint, equals(0xe87c));
      expect(icon.fontFamily, equals("MaterialIcons"));
    });

    test("should handle hex codes with mixed case letters", () {
      const String hexCode = "0xE87C";
      final IconData icon = IconUtility.getIconFromHexCode(hexCode);

      expect(icon.codePoint, equals(0xe87c));
      expect(icon.fontFamily, equals("MaterialIcons"));
    });
  });
}
