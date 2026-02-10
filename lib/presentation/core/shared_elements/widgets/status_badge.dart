import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool isPositive;
  final String label;

  const StatusBadge({
    super.key,
    required this.isPositive,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? themeData.colorScheme.primary.withValues(alpha: 0.1)
            : themeData.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label.toUpperCase(),
        style: themeData.textTheme.labelSmall?.copyWith(
          color: isPositive
              ? themeData.colorScheme.primary
              : themeData.colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
