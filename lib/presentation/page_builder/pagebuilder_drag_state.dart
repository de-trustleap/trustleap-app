import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';

class PagebuilderDragState<T> {
  final List<T>? reorderedItems;
  final int? draggingIndex;
  final int? hoveringIndex;
  final bool hoveringAfterLast;
  final bool leftDownwards;
  final DropPosition? libraryWidgetHoverPosition;

  const PagebuilderDragState({
    this.reorderedItems,
    this.draggingIndex,
    this.hoveringIndex,
    this.hoveringAfterLast = false,
    this.leftDownwards = false,
    this.libraryWidgetHoverPosition,
  });

  PagebuilderDragState<T> copyWith({
    List<T>? reorderedItems,
    int? draggingIndex,
    int? hoveringIndex,
    bool? hoveringAfterLast,
    bool? leftDownwards,
    DropPosition? libraryWidgetHoverPosition,
    bool clearReorderedItems = false,
    bool clearDraggingIndex = false,
    bool clearHoveringIndex = false,
    bool clearLibraryWidgetHoverPosition = false,
  }) {
    return PagebuilderDragState<T>(
      reorderedItems: clearReorderedItems
          ? null
          : (reorderedItems ?? this.reorderedItems),
      draggingIndex:
          clearDraggingIndex ? null : (draggingIndex ?? this.draggingIndex),
      hoveringIndex:
          clearHoveringIndex ? null : (hoveringIndex ?? this.hoveringIndex),
      hoveringAfterLast: hoveringAfterLast ?? this.hoveringAfterLast,
      leftDownwards: leftDownwards ?? this.leftDownwards,
      libraryWidgetHoverPosition: clearLibraryWidgetHoverPosition
          ? null
          : (libraryWidgetHoverPosition ?? this.libraryWidgetHoverPosition),
    );
  }

  PagebuilderDragState<T> clearHover() {
    return copyWith(
      clearHoveringIndex: true,
      hoveringAfterLast: false,
      clearLibraryWidgetHoverPosition: true,
    );
  }

  PagebuilderDragState<T> clearDrag() {
    return copyWith(
      clearDraggingIndex: true,
      clearHoveringIndex: true,
      hoveringAfterLast: false,
      leftDownwards: false,
      clearLibraryWidgetHoverPosition: true,
    );
  }
}
