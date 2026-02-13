import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:flutter/material.dart';

class PagebuilderDragIndicators extends StatelessWidget {
  final bool isHovering;
  final DropPosition? libraryWidgetHoverPosition;
  final int? draggingIndex;
  final int index;
  final bool isLastItem;
  final bool hoveringAfterLast;
  final bool isInRow;
  final bool isSection;
  final bool expandHeight;
  final Widget child;

  const PagebuilderDragIndicators({
    super.key,
    required this.isHovering,
    required this.libraryWidgetHoverPosition,
    required this.draggingIndex,
    required this.index,
    required this.isLastItem,
    required this.hoveringAfterLast,
    required this.isInRow,
    this.isSection = false,
    this.expandHeight = false,
    required this.child,
  });

  Widget _buildStackWithIndicators(BuildContext context, bool showLeftIndicator, bool showRightIndicator) {
    return Stack(
      children: [
        child,
        if (showLeftIndicator)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        if (showRightIndicator)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showInsideIndicator =
        isHovering && libraryWidgetHoverPosition == DropPosition.inside;

    final bool showLeftIndicator;
    final bool showRightIndicator;
    final bool showTopIndicator;
    final bool showBottomIndicator;

    if (isInRow) {
      final showReorderIndicatorBefore =
          isHovering && draggingIndex != null && draggingIndex! > index;
      final showReorderIndicatorAfter =
          (isHovering && draggingIndex != null && (draggingIndex! < index)) ||
              (isLastItem && hoveringAfterLast);

      showLeftIndicator = !isSection &&
          ((isHovering && libraryWidgetHoverPosition == DropPosition.before) ||
              showInsideIndicator ||
              showReorderIndicatorBefore);
      showRightIndicator = !isSection &&
          ((isHovering && libraryWidgetHoverPosition == DropPosition.after) ||
              showInsideIndicator ||
              showReorderIndicatorAfter);
      showTopIndicator =
          (isHovering && (libraryWidgetHoverPosition == DropPosition.above)) ||
              showInsideIndicator;
      showBottomIndicator =
          (isHovering && libraryWidgetHoverPosition == DropPosition.below) ||
              showInsideIndicator;
    } else {
      final showIndicatorAfter = isLastItem && hoveringAfterLast;

      showLeftIndicator = !isSection &&
          ((isHovering && libraryWidgetHoverPosition == DropPosition.before) ||
              showInsideIndicator);
      showRightIndicator = !isSection &&
          ((isHovering && libraryWidgetHoverPosition == DropPosition.after) ||
              showInsideIndicator);
      showTopIndicator = (isHovering &&
              (libraryWidgetHoverPosition == DropPosition.above ||
                  libraryWidgetHoverPosition == null)) ||
          showInsideIndicator;
      showBottomIndicator = showIndicatorAfter || showInsideIndicator;
    }

    final stackWidget = _buildStackWithIndicators(context, showLeftIndicator, showRightIndicator);

    return Column(
      mainAxisSize: expandHeight ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (showTopIndicator &&
            (!showLeftIndicator || showInsideIndicator) &&
            (!showRightIndicator || showInsideIndicator))
          Container(
            height: 4,
            color: Theme.of(context).colorScheme.secondary,
          ),
        expandHeight ? Expanded(child: stackWidget) : stackWidget,
        if (showBottomIndicator)
          Container(
            height: 4,
            color: Theme.of(context).colorScheme.secondary,
          ),
      ],
    );
  }
}
