import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PagebuilderFontFamilyControl extends StatelessWidget {
  final String initialValue;
  final Function(String) onSelected;
  const PagebuilderFontFamilyControl(
      {super.key, required this.initialValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final dropDownEntries = [
      const DropdownMenuEntry<String>(value: "Poppins", label: "Poppins"),
      const DropdownMenuEntry<String>(value: "Merriweather", label: "Merriweather"),
      const DropdownMenuEntry<String>(value: "Roboto", label: "Roboto")
    ];
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(localization.landingpage_pagebuilder_text_config_font_family,
          style: themeData.textTheme.bodySmall),
      DropdownMenu<String>(
          width: 200,
          initialSelection: initialValue,
          enableSearch: false,
          requestFocusOnTap: false,
          dropdownMenuEntries: dropDownEntries,
          onSelected: (fontFamily) {
            onSelected(fontFamily ?? "");
          }),
    ]);
  }
}
