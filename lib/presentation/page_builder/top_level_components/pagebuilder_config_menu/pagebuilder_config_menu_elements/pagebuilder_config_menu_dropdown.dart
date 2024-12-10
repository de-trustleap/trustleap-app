import 'package:finanzbegleiter/infrastructure/models/model_helper/alignment_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/boxfit_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

enum PagebuilderDropdownType { contentMode, alignment }

class PagebuilderConfigMenuDrowdown<T> extends StatelessWidget {
  final String title;
  final T initialValue;
  final PagebuilderDropdownType type;
  final Function(T) onSelected;
  PagebuilderConfigMenuDrowdown(
      {super.key,
      required this.title,
      required this.initialValue,
      required this.type,
      required this.onSelected});

  final contentModeValues = [BoxFit.cover, BoxFit.contain, BoxFit.fill];
  final alignmentValues = [
    Alignment.center,
    Alignment.centerLeft,
    Alignment.centerRight,
    Alignment.topCenter,
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomCenter,
    Alignment.bottomLeft,
    Alignment.bottomRight
  ];

  List<DropdownMenuEntry<T>> createDropdownEntries(AppLocalizations localization) {
    List<DropdownMenuEntry<T>> entries = [];
    var values = [];
    switch (type) {
      case PagebuilderDropdownType.contentMode:
        values = contentModeValues;
      case PagebuilderDropdownType.alignment:
        values = alignmentValues;
    }
    for (var value in values) {
      var entry =
          DropdownMenuEntry<T>(value: value, label: _getLabel(value, localization) ?? "");
      entries.add(entry);
    }
    return entries;
  }

  String? _getLabel(T value, AppLocalizations localization) {
    switch (type) {
      case PagebuilderDropdownType.contentMode:
        if (value is BoxFit) {
          return BoxFitMapper.getStringFromBoxFit(value);
        } else {
          return null;
        }
      case PagebuilderDropdownType.alignment:
        if (value is Alignment) {
          return AlignmentMapper.getLocalizedStringFromAlignment(value, localization);
        } else {
          return null;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: themeData.textTheme.bodySmall,
      ),
      DropdownMenu<T>(
        width: 180,
        initialSelection: initialValue,
        enableSearch: false,
        requestFocusOnTap: false,
        dropdownMenuEntries: createDropdownEntries(localization),
        onSelected: (value) {
          if (value != null) {
            onSelected(value);
          }
        },
        menuStyle: MenuStyle(
          elevation: WidgetStateProperty.all(4),
          alignment: AlignmentDirectional.topStart,
        ),
      ),
    ]);
  }
}
