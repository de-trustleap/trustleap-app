import 'package:flutter/material.dart';

class PagebuilderFontFamilyControl extends StatelessWidget {
  final String initialValue;
  final Function(String) onSelected;
  const PagebuilderFontFamilyControl(
      {super.key, required this.initialValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final dropDownEntries = [
      DropdownMenuEntry<String>(value: "Poppins", label: "Poppins"),
      DropdownMenuEntry<String>(value: "Merriweather", label: "Merriweather"),
      DropdownMenuEntry<String>(value: "Roboto", label: "Roboto")
    ];
    final themeData = Theme.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("Schriftart", style: themeData.textTheme.bodySmall),
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
