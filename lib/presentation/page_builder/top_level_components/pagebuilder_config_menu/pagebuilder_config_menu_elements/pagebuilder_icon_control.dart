import 'package:finanzbegleiter/core/helpers/icon_utility.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class PagebuilderIconControl extends StatefulWidget {
  final String title;
  final String? initialIcon;
  final Function(String?) onSelected;
  const PagebuilderIconControl(
      {super.key,
      required this.title,
      required this.initialIcon,
      required this.onSelected});

  @override
  State<PagebuilderIconControl> createState() => _PagebuilderIconControlState();
}

class _PagebuilderIconControlState extends State<PagebuilderIconControl> {
  Icon? _pickedIcon;

  @override
  void initState() {
    super.initState();
    if (widget.initialIcon != null) {
      _pickedIcon = Icon(IconUtility.getIconFromHexCode(widget.initialIcon));
    }
  }

  Future<void> _pickIcon(
      ThemeData themeData, AppLocalizations localization) async {
    print('==================== ICON PICKER OPENED ====================');
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
          iconPackModes: [IconPack.allMaterial],
          iconColor: themeData.colorScheme.surfaceTint,
          title: Text(
              localization
                  .landingpage_pagebuilder_icon_config_icon_picker_title,
              style: themeData.textTheme.bodyMedium),
          closeChild: Text(
              localization
                  .landingpage_pagebuilder_icon_config_icon_picker_close,
              style: themeData.textTheme.bodyMedium),
          searchHintText: localization
              .landingpage_pagebuilder_icon_config_icon_picker_search,
          noResultsText: localization
              .landingpage_pagebuilder_icon_config_icon_picker_search_no_results),
    );

    print('Icon picker closed. Icon selected: ${icon != null}');

    if (icon != null) {
      final hexCodePoint = icon.data.codePoint.toRadixString(16);
      print('==================== ICON SELECTED ====================');
      print('Icon name: ${icon.data.toString()}');
      print('Codepoint (decimal): ${icon.data.codePoint}');
      print('Codepoint (hex): 0x$hexCodePoint');
      print('For Flutter use: Icon(IconData(0x$hexCodePoint, fontFamily: \'MaterialIcons\'))');
      print('========================================================');

      setState(() {
        _pickedIcon = Icon(icon.data);
      });
      widget.onSelected(hexCodePoint);
    } else {
      print('No icon selected (cancelled)');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title, style: themeData.textTheme.bodySmall),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(
              _pickedIcon?.icon ??
                  IconUtility.getIconFromHexCode(widget.initialIcon),
              size: 48,
              color: themeData.colorScheme.surfaceTint),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => _pickIcon(themeData, localization),
            icon: Icon(Icons.edit,
                color: themeData.colorScheme.secondary, size: 24),
          )
        ]),
      ],
    );
  }
}
