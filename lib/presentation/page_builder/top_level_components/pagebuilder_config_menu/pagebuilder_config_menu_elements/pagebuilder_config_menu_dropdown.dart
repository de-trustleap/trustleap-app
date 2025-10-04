import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/alignment_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/axis_alignment_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/boxfit_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:flutter/material.dart';

enum PagebuilderDropdownType {
  contentMode,
  alignment,
  mainAxisAlignment,
  crossAxisAlignment
}

class PagebuilderConfigMenuDrowdown<T> extends StatelessWidget {
  final String title;
  final T initialValue;
  final PagebuilderDropdownType type;
  final Function(T) onSelected;
  final bool showResponsiveButton;
  final PagebuilderResponsiveBreakpoint? currentBreakpoint;
  final Function(PagebuilderResponsiveBreakpoint)? onBreakpointChanged;

  PagebuilderConfigMenuDrowdown(
      {super.key,
      required this.title,
      required this.initialValue,
      required this.type,
      required this.onSelected,
      this.showResponsiveButton = false,
      this.currentBreakpoint,
      this.onBreakpointChanged});

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
  final mainAxisAlignmentValues = [
    MainAxisAlignment.start,
    MainAxisAlignment.center,
    MainAxisAlignment.end,
    MainAxisAlignment.spaceBetween,
    MainAxisAlignment.spaceEvenly,
    MainAxisAlignment.spaceAround
  ];
  final crossAxisAlignmentValues = [
    CrossAxisAlignment.start,
    CrossAxisAlignment.center,
    CrossAxisAlignment.end,
    CrossAxisAlignment.stretch,
    CrossAxisAlignment.baseline
  ];

  List<DropdownMenuEntry<T>> createDropdownEntries(
      AppLocalizations localization) {
    List<DropdownMenuEntry<T>> entries = [];
    var values = [];
    switch (type) {
      case PagebuilderDropdownType.contentMode:
        values = contentModeValues;
      case PagebuilderDropdownType.alignment:
        values = alignmentValues;
      case PagebuilderDropdownType.mainAxisAlignment:
        values = mainAxisAlignmentValues;
      case PagebuilderDropdownType.crossAxisAlignment:
        values = crossAxisAlignmentValues;
    }
    for (var value in values) {
      var entry = DropdownMenuEntry<T>(
          value: value, label: _getLabel(value, localization) ?? "");
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
          return AlignmentMapper.getLocalizedStringFromAlignment(
              value, localization);
        } else {
          return null;
        }
      case PagebuilderDropdownType.mainAxisAlignment:
        if (value is MainAxisAlignment) {
          return AxisAlignmentMapper.getStringFromMainAxisAlignment(value);
        } else {
          return null;
        }
      case PagebuilderDropdownType.crossAxisAlignment:
        if (value is CrossAxisAlignment) {
          return AxisAlignmentMapper.getStringFromCrossAxisAlignment(value);
        } else {
          return null;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Row(
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: themeData.textTheme.bodySmall,
          ),
          const SizedBox(width: 8),
        ],
        if (showResponsiveButton &&
            currentBreakpoint != null &&
            onBreakpointChanged != null) ...[
          PagebuilderBreakpointSelector(
            currentBreakpoint: currentBreakpoint!,
            onBreakpointChanged: (breakpoint) {
              onBreakpointChanged!(breakpoint);
            },
          ),
          const SizedBox(width: 8),
        ],
        const Spacer(),
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
      ],
    );
  }
}
