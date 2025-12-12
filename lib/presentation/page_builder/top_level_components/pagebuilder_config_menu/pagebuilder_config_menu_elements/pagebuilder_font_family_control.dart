import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_fonts.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PagebuilderFontFamilyControl extends StatelessWidget {
  final String initialValue;
  final Function(String) onSelected;
  final PageBuilderGlobalFonts? globalFonts;
  final String? selectedGlobalFontToken;
  final String? label;

  const PagebuilderFontFamilyControl({
    super.key,
    required this.initialValue,
    required this.onSelected,
    this.globalFonts,
    this.selectedGlobalFontToken,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    final standardFonts = ["Poppins", "Merriweather", "Roboto"];
    final items = <DropdownMenuItem<String>>[];

    // Add global fonts if available
    if (globalFonts != null && (globalFonts!.headline != null || globalFonts!.text != null)) {
      // Add "Global" heading
      items.add(DropdownMenuItem<String>(
        enabled: false,
        value: "__global_header__",
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
          child: Text(
            "Global",
            style: themeData.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));

      if (globalFonts!.headline != null) {
        items.add(DropdownMenuItem<String>(
          value: "@headline",
          child: Text("Headline Font", style: TextStyle(fontFamily: globalFonts!.headline)),
        ));
      }

      if (globalFonts!.text != null) {
        items.add(DropdownMenuItem<String>(
          value: "@text",
          child: Text("Text Font", style: TextStyle(fontFamily: globalFonts!.text)),
        ));
      }

      // Add "Andere" heading only if we have global fonts
      items.add(DropdownMenuItem<String>(
        enabled: false,
        value: "__andere_header__",
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4.0),
          child: Text(
            "Andere",
            style: themeData.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
    }

    // Add standard fonts
    for (final font in standardFonts) {
      items.add(DropdownMenuItem<String>(
        value: font,
        child: Text(font, style: TextStyle(fontFamily: font)),
      ));
    }

    // Determine current value - if it's a token, use the token, otherwise use the font name
    final currentValue = selectedGlobalFontToken ?? initialValue;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label ?? localization.landingpage_pagebuilder_text_config_font_family,
          style: themeData.textTheme.bodySmall,
        ),
        Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: themeData.colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            items: items,
            isExpanded: true,
            onChanged: (value) {
              if (value != null &&
                  value != "__global_header__" &&
                  value != "__andere_header__") {
                onSelected(value);
              }
            },
            underline: const SizedBox.shrink(),
            icon: Icon(Icons.arrow_drop_down, color: themeData.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
