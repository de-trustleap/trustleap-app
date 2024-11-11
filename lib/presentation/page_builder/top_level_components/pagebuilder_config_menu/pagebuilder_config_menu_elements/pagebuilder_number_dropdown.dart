import 'package:flutter/material.dart';

class PagebuilderNumberDropdown extends StatelessWidget {
  final String title;
  final double initialValue;
  final List<double> numbers;
  final Function(double) onSelected;
  const PagebuilderNumberDropdown(
      {super.key,
      required this.title,
      required this.initialValue,
      required this.numbers,
      required this.onSelected});

  List<DropdownMenuEntry<double>> createDropdownEntries() {
    List<DropdownMenuEntry<double>> entries = [];
    for (var number in numbers) {
      var entry = DropdownMenuEntry<double>(value: number, label: "$number");
      entries.add(entry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: themeData.textTheme.bodySmall),
      DropdownMenu<double>(
          width: 100,
          initialSelection: initialValue,
          enableSearch: false,
          requestFocusOnTap: false,
          dropdownMenuEntries: createDropdownEntries(),
          onSelected: (number) {
            onSelected(number ?? 0.0);
          },
                    menuStyle: MenuStyle(
            elevation: WidgetStateProperty.all(4), // Optional für Schatten
            fixedSize: WidgetStateProperty.all(const Size(100, 200)), // Größe festlegen
            alignment: AlignmentDirectional.topStart, // Dropdown-Ausrichtung
          ),),
    ]);
  }
}
