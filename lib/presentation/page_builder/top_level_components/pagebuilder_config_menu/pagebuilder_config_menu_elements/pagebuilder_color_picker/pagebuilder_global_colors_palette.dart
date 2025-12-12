import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

class PagebuilderGlobalColorsPalette extends StatelessWidget {
  final PageBuilderGlobalColors? globalColors;
  final String? selectedToken;
  final Function(String token, Color color) onGlobalColorSelected;

  const PagebuilderGlobalColorsPalette({
    super.key,
    required this.globalColors,
    this.selectedToken,
    required this.onGlobalColorSelected,
  });

  Widget _buildColorItem({
    required BuildContext context,
    required String token,
    required String label,
    required Color? color,
    required ThemeData themeData,
  }) {
    if (color == null) return const SizedBox.shrink();

    final isSelected = selectedToken == token;

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () => onGlobalColorSelected(token, color),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? themeData.colorScheme.primary
                  : Colors.grey.withValues(alpha: 0.3),
              width: isSelected ? 3 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: themeData.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: isSelected
              ? Icon(
                  Icons.check,
                  color: _getContrastColor(color),
                  size: 20,
                )
              : null,
        ),
      ),
    );
  }

  Color _getContrastColor(Color background) {
    // Calculate relative luminance
    final r = (background.r * 255.0).round().clamp(0, 255);
    final g = (background.g * 255.0).round().clamp(0, 255);
    final b = (background.b * 255.0).round().clamp(0, 255);
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (globalColors == null) {
      return const SizedBox.shrink();
    }

    final colors = [
      if (globalColors!.primary != null)
        {
          'token': '@primary',
          'label': 'Primary',
          'color': globalColors!.primary!
        },
      if (globalColors!.secondary != null)
        {
          'token': '@secondary',
          'label': 'Secondary',
          'color': globalColors!.secondary!
        },
      if (globalColors!.tertiary != null)
        {
          'token': '@tertiary',
          'label': 'Tertiary',
          'color': globalColors!.tertiary!
        },
      if (globalColors!.background != null)
        {
          'token': '@background',
          'label': 'Background',
          'color': globalColors!.background!
        },
      if (globalColors!.surface != null)
        {
          'token': '@surface',
          'label': 'Surface',
          'color': globalColors!.surface!
        },
    ];

    if (colors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Global Colors',
          style: themeData.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: themeData.colorScheme.surfaceTint.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((colorData) {
            return _buildColorItem(
              context: context,
              token: colorData['token'] as String,
              label: colorData['label'] as String,
              color: colorData['color'] as Color,
              themeData: themeData,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Divider(
          color: themeData.colorScheme.surfaceTint.withValues(alpha: 0.2),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
