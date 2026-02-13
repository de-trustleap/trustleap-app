import 'package:finanzbegleiter/core/helpers/device_detection.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/clickable_link.dart';
import 'package:flutter/material.dart';

class TooltipBase extends StatefulWidget {
  final Widget child;
  final String text;
  final String? buttonText;
  final bool showButton;
  final VoidCallback? onPressed;
  final double tooltipOffset;

  const TooltipBase({
    super.key,
    required this.child,
    required this.text,
    this.buttonText,
    this.onPressed,
    this.showButton = true,
    this.tooltipOffset = 30,
  });

  @override
  State<TooltipBase> createState() => _TooltipBaseState();
}

class _TooltipBaseState extends State<TooltipBase> {
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
                    if (widget.showButton) ...[
                      const SizedBox(height: 8),
                      ClickableLink(
                          title: widget.buttonText ?? "",
                          fontSize: 14,
                          onTap: () => widget.onPressed?.call())
                    ]
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
    if (DeviceDetection.isTouchDevice(context)) {
      // On touch devices: use tap gesture
      return GestureDetector(
        onTap: () => _showTooltip(context),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: widget.child,
        ),
      );
    } else {
      // On desktop: use hover
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
          child: widget.child,
        ),
      );
    }
  }
}