import 'package:flutter/material.dart';

class AxisAlignmentConverter {
  static CrossAxisAlignment mainAxisToCrossAxis(MainAxisAlignment main) {
    switch (main) {
      case MainAxisAlignment.start:
        return CrossAxisAlignment.start;
      case MainAxisAlignment.end:
        return CrossAxisAlignment.end;
      case MainAxisAlignment.center:
        return CrossAxisAlignment.center;
      case MainAxisAlignment.spaceBetween:
      case MainAxisAlignment.spaceAround:
      case MainAxisAlignment.spaceEvenly:
        return CrossAxisAlignment.center;
    }
  }

  static MainAxisAlignment crossAxisToMainAxis(CrossAxisAlignment cross) {
    switch (cross) {
      case CrossAxisAlignment.start:
        return MainAxisAlignment.start;
      case CrossAxisAlignment.end:
        return MainAxisAlignment.end;
      case CrossAxisAlignment.center:
        return MainAxisAlignment.center;
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        return MainAxisAlignment.start;
    }
  }
}
