class ColorUtility {
  static int getHexIntFromString(String hexCode) {
    print("THE COLOR: $hexCode");
    final colorCode = int.tryParse(hexCode, radix: 16);
    if (colorCode == null) {
      return 0x00000000;
    }
    return colorCode;
  }
}
