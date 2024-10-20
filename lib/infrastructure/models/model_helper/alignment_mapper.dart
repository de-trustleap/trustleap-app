import 'package:flutter/material.dart';

class AlignmentMapper {
  static Alignment? getAlignmentFromString(String? alignment) {
    if (alignment == null) {
      return null;
    }
    switch (alignment) {
      case "topLeft":
        return Alignment.topLeft;
      case "topCenter":
        return Alignment.topCenter;
      case "topRight":
        return Alignment.topRight;
      case "centerLeft":
        return Alignment.centerLeft;
      case "center":
        return Alignment.center;
      case "centerRight":
        return Alignment.centerRight;
      case "bottomLeft":
        return Alignment.bottomLeft;
      case "bottomCenter":
        return Alignment.bottomCenter;
      case "bottomRight":
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }

  static String? getStringFromAlignment(Alignment? alignment) {
    if (alignment == null) {
      return null;
    }
    switch (alignment) {
      case Alignment.topLeft:
        return "topLeft";
      case Alignment.topCenter:
        return "topCenter";
      case Alignment.topRight:
        return "topRight";
      case Alignment.centerLeft:
        return "centerLeft";
      case Alignment.center:
        return "center";
      case Alignment.centerRight:
        return "centerRight";
      case Alignment.bottomLeft:
        return "bottomLeft";
      case Alignment.bottomCenter:
        return "bottomCenter";
      case Alignment.bottomRight:
        return "bottomRight";
      default:
        return "center";
    }
  }
}
