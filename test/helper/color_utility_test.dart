import 'package:test/test.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';

void main() {
  group("ColorUtility getHexIntFromString", () {
    test('should return color with full opacity for valid hex code', () {
      final result = ColorUtility.getHexIntFromString('cf2bae');
      expect(result, 0xFFcf2bae);
    });

    test('should return black color for invalid hex code', () {
      final result = ColorUtility.getHexIntFromString('invalid_hex');
      expect(result, 0x00000000);
    });

    test('should handle empty string input and return black color', () {
      final result = ColorUtility.getHexIntFromString('');
      expect(result, 0x00000000);
    });

    test('should add full opacity to hex code with alpha missing', () {
      final result = ColorUtility.getHexIntFromString('00ff00');
      expect(result, 0xFF00ff00);
    });

    test('should not modify alpha value if already present', () {
      final result = ColorUtility.getHexIntFromString('80ff00');
      expect(result, 0xFF80ff00);
    });
  });
}