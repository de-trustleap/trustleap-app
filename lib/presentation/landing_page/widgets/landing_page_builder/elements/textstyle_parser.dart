import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';

class TextStyleParser {
  TextStyle getTextStyleFromProperties(PageBuilderTextProperties? properties) {
    return TextStyle(
        fontSize: properties?.fontSize,
        fontFamily: properties?.fontFamily,
        fontFamilyFallback: const ["Poppins"],
        height: properties?.lineHeight,
        color: properties?.color,
        fontWeight:
            properties?.isBold == true ? FontWeight.bold : FontWeight.normal,
        fontStyle:
            properties?.isItalic == true ? FontStyle.italic : FontStyle.normal);
  }
}
