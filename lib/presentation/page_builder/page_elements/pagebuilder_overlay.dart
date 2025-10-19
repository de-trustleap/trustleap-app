import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PagebuilderOverlay {
  static void show({
    required BuildContext context,
    required Widget content,
    Offset? position,
    bool positionRelativeToWidget = false,
  }) {
    Offset? calculatedPosition;

    if (positionRelativeToWidget && position == null) {
      // Calculate position relative to the widget that triggered the overlay
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        final Offset offset = box.localToGlobal(Offset.zero);
        final Size size = box.size;
        // Position overlay above and centered on the widget
        calculatedPosition = Offset(
          offset.dx + size.width / 2 - 200,
          offset.dy - 120,
        );
      }
    } else {
      calculatedPosition = position;
    }

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _DraggableOverlay(
          content: content,
          initialPosition: calculatedPosition,
        );
      },
    );
  }
}

class _DraggableOverlay extends StatefulWidget {
  final Widget content;
  final Offset? initialPosition;

  const _DraggableOverlay({
    required this.content,
    this.initialPosition,
  });

  @override
  State<_DraggableOverlay> createState() => _DraggableOverlayState();
}

class _DraggableOverlayState extends State<_DraggableOverlay> {
  late Offset _position;
  bool _isDragging = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final screenWidth = responsiveValue.screenWidth;
    final screenHeight = MediaQuery.of(context).size.height;

    // Initialize position on first build
    if (!_initialized) {
      if (widget.initialPosition != null) {
        _position = widget.initialPosition!;
      } else {
        // Center the overlay, but ensure it doesn't go off screen
        _position = Offset(
          (screenWidth / 2 - 200).clamp(16, screenWidth - 416),
          (screenHeight / 2 - 300).clamp(80, screenHeight - 600),
        );
      }
      _initialized = true;
    }

    // Ensure position stays within screen bounds
    _position = Offset(
      _position.dx.clamp(0, screenWidth - 400),
      _position.dy.clamp(0, screenHeight - 100),
    );

    return Stack(
      children: [
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: (details) {
              setState(() {
                _position = Offset(
                  (_position.dx + details.delta.dx).clamp(0, screenWidth - 400),
                  (_position.dy + details.delta.dy).clamp(0, screenHeight - 100),
                );
              });
            },
            onPanStart: (details) {
              setState(() {
                _isDragging = true;
              });
            },
            onPanEnd: (details) {
              setState(() {
                _isDragging = false;
              });
            },
            child: Material(
              elevation: _isDragging ? 12 : 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: themeData.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: themeData.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: widget.content,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
