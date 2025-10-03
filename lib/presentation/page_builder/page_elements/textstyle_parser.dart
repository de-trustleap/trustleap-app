import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';

class TextStyleParser {
  TextStyle getTextStyleFromProperties(PageBuilderTextProperties? properties) {
    return TextStyle(
        fontSize: properties?.fontSize?.getValue(),
        fontFamily: properties?.fontFamily,
        fontFamilyFallback: const ["Poppins"],
        height: properties?.lineHeight?.getValue() ?? 1.0,
        letterSpacing: properties?.letterSpacing?.getValue(),
        color: properties?.color,
        shadows: properties?.textShadow != null
            ? [
                Shadow(
                    color: properties?.textShadow?.color ?? Colors.black,
                    blurRadius: properties?.textShadow?.blurRadius ?? 0,
                    offset: properties?.textShadow?.offset ?? const Offset(0, 0))
              ]
            : null,
        fontWeight:
            properties?.isBold == true ? FontWeight.bold : FontWeight.normal,
        fontStyle:
            properties?.isItalic == true ? FontStyle.italic : FontStyle.normal);
  }
}
