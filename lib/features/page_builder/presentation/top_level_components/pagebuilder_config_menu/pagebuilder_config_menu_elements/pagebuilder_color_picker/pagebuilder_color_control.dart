import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_gradient.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_picker_base.dart';
import 'package:flutter/material.dart';

class PagebuilderColorControl extends StatelessWidget {
  final String title;
  final Color initialColor;
  final PagebuilderGradient? initialGradient;
  final Function(Color, {String? token}) onColorSelected;
  final Function(PagebuilderGradient)? onGradientSelected;
  final bool enableOpacity;
  final bool enableGradients;
  final PageBuilderGlobalColors? globalColors;
  final String? selectedGlobalColorToken;

  const PagebuilderColorControl({
    super.key,
    required this.title,
    required this.initialColor,
    this.initialGradient,
    required this.onColorSelected,
    this.onGradientSelected,
    this.enableOpacity = true,
    this.enableGradients = true,
    this.globalColors,
    this.selectedGlobalColorToken,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: themeData.textTheme.bodySmall),
      PagebuilderColorPickerBase(
        initialColor: initialColor,
        initialGradient: initialGradient,
        onColorSelected: onColorSelected,
        onGradientSelected: onGradientSelected,
        enableOpacity: enableOpacity,
        enableGradients: enableGradients,
        globalColors: globalColors,
        selectedGlobalColorToken: selectedGlobalColorToken,
      )
    ]);
  }
}
