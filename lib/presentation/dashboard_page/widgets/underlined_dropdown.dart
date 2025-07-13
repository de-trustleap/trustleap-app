import 'package:flutter/material.dart';

class UnderlinedDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const UnderlinedDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: themeData.colorScheme.secondary,
            width: 1.0,
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          selectedItemBuilder: (context) {
            return items.map((item) {
              final itemWidget = item.child;
              String displayText = "";

              if (itemWidget is Text) {
                displayText = itemWidget.data ?? "";
              } else {
                displayText = itemWidget.toString();
              }

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: themeData.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    displayText,
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      color: themeData.colorScheme.onSurface,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: items,
          onChanged: onChanged,
          icon: const SizedBox.shrink(),
          isDense: true,
          style: themeData.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
