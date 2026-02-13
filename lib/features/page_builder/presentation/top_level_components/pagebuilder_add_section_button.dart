import 'package:flutter/material.dart';

class PagebuilderAddSectionButton extends StatefulWidget {
  final String tooltip;
  final IconData icon;
  final double iconSize;
  final Color color;
  final VoidCallback onTap;

  const PagebuilderAddSectionButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.onTap,
  });

  @override
  State<PagebuilderAddSectionButton> createState() =>
      _PagebuilderAddSectionButtonState();
}

class _PagebuilderAddSectionButtonState
    extends State<PagebuilderAddSectionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(28),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _isHovered
                    ? Color.alphaBlend(
                        Colors.black.withValues(alpha: 0.15),
                        widget.color,
                      )
                    : widget.color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
