import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:flutter/material.dart';

/// Helper class to detect drop position based on mouse position within a widget.
///
/// Uses a 30% threshold to determine if the mouse is near edges (top/bottom/left/right).
/// Uses a 15% threshold to determine if cursor is in center area for "inside" drops.
/// The priority of position detection depends on the parent container type:
/// - For Rows: Prioritizes vertical positioning (top/bottom) over horizontal (left/right)
/// - For Columns: Prioritizes horizontal positioning (left/right) over vertical (top/bottom)
class PagebuilderDragPositionDetector {
  static const double edgeThreshold = 0.3;
  static const double centerThreshold = 0.15;

  static DropPosition detectPosition({
    required Offset localPosition,
    required Size size,
    required bool isLastItem,
    required bool isInRow,
  }) {
    final leftEdge = localPosition.dx < size.width * edgeThreshold;
    final rightEdge = localPosition.dx > size.width * (1 - edgeThreshold);
    final topEdge = localPosition.dy < size.height * edgeThreshold;
    final bottomEdge = localPosition.dy > size.height * (1 - edgeThreshold);

    if (isInRow) {
      if (topEdge) return DropPosition.above;
      if (bottomEdge) return DropPosition.below;
      if (leftEdge) return DropPosition.before;
      if (rightEdge) return DropPosition.after;

      return DropPosition.above;
    } else {
      if (leftEdge) return DropPosition.before;
      if (rightEdge) return DropPosition.after;
      if (bottomEdge && isLastItem) return DropPosition.below;
      if (topEdge) return DropPosition.above;

      return DropPosition.above;
    }
  }

  static DropPosition? detectPositionFromRenderBox({
    required GlobalKey itemKey,
    required Offset globalOffset,
    required bool isLastItem,
    required bool isInRow,
  }) {
    final renderBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final localPosition = renderBox.globalToLocal(globalOffset);
    final size = renderBox.size;

    return detectPosition(
      localPosition: localPosition,
      size: size,
      isLastItem: isLastItem,
      isInRow: isInRow,
    );
  }

  /// Checks if the drag position is in the center area of the target.
  ///
  /// Returns true if the position is not near the edges (15% threshold).
  /// This indicates an "inside" drop for containers.
  static bool isInCenterArea({
    required RenderBox renderBox,
    required Offset globalOffset,
  }) {
    final localPosition = renderBox.globalToLocal(globalOffset);
    final size = renderBox.size;

    // Check if cursor is in the center area (not at edges)
    final isInCenterHorizontal = localPosition.dx > size.width * centerThreshold &&
                                   localPosition.dx < size.width * (1 - centerThreshold);
    final isInCenterVertical = localPosition.dy > size.height * centerThreshold &&
                                 localPosition.dy < size.height * (1 - centerThreshold);

    return isInCenterHorizontal && isInCenterVertical;
  }

  /// Determines the final drop position for a container target.
  ///
  /// If the target is a container and the cursor is in the center area,
  /// returns [DropPosition.inside]. Otherwise, returns the original detected position.
  static DropPosition adjustPositionForContainer({
    required DropPosition detectedPosition,
    required bool targetIsContainer,
    required GlobalKey itemKey,
    required Offset globalOffset,
  }) {
    if (!targetIsContainer) {
      return detectedPosition;
    }

    final renderBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return detectedPosition;
    }

    if (isInCenterArea(renderBox: renderBox, globalOffset: globalOffset)) {
      return DropPosition.inside;
    }

    return detectedPosition;
  }
}
