class ColorUtility {
  static int getHexIntFromString(String hexCode) {
    final colorCode = int.tryParse(hexCode, radix: 16);
    if (colorCode == null) {
      return 0x00000000;
    }
    return colorCode | 0xFF000000; // Füge Alpha-Wert 0xFF (vollständig sichtbar) hinzu
  }
}
