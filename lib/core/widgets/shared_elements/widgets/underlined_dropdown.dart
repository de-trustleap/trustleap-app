import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';

class UnderlinedDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool useDialogPicker;

  const UnderlinedDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.useDialogPicker = false,
  });

  @override
  Widget build(BuildContext context) {
    final customItems = items.map((item) {
      String label = '';
      if (item.child is Text) {
        label = (item.child as Text).data ?? '';
      }
      return CustomDropdownItem<T>(
        value: item.value as T,
        label: label,
        enabled: item.enabled,
      );
    }).toList();

    return CustomDropdown<T>(
      value: value,
      items: customItems,
      onChanged: onChanged,
      label: hint,
      type: CustomDropdownType.underlined,
      useDialogPicker: useDialogPicker,
    );
  }
}
