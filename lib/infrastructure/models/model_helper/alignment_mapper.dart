import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
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

  static String? getLocalizedStringFromAlignment(Alignment? alignment, AppLocalizations localization) {
    if (alignment == null) {
      return null;
    }
    switch (alignment) {
      case Alignment.topLeft:
        return "Oben links";
      case Alignment.topCenter:
        return "Oben zentriert";
      case Alignment.topRight:
        return "Oben rechts";
      case Alignment.centerLeft:
        return "Mitte links";
      case Alignment.center:
        return "Mitte";
      case Alignment.centerRight:
        return "Mitte rechts";
      case Alignment.bottomLeft:
        return "Unten links";
      case Alignment.bottomCenter:
        return "Unten zentriert";
      case Alignment.bottomRight:
        return "Unten rechts";
      default:
        return "Mitte";
    }
  }
}
