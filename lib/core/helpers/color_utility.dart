import 'package:flutter/material.dart';

class ColorUtility {
  static int getHexIntFromString(String hexCode) {
    final colorCode = int.tryParse(hexCode, radix: 16);
    if (colorCode == null) {
      return 0x00000000;
    }
    return colorCode;
  }

  static String colorToHex(Color color, {bool includeHashPrefix = false}) {
    try {
      String hex = color.toARGB32().toRadixString(16).toUpperCase();
      String result = hex.padLeft(8, '0');
      if (includeHashPrefix) result = "#$result";
      return result;
    } catch (e) {
      return includeHashPrefix ? "#00000000" : "00000000";
    }
  }
}
