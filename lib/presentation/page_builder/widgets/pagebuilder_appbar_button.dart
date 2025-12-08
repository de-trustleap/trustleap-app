import 'package:flutter/material.dart';

class PagebuilderAppbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const PagebuilderAppbarButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: themeData.colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          iconSize: 24,
        ),
      ),
    );
  }
}
