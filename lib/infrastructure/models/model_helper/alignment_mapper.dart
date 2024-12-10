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

  static String? getLocalizedStringFromAlignment(
      Alignment? alignment, AppLocalizations localization) {
    if (alignment == null) {
      return null;
    }
    switch (alignment) {
      case Alignment.topLeft:
        return localization.pagebuilder_layout_menu_alignment_top_left;
      case Alignment.topCenter:
        return localization.pagebuilder_layout_menu_alignment_top_center;
      case Alignment.topRight:
        return localization.pagebuilder_layout_menu_alignment_top_right;
      case Alignment.centerLeft:
        return localization.pagebuilder_layout_menu_alignment_center_left;
      case Alignment.center:
        return localization.pagebuilder_layout_menu_alignment_center;
      case Alignment.centerRight:
        return localization.pagebuilder_layout_menu_alignment_center_right;
      case Alignment.bottomLeft:
        return localization.pagebuilder_layout_menu_alignment_bottom_left;
      case Alignment.bottomCenter:
        return localization.pagebuilder_layout_menu_alignment_bottom_center;
      case Alignment.bottomRight:
        return localization.pagebuilder_layout_menu_alignment_bottom_right;
      default:
        return localization.pagebuilder_layout_menu_alignment_center;
    }
  }
}
