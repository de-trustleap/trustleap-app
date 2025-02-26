import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:flutter/material.dart';

class TooltipIcon extends StatefulWidget {
  final IconData icon;
  final String text;
  final String buttonText;
  final VoidCallback onPressed;
  final double tooltipOffset;

  const TooltipIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.buttonText,
    required this.onPressed,
    this.tooltipOffset = 30,
  });

  @override
  State<TooltipIcon> createState() => _TooltipIconState();
}

class _TooltipIconState extends State<TooltipIcon> {
  OverlayEntry? overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isMouseInside = false;

  void _showTooltip(BuildContext context) {
    _hideTooltip();

    final overlay = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 220,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, widget.tooltipOffset),
          child: MouseRegion(
            onEnter: (_) => _isMouseInside = true,
            onExit: (_) => _hideTooltip(),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 5)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.text,
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    ClickableLink(
                        title: widget.buttonText,
                        fontSize: 14,
                        onTap: () => {widget.onPressed()})
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry!);
  }

  void _hideTooltip() {
    overlayEntry?.remove();
    overlayEntry = null;
    _isMouseInside = false;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _isMouseInside = true;
        _showTooltip(context);
      },
      onExit: (_) {
        // Delay is needed here to make sure that the mouse can move from icon to tooltip
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!_isMouseInside) _hideTooltip();
        });
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Icon(widget.icon, color: Colors.red, size: 24),
      ),
    );
  }
}
