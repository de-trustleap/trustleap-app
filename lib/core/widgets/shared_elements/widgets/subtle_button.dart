import 'package:flutter/material.dart';

class SubtleButton extends StatelessWidget {
  final String title;
  final double? width;
  final bool disabled;
  final Function? onTap;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const SubtleButton({
    super.key,
    required this.title,
    this.onTap,
    this.width,
    this.disabled = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final bgColor = disabled
        ? Colors.grey[400]!
        : (backgroundColor ?? themeData.colorScheme.primary);
    final fgColor = textColor ?? Colors.white;

    return IgnorePointer(
      ignoring: disabled,
      child: InkWell(
        onTap: () => onTap?.call(),
        borderRadius: BorderRadius.circular(8),
        child: Container(
        height: 40,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: fgColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: themeData.textTheme.bodySmall!.copyWith(
                        color: fgColor,
                      ),
                    ),
                  ],
                )
              : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: fgColor,
                  ),
                ),
        ),
      ),
      ),
    );
  }
}
