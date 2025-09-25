import 'package:flutter/material.dart';

class PagebuilderColorGradientTabBar extends StatelessWidget {
  final bool isColorMode;
  final Function(bool) onTabChanged;

  const PagebuilderColorGradientTabBar({
    super.key,
    required this.isColorMode,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTabChanged(true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isColorMode
                  ? themeData.colorScheme.secondary
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              border: Border.all(
                color: isColorMode ? themeData.primaryColor : Colors.grey,
              ),
            ),
            child: Text("Farbe",
                style: themeData.textTheme.bodyMedium!.copyWith(
                    color: isColorMode ? Colors.white : Colors.grey.shade800,
                    fontWeight:
                        isColorMode ? FontWeight.bold : FontWeight.normal)),
          ),
        ),
        GestureDetector(
          onTap: () => onTabChanged(false),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: !isColorMode
                  ? themeData.colorScheme.secondary
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(
                color: !isColorMode ? themeData.primaryColor : Colors.grey,
              ),
            ),
            child: Text(
              "Farbverlauf",
              style: themeData.textTheme.bodyMedium!.copyWith(
                  color: isColorMode ? Colors.grey.shade800 : Colors.white,
                  fontWeight:
                      isColorMode ? FontWeight.normal : FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
