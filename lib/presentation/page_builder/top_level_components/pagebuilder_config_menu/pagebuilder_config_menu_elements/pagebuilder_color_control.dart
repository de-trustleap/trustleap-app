import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker.dart';
import 'package:flutter/material.dart';

class PagebuilderColorControl extends StatelessWidget {
  final String title;
  final Color initialColor;
  final Function(Color) onSelected;
  final bool enableOpacity;
  const PagebuilderColorControl(
      {super.key, required this.title, required this.initialColor, required this.onSelected, this.enableOpacity = true});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: themeData.textTheme.bodySmall),
      PagebuilderColorPicker(initialColor: initialColor, onSelected: onSelected, enableOpacity: enableOpacity)
    ]);
  }
}
