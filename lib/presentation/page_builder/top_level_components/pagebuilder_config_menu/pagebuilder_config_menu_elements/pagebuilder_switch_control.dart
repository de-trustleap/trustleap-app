import 'package:flutter/material.dart';

class PagebuilderSwitchControl extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function(bool) onSelected;
  const PagebuilderSwitchControl(
      {super.key,
      required this.title,
      required this.isActive,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: themeData.textTheme.bodySmall),
      Switch(value: isActive, onChanged: (isSelected) => onSelected(isSelected))
    ]);
  }
}
