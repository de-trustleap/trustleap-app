import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderReorderDimmingOverlay extends StatefulWidget {
  final Widget child;
  final double zoomScale;

  const PagebuilderReorderDimmingOverlay({
    super.key,
    required this.child,
    this.zoomScale = 1.0,
  });

  @override
  State<PagebuilderReorderDimmingOverlay> createState() =>
      _PagebuilderReorderDimmingOverlayState();
}

class _PagebuilderReorderDimmingOverlayState
    extends State<PagebuilderReorderDimmingOverlay> {
  final GlobalKey _overlayKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagebuilderDragCubit, bool>(
      bloc: Modular.get<PagebuilderDragCubit>(),
      builder: (context, isDragging) {
        final dragCubit = Modular.get<PagebuilderDragCubit>();
        final activeContainerKey = dragCubit.activeContainerKey;
        final activeContainerId = dragCubit.activeContainerId;

        // Check if dragging in hierarchy overlay
        final isDraggingInHierarchy = activeContainerId?.startsWith('hierarchy-overlay') ?? false;
        final shouldShowOverlay = isDragging;

        return Stack(
          children: [
            widget.child,
            if (shouldShowOverlay)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    key: _overlayKey,
                    painter: _OverlayPainter(
                      activeContainerKey: activeContainerKey,
                      overlayKey: _overlayKey,
                      zoomScale: widget.zoomScale,
                      isDraggingInHierarchy: isDraggingInHierarchy,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final GlobalKey? activeContainerKey;
  final GlobalKey overlayKey;
  final double zoomScale;
  final bool isDraggingInHierarchy;

  _OverlayPainter({
    required this.activeContainerKey,
    required this.overlayKey,
    this.zoomScale = 1.0,
    this.isDraggingInHierarchy = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // If dragging in hierarchy overlay, always draw full overlay without cutout
    if (isDraggingInHierarchy) {
      _drawFullOverlay(canvas, size);
      return;
    }

    final containerRenderBox =
        activeContainerKey?.currentContext?.findRenderObject() as RenderBox?;
    final overlayRenderBox =
        overlayKey.currentContext?.findRenderObject() as RenderBox?;

    if (containerRenderBox != null &&
        containerRenderBox.hasSize &&
        overlayRenderBox != null) {
      try {
        // Get container position relative to overlay
        final containerGlobalOffset =
            containerRenderBox.localToGlobal(Offset.zero);
        final overlayGlobalOffset = overlayRenderBox.localToGlobal(Offset.zero);
        final relativeOffset = containerGlobalOffset - overlayGlobalOffset;

        final scaledSize = containerRenderBox.size * zoomScale;
        final containerRect = relativeOffset & scaledSize;

        // Draw dimmed overlay with hole by drawing 4 rectangles around the container
        final paint = Paint()
          ..color = Colors.black.withValues(alpha: 0.5)
          ..style = PaintingStyle.fill;

        // Top rectangle (above container)
        if (containerRect.top > 0) {
          canvas.drawRect(
            Rect.fromLTRB(0, 0, size.width, containerRect.top),
            paint,
          );
        }

        // Bottom rectangle (below container)
        if (containerRect.bottom < size.height) {
          canvas.drawRect(
            Rect.fromLTRB(0, containerRect.bottom, size.width, size.height),
            paint,
          );
        }

        // Left rectangle (left of container)
        if (containerRect.left > 0) {
          canvas.drawRect(
            Rect.fromLTRB(
                0, containerRect.top, containerRect.left, containerRect.bottom),
            paint,
          );
        }

        // Right rectangle (right of container)
        if (containerRect.right < size.width) {
          canvas.drawRect(
            Rect.fromLTRB(containerRect.right, containerRect.top, size.width,
                containerRect.bottom),
            paint,
          );
        }
      } catch (e) {
        _drawFullOverlay(canvas, size);
      }
    } else {
      _drawFullOverlay(canvas, size);
    }
  }

  void _drawFullOverlay(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) {
    return oldDelegate.activeContainerKey != activeContainerKey ||
        oldDelegate.overlayKey != overlayKey ||
        oldDelegate.zoomScale != zoomScale ||
        oldDelegate.isDraggingInHierarchy != isDraggingInHierarchy;
  }
}
