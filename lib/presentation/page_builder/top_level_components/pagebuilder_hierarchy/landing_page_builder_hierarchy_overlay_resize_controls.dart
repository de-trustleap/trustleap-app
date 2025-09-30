import 'package:flutter/material.dart';

class LandingPageBuilderHierarchyOverlayResizeControls extends StatelessWidget {
  final double width;
  final double height;
  final Offset position;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final Function(double width, double height, Offset position) onResize;
  final VoidCallback onResizeStart;
  final VoidCallback onResizeEnd;

  const LandingPageBuilderHierarchyOverlayResizeControls({
    super.key,
    required this.width,
    required this.height,
    required this.position,
    required this.minWidth,
    required this.maxWidth,
    required this.minHeight,
    required this.maxHeight,
    required this.onResize,
    required this.onResizeStart,
    required this.onResizeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildResizeHandle(
          top: 0,
          left: 0,
          width: 8,
          height: 8,
          cursor: SystemMouseCursors.resizeUpLeft,
          onPanUpdate: (delta) {
            final newWidth = width - delta.dx;
            final newHeight = height - delta.dy;
            var newPosition = position;

            if (newWidth >= minWidth && newWidth <= maxWidth) {
              newPosition = Offset(newPosition.dx + delta.dx, newPosition.dy);
            }
            if (newHeight >= minHeight && newHeight <= maxHeight) {
              newPosition = Offset(newPosition.dx, newPosition.dy + delta.dy);
            }

            onResize(
              newWidth.clamp(minWidth, maxWidth),
              newHeight.clamp(minHeight, maxHeight),
              newPosition,
            );
          },
        ),
        _buildResizeHandle(
          top: 0,
          right: 0,
          width: 8,
          height: 8,
          cursor: SystemMouseCursors.resizeUpRight,
          onPanUpdate: (delta) {
            final newWidth = width + delta.dx;
            final newHeight = height - delta.dy;
            var newPosition = position;

            if (newHeight >= minHeight && newHeight <= maxHeight) {
              newPosition = Offset(newPosition.dx, newPosition.dy + delta.dy);
            }

            onResize(
              newWidth.clamp(minWidth, maxWidth),
              newHeight.clamp(minHeight, maxHeight),
              newPosition,
            );
          },
        ),
        _buildResizeHandle(
          bottom: 0,
          left: 0,
          width: 8,
          height: 8,
          cursor: SystemMouseCursors.resizeDownLeft,
          onPanUpdate: (delta) {
            final newWidth = width - delta.dx;
            final newHeight = height + delta.dy;
            var newPosition = position;

            if (newWidth >= minWidth && newWidth <= maxWidth) {
              newPosition = Offset(newPosition.dx + delta.dx, newPosition.dy);
            }

            onResize(
              newWidth.clamp(minWidth, maxWidth),
              newHeight.clamp(minHeight, maxHeight),
              newPosition,
            );
          },
        ),
        _buildResizeHandle(
          bottom: 0,
          right: 0,
          width: 8,
          height: 8,
          cursor: SystemMouseCursors.resizeDownRight,
          onPanUpdate: (delta) {
            onResize(
              (width + delta.dx).clamp(minWidth, maxWidth),
              (height + delta.dy).clamp(minHeight, maxHeight),
              position,
            );
          },
        ),
        // Edge resize handles
        _buildResizeHandle(
          top: 0,
          left: 8,
          right: 8,
          height: 4,
          cursor: SystemMouseCursors.resizeRow,
          onPanUpdate: (delta) {
            final newHeight = height - delta.dy;
            var newPosition = position;

            if (newHeight >= minHeight && newHeight <= maxHeight) {
              newPosition = Offset(newPosition.dx, newPosition.dy + delta.dy);
            }

            onResize(
              width,
              newHeight.clamp(minHeight, maxHeight),
              newPosition,
            );
          },
        ),
        _buildResizeHandle(
          bottom: 0,
          left: 8,
          right: 8,
          height: 4,
          cursor: SystemMouseCursors.resizeRow,
          onPanUpdate: (delta) {
            onResize(
              width,
              (height + delta.dy).clamp(minHeight, maxHeight),
              position,
            );
          },
        ),
        _buildResizeHandle(
          top: 8,
          bottom: 8,
          left: 0,
          width: 4,
          cursor: SystemMouseCursors.resizeColumn,
          onPanUpdate: (delta) {
            final newWidth = width - delta.dx;
            var newPosition = position;

            if (newWidth >= minWidth && newWidth <= maxWidth) {
              newPosition = Offset(newPosition.dx + delta.dx, newPosition.dy);
            }

            onResize(
              newWidth.clamp(minWidth, maxWidth),
              height,
              newPosition,
            );
          },
        ),
        _buildResizeHandle(
          top: 8,
          bottom: 8,
          right: 0,
          width: 4,
          cursor: SystemMouseCursors.resizeColumn,
          onPanUpdate: (delta) {
            onResize(
              (width + delta.dx).clamp(minWidth, maxWidth),
              height,
              position,
            );
          },
        ),
      ],
    );
  }

  Widget _buildResizeHandle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? width,
    double? height,
    required MouseCursor cursor,
    required Function(Offset delta) onPanUpdate,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: MouseRegion(
        cursor: cursor,
        child: GestureDetector(
          onPanUpdate: (details) => onPanUpdate(details.delta),
          onPanStart: (details) => onResizeStart(),
          onPanEnd: (details) => onResizeEnd(),
          behavior:
              HitTestBehavior.translucent, // Only intercept when actually hit
          child: SizedBox(
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }
}
