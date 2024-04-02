import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomTab extends StatefulWidget {
  final String title;
  final IconData icon;
  const CustomTab({required this.title, required this.icon, super.key});

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
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final hoveredTransform = Matrix4.identity()..scale(1.05);
    final transform = itemIsHovered ? hoveredTransform : Matrix4.identity();
    return SizedBox(
      width: responsiveValue.isMobile ? 200 : 400,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => hoverOnItem(true),
        onExit: (_) => hoverOnItem(false),
        child: Tab(
            child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: transform,
          curve: const Cubic(0.5, 0.8, 0.4, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceTint
                      .withOpacity(0.8)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(widget.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        )),
      ),
    );
  }
}
