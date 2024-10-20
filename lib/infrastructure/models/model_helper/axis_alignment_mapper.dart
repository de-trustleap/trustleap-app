import 'package:flutter/material.dart';

class AxisAlignmentMapper {
  static String? getStringFromMainAxisAlignment(
      MainAxisAlignment? mainAxisAlignment) {
    if (mainAxisAlignment == null) {
      return null;
    }
    switch (mainAxisAlignment) {
      case == MainAxisAlignment.start:
        return "start";
      case == MainAxisAlignment.center:
        return "center";
      case == MainAxisAlignment.end:
        return "end";
      default:
        return null;
    }
  }

  static String? getStringFromCrossAxisAlignment(
      CrossAxisAlignment? crossAxisAlignment) {
    if (crossAxisAlignment == null) {
      return null;
    }
    switch (crossAxisAlignment) {
      case == CrossAxisAlignment.start:
        return "start";
      case == CrossAxisAlignment.center:
        return "center";
      case == CrossAxisAlignment.end:
        return "end";
      default:
        return null;
    }
  }

  MainAxisAlignment? getMainAxisAlignmentFromString(String? mainAxisAlignment) {
    if (mainAxisAlignment == "start") return MainAxisAlignment.start;
    if (mainAxisAlignment == "center") return MainAxisAlignment.center;
    if (mainAxisAlignment == "end") return MainAxisAlignment.end;
    return null;
  }

  CrossAxisAlignment? getCrossAxisAlignmentFromString(
      String? crossAxisAlignment) {
    if (crossAxisAlignment == "start") return CrossAxisAlignment.start;
    if (crossAxisAlignment == "center") return CrossAxisAlignment.center;
    if (crossAxisAlignment == "end") return CrossAxisAlignment.end;
    return null;
  }
}
