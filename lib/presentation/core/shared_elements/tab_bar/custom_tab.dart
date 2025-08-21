import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomTab extends StatefulWidget {
  final String title;
  final IconData icon;
  final ResponsiveBreakpointsData responsiveValue;

  const CustomTab({
    required this.title,
    required this.icon,
    required this.responsiveValue,
    super.key,
  });

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  bool itemIsHovered = false;

  void hoverOnItem(bool isHovering) => setState(() {
        itemIsHovered = isHovering;
      });

  @override
  Widget build(BuildContext context) {
    final scaleValue = itemIsHovered ? 1.05 : 1.0;
    
    return Tab(
      child: SizedBox(
        width: widget.responsiveValue.isMobile ? 200 : 400,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => hoverOnItem(true),
          onExit: (_) => hoverOnItem(false),
          child: AnimatedScale(
            scale: scaleValue,
            duration: const Duration(milliseconds: 300),
            curve: const Cubic(0.5, 0.8, 0.4, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceTint
                      .withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.title,
                    style: widget.responsiveValue.isMobile
                        ? Theme.of(context).textTheme.bodySmall
                        : Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}