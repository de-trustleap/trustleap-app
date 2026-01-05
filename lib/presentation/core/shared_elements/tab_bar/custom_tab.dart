import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomTab extends StatefulWidget {
  final String title;
  final IconData icon;
  final ResponsiveBreakpointsData responsiveValue;
  final double? availableWidth;
  final int totalTabs;

  const CustomTab({
    required this.title,
    required this.icon,
    required this.responsiveValue,
    this.availableWidth,
    this.totalTabs = 1,
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

  double? _calculateTabWidth() {
    if (widget.responsiveValue.isMobile && widget.availableWidth != null) {
      if (widget.totalTabs <= 3) {
        return (widget.availableWidth! / widget.totalTabs) - 8;
      } else {
        // For 4+ tabs, make them smaller to show scrollability
        return (widget.availableWidth! / 3.5) - 8;
      }
    }
    // For desktop with no availableWidth, return null to allow natural sizing
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final scaleValue = itemIsHovered ? 1.05 : 1.0;
    final tabWidth = _calculateTabWidth();

    return Tab(
      child: tabWidth != null
          ? SizedBox(
              width: tabWidth,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => hoverOnItem(true),
                onExit: (_) => hoverOnItem(false),
                child: AnimatedScale(
                  scale: scaleValue,
                  duration: const Duration(milliseconds: 300),
                  curve: const Cubic(0.5, 0.8, 0.4, 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        size: widget.responsiveValue.isMobile ? 16 : 20,
                        color: themeData.colorScheme.surfaceTint
                            .withValues(alpha: 0.8),
                      ),
                      SizedBox(width: widget.responsiveValue.isMobile ? 4 : 8),
                      Flexible(
                        child: Text(
                          widget.title,
                          style: themeData.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => hoverOnItem(true),
              onExit: (_) => hoverOnItem(false),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AnimatedScale(
                  scale: scaleValue,
                  duration: const Duration(milliseconds: 300),
                  curve: const Cubic(0.5, 0.8, 0.4, 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        size: widget.responsiveValue.isMobile ? 16 : 20,
                        color: themeData.colorScheme.surfaceTint
                            .withValues(alpha: 0.8),
                      ),
                      SizedBox(width: widget.responsiveValue.isMobile ? 4 : 8),
                      Flexible(
                        child: Text(
                          widget.title,
                          style: themeData.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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

// TODO: PROFILE PAGE DESKTOP MACHEN. HIER EIN GRID LAYOUT ERSTELLEN SODASS DIE CARDS AUCH NEBENEINANDER SEIN KÖNNEN.
// TODO: PROD UMGEBUNG VORBEREITEN
// TODO: CLOUD FUNCTIONS INSTANZEN EINSTELLEN
// TODO: RECHTLICHES
