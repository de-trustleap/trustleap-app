import 'package:flutter/material.dart';

class BoxFitMapper {
  static BoxFit? getBoxFitFromString(String? contentMode) {
    if (contentMode == null) {
      return null;
    }
    switch (contentMode) {
      case "fill":
        return BoxFit.fill;
      case "contain":
        return BoxFit.contain;
      case "cover":
        return BoxFit.cover;
      default:
        return BoxFit.cover;
    }
  }

  static String? getStringFromBoxFit(BoxFit? contentMode) {
    if (contentMode == null) {
      return null;
    }
    switch (contentMode) {
      case BoxFit.fill:
        return "fill";
      case BoxFit.contain:
        return "contain";
      case BoxFit.cover:
        return "cover";
      default:
        return "cover";
    }
  }
}