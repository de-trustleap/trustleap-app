import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker.dart';
import 'package:flutter/material.dart';

class PagebuilderColorControl extends StatelessWidget {
  final Color initialColor;
  final Function(Color) onSelected;
  const PagebuilderColorControl(
      {super.key, required this.initialColor, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(localization.landingpage_pagebuilder_text_config_color,
          style: themeData.textTheme.bodySmall),
      PagebuilderColorPicker(initialColor: initialColor, onSelected: onSelected)
    ]);
  }
}
