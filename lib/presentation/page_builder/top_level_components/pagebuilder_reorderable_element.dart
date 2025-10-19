import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_reorder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/widget_library_drag_data.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_drag_position_detector.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_drag_state.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_indicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DraggableItemProvider<T> extends InheritedWidget {
  final PagebuilderReorderDragData<T> dragData;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnd;
  final Widget Function(BuildContext) buildFeedback;

  const DraggableItemProvider({
    super.key,
    required this.dragData,
    required this.onDragStarted,
    required this.onDragEnd,
    required this.buildFeedback,
    required super.child,
  });

  static DraggableItemProvider<T>? of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DraggableItemProvider<T>>();
  }

  @override
  bool updateShouldNotify(DraggableItemProvider<T> oldWidget) {
    return dragData != oldWidget.dragData;
  }
}

class PagebuilderReorderableElement<T> extends StatefulWidget {
  final String containerId;
  final List<T> items;
  final Widget Function(T, int) buildChild;
  final void Function(int oldIndex, int newIndex) onReorder;
  final String Function(T) getItemId;
  final bool Function(T)? isContainer;
  final bool Function(T)? isSection;
  final void Function(
          WidgetLibraryDragData, String targetWidgetId, DropPosition position)?
      onAddWidget;

  const PagebuilderReorderableElement({
    super.key,
    required this.containerId,
    required this.items,
    required this.buildChild,
    required this.onReorder,
    required this.getItemId,
    this.isContainer,
    this.isSection,
    this.onAddWidget,
  });

  @override
  State<PagebuilderReorderableElement<T>> createState() =>
      _PagebuilderReorderableElementState<T>();
}

class _PagebuilderReorderableElementState<T>
    extends State<PagebuilderReorderableElement<T>> {
  final double _dragAfterLastThreshold = 0.7;
  final double _dragFeedbackOpacity = 0.7;
  final double _draggingChildOpacity = 0.3;

  late PagebuilderDragState<T> _dragState;
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    _dragState = PagebuilderDragState<T>();
  }

  @override
  void didUpdateWidget(PagebuilderReorderableElement<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      setState(() {
        _dragState = _dragState.copyWith(clearReorderedItems: true);
      });
    }
  }

  void _handleReorder(int oldIndex, int newIndex) {
    final items = _dragState.reorderedItems ?? widget.items;
    if (items.isNotEmpty) {
      final updatedItems = List<T>.from(items);
      final item = updatedItems.removeAt(oldIndex);
      final insertIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
      updatedItems.insert(insertIndex, item);

      setState(() {
        _dragState = _dragState.copyWith(
          reorderedItems: updatedItems,
          clearHoveringIndex: true,
          clearDraggingIndex: true,
          hoveringAfterLast: false,
        );
      });

      // Reset drag state when drop is successful
      Modular.get<PagebuilderDragCubit>().setDragging(false);

      widget.onReorder(oldIndex, newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _dragState.reorderedItems ?? widget.items;

    final dragTargets = <Widget>[];

    for (var entry in items.asMap().entries) {
      final index = entry.key;
      final item = entry.value;

      // Ensure we have a key for this index
      _itemKeys.putIfAbsent(index, () => GlobalKey());
      final itemKey = _itemKeys[index]!;
      final isLastItem = index == items.length - 1;

      dragTargets.add(
        DragTarget<PagebuilderDragData>(
          key: ValueKey(widget.getItemId(item)),
          onWillAcceptWithDetails: (details) {
            if (details.data is WidgetLibraryDragData) {
              final targetIsContainer = widget.isContainer?.call(item) ?? false;

              final finalPosition = PagebuilderDragPositionDetector.detectFinalPosition(
                itemKey: itemKey,
                globalOffset: details.offset,
                isLastItem: isLastItem,
                isInRow: false,
                targetIsContainer: targetIsContainer,
              );

              setState(() {
                _dragState = _dragState.copyWith(
                  hoveringIndex: index,
                  hoveringAfterLast: finalPosition == DropPosition.below && isLastItem,
                  leftDownwards: false,
                  libraryWidgetHoverPosition: finalPosition,
                );
              });
              return true;
            } else if (details.data is PagebuilderReorderDragData<T>) {
              // Handle PagebuilderReorderDragData - check container
              final reorderData = details.data as PagebuilderReorderDragData<T>;
              final isSameContainer =
                  reorderData.containerId == widget.containerId;

              if (!isSameContainer) {
                // Clear any hover state when entering a different container
                if (_dragState.hoveringIndex != null || _dragState.hoveringAfterLast) {
                  setState(() {
                    _dragState = _dragState.clearHover();
                  });
                }
                return false;
              }

              // For last item, accept if hovering after last OR if different index
              if (isLastItem) {
                final isDifferentIndex = reorderData.index != index;
                if (isDifferentIndex && !_dragState.hoveringAfterLast) {
                  setState(() {
                    _dragState = _dragState.copyWith(
                      hoveringIndex: index,
                      hoveringAfterLast: false,
                      leftDownwards: false,
                    );
                  });
                }
                // Accept both normal hover and "after last" hover
                return isDifferentIndex || _dragState.hoveringAfterLast;
              }

              final isDifferentIndex = reorderData.index != index;
              if (isDifferentIndex) {
                setState(() {
                  _dragState = _dragState.copyWith(
                    hoveringIndex: index,
                    hoveringAfterLast: false,
                    leftDownwards: false,
                  );
                });
              }

              return isDifferentIndex;
            }

            return false;
          },
          onMove: (details) {
            if (details.data is WidgetLibraryDragData) {
              final targetIsContainer = widget.isContainer?.call(item) ?? false;

              final finalPosition = PagebuilderDragPositionDetector.detectFinalPosition(
                itemKey: itemKey,
                globalOffset: details.offset,
                isLastItem: isLastItem,
                isInRow: false,
                targetIsContainer: targetIsContainer,
              );

              setState(() {
                _dragState = _dragState.copyWith(
                  hoveringIndex: finalPosition == DropPosition.below && isLastItem
                      ? items.length
                      : index,
                  hoveringAfterLast: finalPosition == DropPosition.below && isLastItem,
                  libraryWidgetHoverPosition: finalPosition,
                );
              });
              return;
            }

            // Only handle if we're dragging in this container and this is last item
            if (!isLastItem || _dragState.draggingIndex == null) {
              return;
            }

            if (details.data is PagebuilderReorderDragData<T>) {
              final reorderData = details.data as PagebuilderReorderDragData<T>;
              final isSameContainer =
                  reorderData.containerId == widget.containerId;
              if (!isSameContainer) {
                return;
              }

              // Check if we're in the lower part of the element (bottom 30%)
              final renderBox =
                  itemKey.currentContext?.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                final localPosition = renderBox.globalToLocal(details.offset);
                final height = renderBox.size.height;
                final isInLowerPart = localPosition.dy > height * _dragAfterLastThreshold;

                if (isInLowerPart) {
                  setState(() {
                    _dragState = _dragState.copyWith(
                      hoveringIndex: items.length,
                      hoveringAfterLast: true,
                    );
                  });
                }
              }
            }
          },
          onLeave: (data) {
            // For WidgetLibraryDragData, just clear hover state
            if (data is WidgetLibraryDragData) {
              setState(() {
                _dragState = _dragState.clearHover();
              });
            } else if (data is PagebuilderReorderDragData<T>) {
              // Only handle onLeave if we're dragging in this container
              final isDraggingInThisContainer = _dragState.draggingIndex != null;
              if (!isDraggingInThisContainer) {
                return;
              }

              // For last item, mark that we left downwards if we were hovering after last
              if (isLastItem) {
                if (_dragState.hoveringAfterLast) {
                  setState(() {
                    _dragState = _dragState.copyWith(leftDownwards: true);
                  });
                } else {
                  setState(() {
                    _dragState = _dragState.copyWith(
                      hoveringIndex: items.length,
                      hoveringAfterLast: true,
                    );
                  });
                }
              } else {
                setState(() {
                  _dragState = _dragState.copyWith(
                    clearHoveringIndex: true,
                    hoveringAfterLast: false,
                    leftDownwards: false,
                  );
                });
              }
            }
          },
          onAcceptWithDetails: (details) {
            if (details.data is WidgetLibraryDragData) {
              // Check if we're still dragging - if not, this is a duplicate/stale event
              final isDragging = Modular.get<PagebuilderDragCubit>().state;
              if (!isDragging) {
                return;
              }

              // Handle new widget from library
              final widgetLibraryData = details.data as WidgetLibraryDragData;
              final targetWidgetId = widget.getItemId(item);

              final targetIsContainer = widget.isContainer?.call(item) ?? false;
              final finalPosition = PagebuilderDragPositionDetector.detectFinalPosition(
                itemKey: itemKey,
                globalOffset: details.offset,
                isLastItem: isLastItem,
                isInRow: false,
                targetIsContainer: targetIsContainer,
                fallback: _dragState.libraryWidgetHoverPosition ?? DropPosition.above,
              );

              // Process the drop
              widget.onAddWidget
                  ?.call(widgetLibraryData, targetWidgetId, finalPosition);

              setState(() {
                _dragState = _dragState.clearHover();
              });

              // Reset drag state
              Modular.get<PagebuilderDragCubit>().setDragging(false);
            } else if (details.data is PagebuilderReorderDragData<T>) {
              // Handle reordering
              final reorderData = details.data as PagebuilderReorderDragData<T>;
              final targetIndex =
                  (_dragState.hoveringAfterLast && isLastItem) ? items.length : index;
              _handleReorder(reorderData.index, targetIndex);
              setState(() {
                _dragState = _dragState.copyWith(hoveringAfterLast: false);
              });
            }
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering =
                _dragState.hoveringIndex == index && _dragState.draggingIndex != index;
            final isLastItem = index == items.length - 1;

            return PagebuilderDragIndicators(
              isHovering: isHovering,
              libraryWidgetHoverPosition: _dragState.libraryWidgetHoverPosition,
              draggingIndex: _dragState.draggingIndex,
              index: index,
              isLastItem: isLastItem,
              hoveringAfterLast: _dragState.hoveringAfterLast,
              isInRow: false,
              isSection: widget.isSection?.call(item) ?? false,
              child: DraggableItemProvider<T>(
                dragData: PagebuilderReorderDragData<T>(
                    widget.containerId, index),
                onDragStarted: () {
                  setState(() {
                    _dragState = _dragState.copyWith(draggingIndex: index);
                  });
                  Modular.get<PagebuilderDragCubit>().setDragging(true);
                },
                onDragEnd: () {
                  // If we left downwards, trigger reorder to end
                  if (_dragState.leftDownwards &&
                      _dragState.draggingIndex != null &&
                      _dragState.draggingIndex != items.length - 1) {
                    _handleReorder(_dragState.draggingIndex!, items.length);
                  }

                  setState(() {
                    _dragState = _dragState.clearDrag();
                  });
                  Modular.get<PagebuilderDragCubit>().setDragging(false);
                },
                buildFeedback: (context) {
                  // Get the actual width of the item from the RenderBox
                  double? width;
                  final renderBox = itemKey.currentContext
                      ?.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    width = renderBox.size.width;
                  }

                  return Opacity(
                    opacity: _dragFeedbackOpacity,
                    child: Material(
                      child: SizedBox(
                        width: width,
                        child: widget.buildChild(item, index),
                      ),
                    ),
                  );
                },
                child: Container(
                  key: itemKey,
                  child: _dragState.draggingIndex == index
                      ? Opacity(
                          opacity: _draggingChildOpacity,
                          child: widget.buildChild(item, index),
                        )
                      : widget.buildChild(item, index),
                ),
              ),
            );
          },
        ),
      );
    }

    return Column(
      children: dragTargets,
    );
  }
}
