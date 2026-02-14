import 'package:flutter/material.dart';

class PagebuilderInvisibleColorFilter extends StatelessWidget {
  final bool isVisible;
  final Widget child;

  const PagebuilderInvisibleColorFilter({
    super.key,
    required this.isVisible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isVisible) {
      return child;
    }

    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.grey,
        BlendMode.saturation,
      ),
      child: Opacity(
        opacity: 0.6,
        child: child,
      ),
    );
  }
}
