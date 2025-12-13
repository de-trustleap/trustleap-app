import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/helpers/pagebuilder_global_styles_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TextStyleParser {
  TextStyle getTextStyleFromProperties(
    PageBuilderTextProperties? properties, [
    PageBuilderGlobalStyles? globalStyles,
  ]) {
    final styles = globalStyles ?? _getGlobalStylesFromBloc();

    final resolver = PagebuilderGlobalStylesResolver(styles);
    final fontFamily = properties?.fontFamily != null
        ? resolver.resolveFontToken(properties!.fontFamily!)
        : null;

    return TextStyle(
      fontSize: properties?.fontSize?.getValue(),
      fontFamily: fontFamily,
      fontFamilyFallback: const ["Poppins"],
      height: properties?.lineHeight?.getValue() ?? 1.0,
      letterSpacing: properties?.letterSpacing?.getValue(),
      color: properties?.color,
      shadows: properties?.textShadow != null
          ? [
              Shadow(
                color: properties?.textShadow?.color ?? Colors.black,
                blurRadius: properties?.textShadow?.blurRadius ?? 0,
                offset: properties?.textShadow?.offset ?? const Offset(0, 0),
              )
            ]
          : null,
    );
  }

  PageBuilderGlobalStyles? _getGlobalStylesFromBloc() {
    try {
      final blocState = Modular.get<PagebuilderBloc>().state;
      return blocState is GetLandingPageAndUserSuccessState
          ? blocState.content.content?.globalStyles
          : null;
    } catch (e) {
      return null;
    }
  }
}
