import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/app_bottom_sheet.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/bottom_sheet_wrapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum CustomDropdownType { underlined, standard }

class CustomDropdownItem<T> {
  final T value;
  final String label;
  final bool enabled;

  const CustomDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });
}

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<CustomDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;

  /// Label shown when no value is selected.
  /// For [CustomDropdownType.underlined]: shown as hint with underline.
  /// For [CustomDropdownType.standard]: shown as floating label.
  final String? label;

  final double? width;
  final TextStyle? textStyle;
  final CustomDropdownType type;
  final bool useDialogPicker;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.width,
    this.textStyle,
    this.type = CustomDropdownType.standard,
    this.useDialogPicker = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return _buildNative(context);
    }
    return switch (type) {
      CustomDropdownType.underlined => _buildUnderlined(context),
      CustomDropdownType.standard => _buildStandard(context),
    };
  }

  void _showPicker(BuildContext context) {
    if (useDialogPicker) {
      _showDialogPicker(context);
    } else {
      _showBottomSheetPicker(context);
    }
  }

  void _showBottomSheetPicker(BuildContext context) {
    showAppBottomSheet(
      context,
      builder: (ctx) => BottomSheetWrapper(
        title: label ?? '',
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.5,
          ),
          child: ListView(
            shrinkWrap: true,
            children: items.map((item) {
              final isSelected = item.value == value;
              return ListTile(
                title: Text(item.label),
                enabled: item.enabled,
                selected: isSelected,
                trailing: isSelected
                    ? Icon(Icons.check,
                        color: Theme.of(ctx).colorScheme.secondary)
                    : null,
                onTap: item.enabled
                    ? () {
                        CustomNavigator.of(ctx).pop();
                        onChanged?.call(item.value);
                      }
                    : null,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showDialogPicker(BuildContext context) {
    T? tempSelected = value;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => CustomAlertDialog(
          title: label ?? '',
          message: '',
          messageWidget: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.4,
            ),
            child: ListView(
              shrinkWrap: true,
              children: items.map((item) {
                final isSelected = item.value == tempSelected;
                return ListTile(
                  title: Text(item.label),
                  enabled: item.enabled,
                  selected: isSelected,
                  trailing: isSelected
                      ? Icon(Icons.check,
                          color: Theme.of(ctx).colorScheme.secondary)
                      : null,
                  onTap: item.enabled
                      ? () => setDialogState(() => tempSelected = item.value)
                      : null,
                );
              }).toList(),
            ),
          ),
          actionButtonTitle: AppLocalizations.of(context).pagebuilder_ok,
          actionButtonAction: () {
            CustomNavigator.of(ctx).pop();
            onChanged?.call(tempSelected);
          },
        ),
      ),
    );
  }

  Widget _buildNative(BuildContext context) {
    return switch (type) {
      CustomDropdownType.underlined => _buildNativeUnderlined(context),
      CustomDropdownType.standard => _buildNativeStandard(context),
    };
  }

  Widget _buildNativeUnderlined(BuildContext context) {
    final themeData = Theme.of(context);
    final selectedItem = items.where((i) => i.value == value).firstOrNull;
    final displayText = selectedItem?.label;

    return GestureDetector(
      onTap: onChanged != null ? () => _showPicker(context) : null,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: themeData.colorScheme.secondary,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: themeData.colorScheme.secondary,
            ),
            const SizedBox(width: 4),
            Text(
              displayText ?? label ?? '',
              style: (textStyle ?? themeData.textTheme.bodyMedium)?.copyWith(
                color: displayText != null
                    ? themeData.colorScheme.onSurface
                    : themeData.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNativeStandard(BuildContext context) {
    final themeData = Theme.of(context);
    final selectedItem = items.where((i) => i.value == value).firstOrNull;
    final displayText = selectedItem?.label;

    Widget content = GestureDetector(
      onTap: onChanged != null ? () => _showPicker(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: textStyle,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          displayText ?? '',
          style: textStyle ?? themeData.textTheme.bodyMedium,
        ),
      ),
    );

    if (width != null) {
      content = SizedBox(width: width, child: content);
    }

    return content;
  }

  Widget _buildUnderlined(BuildContext context) {
    final themeData = Theme.of(context);

    final dropdownItems = items
        .map((item) => DropdownMenuItem<T>(
              value: item.value,
              enabled: item.enabled,
              child: Text(item.label),
            ))
        .toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        hint: label != null
            ? Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: themeData.colorScheme.secondary,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: themeData.colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label!,
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        color: themeData.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        selectedItemBuilder: (context) {
          return items.map((item) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: themeData.colorScheme.secondary,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: themeData.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.label,
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      color: themeData.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
        items: dropdownItems,
        onChanged: onChanged,
        icon: const SizedBox.shrink(),
        isDense: true,
        style: textStyle ?? themeData.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildStandard(BuildContext context) {
    final themeData = Theme.of(context);

    final entries = items
        .map((item) => DropdownMenuEntry<T>(
              value: item.value,
              label: item.label,
              enabled: item.enabled,
            ))
        .toList();

    Widget menu = DropdownMenu<T>(
      textStyle: textStyle ?? themeData.textTheme.bodyMedium,
      width: width,
      label: label != null ? Text(label!) : null,
      initialSelection: value,
      enableSearch: false,
      requestFocusOnTap: false,
      dropdownMenuEntries: entries,
      onSelected: onChanged,
    );

    return menu;
  }
}
