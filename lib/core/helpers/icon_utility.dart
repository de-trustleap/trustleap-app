import 'package:flutter/material.dart';

class IconUtility {
  static IconData getIconFromHexCode(String? hexCode) {
    int codePoint =
        int.tryParse(hexCode?.replaceFirst("0x", "") ?? "", radix: 16) ?? 0;
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }
}
