// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_fonts.dart';
import 'package:flutter/material.dart';

class PageBuilderGlobalStyles extends Equatable {
  final PageBuilderGlobalColors? colors;
  final PageBuilderGlobalFonts? fonts;

  const PageBuilderGlobalStyles({
    required this.colors,
    required this.fonts,
  });

  Color? resolveColorReference(String value) {
    if (!value.startsWith('@') || colors == null) return null;

    final tokenName = value.substring(1);
    switch (tokenName) {
      case 'primary':
        return colors!.primary;
      case 'secondary':
        return colors!.secondary;
      case 'tertiary':
        return colors!.tertiary;
      case 'background':
        return colors!.background;
      case 'surface':
        return colors!.surface;
      default:
        return null;
    }
  }

  String? resolveFontReference(String value) {
    if (!value.startsWith('@') || fonts == null) return null;

    final tokenName = value.substring(1);
    switch (tokenName) {
      case 'headline':
        return fonts!.headline;
      case 'text':
        return fonts!.text;
      default:
        return null;
    }
  }

  PageBuilderGlobalStyles copyWith({
    PageBuilderGlobalColors? colors,
    PageBuilderGlobalFonts? fonts,
  }) {
    return PageBuilderGlobalStyles(
      colors: colors ?? this.colors,
      fonts: fonts ?? this.fonts,
    );
  }

  @override
  List<Object?> get props => [colors, fonts];
}
