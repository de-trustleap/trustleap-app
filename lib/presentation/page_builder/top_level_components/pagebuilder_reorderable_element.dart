import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_reorder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/widget_library_drag_data.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_drag_position_detector.dart';
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
    this.onAddWidget,
  });

  @override
  State<PagebuilderReorderableElement<T>> createState() =>
      _PagebuilderReorderableElementState<T>();
}

class _PagebuilderReorderableElementState<T>
    extends State<PagebuilderReorderableElement<T>> {
  List<T>? _reorderedItems;
  int? _draggingIndex;
  int? _hoveringIndex;
  final Map<int, GlobalKey> _itemKeys = {};
  bool _hoveringAfterLast = false;
  bool _leftDownwards = false;

  // For WidgetLibraryDragData horizontal positioning
  DropPosition? _libraryWidgetHoverPosition;

  @override
  void didUpdateWidget(PagebuilderReorderableElement<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _reorderedItems = null;
    }
  }

  void _handleReorder(int oldIndex, int newIndex) {
    final items = _reorderedItems ?? widget.items;
    if (items.isNotEmpty) {
      final updatedItems = List<T>.from(items);
      final item = updatedItems.removeAt(oldIndex);
      final insertIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
      updatedItems.insert(insertIndex, item);

      setState(() {
        _reorderedItems = updatedItems;
        _hoveringIndex = null;
        _draggingIndex = null;
        _hoveringAfterLast = false;
      });

      // Reset drag state when drop is successful
      Modular.get<PagebuilderDragCubit>().setDragging(false);

      widget.onReorder(oldIndex, newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _reorderedItems ?? widget.items;

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
            // Handle WidgetLibraryDragData - always accept
            if (details.data is WidgetLibraryDragData) {
              // Check if target item is a container
              final targetIsContainer = widget.isContainer?.call(item) ?? false;

              // Use helper to detect initial position
              final initialPosition =
                  PagebuilderDragPositionDetector.detectPositionFromRenderBox(
                        itemKey: itemKey,
                        globalOffset: details.offset,
                        isLastItem: isLastItem,
                        isInRow:
                            false, // Column prioritizes horizontal placement
                      ) ??
                      DropPosition.above; // Fallback if RenderBox not available

              // For containers, prefer "inside" position when hovering near center
              final finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
                detectedPosition: initialPosition,
                targetIsContainer: targetIsContainer,
                itemKey: itemKey,
                globalOffset: details.offset,
              );

              setState(() {
                _hoveringIndex = index;
                _hoveringAfterLast =
                    finalPosition == DropPosition.below && isLastItem;
                _leftDownwards = false;
                _libraryWidgetHoverPosition = finalPosition;
              });
              return true;
            } else if (details.data is PagebuilderReorderDragData<T>) {
              // Handle PagebuilderReorderDragData - check container
              final reorderData = details.data as PagebuilderReorderDragData<T>;
              final isSameContainer =
                  reorderData.containerId == widget.containerId;

              if (!isSameContainer) {
                // Clear any hover state when entering a different container
                if (_hoveringIndex != null || _hoveringAfterLast) {
                  setState(() {
                    _hoveringIndex = null;
                    _hoveringAfterLast = false;
                  });
                }
                return false;
              }

              // For last item, accept if hovering after last OR if different index
              if (isLastItem) {
                final isDifferentIndex = reorderData.index != index;
                if (isDifferentIndex && !_hoveringAfterLast) {
                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = false;
                    _leftDownwards = false;
                  });
                }
                // Accept both normal hover and "after last" hover
                return isDifferentIndex || _hoveringAfterLast;
              }

              final isDifferentIndex = reorderData.index != index;
              if (isDifferentIndex) {
                setState(() {
                  _hoveringIndex = index;
                  _hoveringAfterLast = false;
                  _leftDownwards = false;
                });
              }

              return isDifferentIndex;
            }

            return false;
          },
          onMove: (details) {
            // Handle WidgetLibraryDragData - detect horizontal or vertical position
            if (details.data is WidgetLibraryDragData) {
              // Check if target item is a container
              final targetIsContainer = widget.isContainer?.call(item) ?? false;

              // Use helper to detect position
              final detectedPosition =
                  PagebuilderDragPositionDetector.detectPositionFromRenderBox(
                itemKey: itemKey,
                globalOffset: details.offset,
                isLastItem: isLastItem,
                isInRow: false, // Column prioritizes horizontal placement
              );

              if (detectedPosition == null) return;

              // For containers, prefer "inside" position when hovering near center
              final finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
                detectedPosition: detectedPosition,
                targetIsContainer: targetIsContainer,
                itemKey: itemKey,
                globalOffset: details.offset,
              );

              setState(() {
                _hoveringIndex =
                    finalPosition == DropPosition.below && isLastItem
                        ? items.length
                        : index;
                _hoveringAfterLast =
                    finalPosition == DropPosition.below && isLastItem;
                _libraryWidgetHoverPosition = finalPosition;
              });
              return;
            }

            // Only handle if we're dragging in this container and this is last item
            if (!isLastItem || _draggingIndex == null) {
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
                final isInLowerPart = localPosition.dy > height * 0.7;

                if (isInLowerPart) {
                  setState(() {
                    _hoveringIndex = items.length;
                    _hoveringAfterLast = true;
                  });
                }
              }
            }
          },
          onLeave: (data) {
            // For WidgetLibraryDragData, just clear hover state
            if (data is WidgetLibraryDragData) {
              setState(() {
                _hoveringIndex = null;
                _hoveringAfterLast = false;
                _libraryWidgetHoverPosition = null;
              });
            } else if (data is PagebuilderReorderDragData<T>) {
              // Only handle onLeave if we're dragging in this container
              final isDraggingInThisContainer = _draggingIndex != null;
              if (!isDraggingInThisContainer) {
                return;
              }

              // For last item, mark that we left downwards if we were hovering after last
              if (isLastItem) {
                if (_hoveringAfterLast) {
                  setState(() {
                    _leftDownwards = true;
                  });
                } else {
                  setState(() {
                    _hoveringIndex = items.length;
                    _hoveringAfterLast = true;
                  });
                }
              } else {
                setState(() {
                  _hoveringIndex = null;
                  _hoveringAfterLast = false;
                  _leftDownwards = false;
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

              // Recalculate position at drop moment to ensure accuracy
              DropPosition finalPosition = _libraryWidgetHoverPosition ?? DropPosition.above;

              // Check if target is a container and recalculate position
              final targetIsContainer = widget.isContainer?.call(item) ?? false;
              finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
                detectedPosition: finalPosition,
                targetIsContainer: targetIsContainer,
                itemKey: itemKey,
                globalOffset: details.offset,
              );

              // Process the drop
              widget.onAddWidget
                  ?.call(widgetLibraryData, targetWidgetId, finalPosition);

              setState(() {
                _hoveringIndex = null;
                _hoveringAfterLast = false;
                _libraryWidgetHoverPosition = null;
              });

              // Reset drag state
              Modular.get<PagebuilderDragCubit>().setDragging(false);
            } else if (details.data is PagebuilderReorderDragData<T>) {
              // Handle reordering
              final reorderData = details.data as PagebuilderReorderDragData<T>;
              final targetIndex =
                  (_hoveringAfterLast && isLastItem) ? items.length : index;
              _handleReorder(reorderData.index, targetIndex);
              setState(() {
                _hoveringAfterLast = false;
              });
            }
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering =
                _hoveringIndex == index && _draggingIndex != index;
            final isLastItem = index == items.length - 1;
            final showIndicatorAfter = isLastItem && _hoveringAfterLast;

            // Determine if we need horizontal indicators for library widgets
            final showInsideIndicator = isHovering &&
                _libraryWidgetHoverPosition == DropPosition.inside;
            final showLeftIndicator = (isHovering &&
                _libraryWidgetHoverPosition == DropPosition.before) ||
                showInsideIndicator;
            final showRightIndicator = (isHovering &&
                _libraryWidgetHoverPosition == DropPosition.after) ||
                showInsideIndicator;
            final showTopIndicator = (isHovering &&
                (_libraryWidgetHoverPosition == DropPosition.above ||
                    _libraryWidgetHoverPosition == null)) ||
                showInsideIndicator;
            final showBottomIndicator = showIndicatorAfter || showInsideIndicator;

            return Column(
              children: [
                if (showTopIndicator &&
                    (!showLeftIndicator || showInsideIndicator) &&
                    (!showRightIndicator || showInsideIndicator))
                  Container(
                    height: 4,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                Stack(
                  children: [
                    DraggableItemProvider<T>(
                      dragData: PagebuilderReorderDragData<T>(
                          widget.containerId, index),
                      onDragStarted: () {
                        setState(() => _draggingIndex = index);
                        Modular.get<PagebuilderDragCubit>().setDragging(true);
                      },
                      onDragEnd: () {
                        // If we left downwards, trigger reorder to end
                        if (_leftDownwards &&
                            _draggingIndex != null &&
                            _draggingIndex != items.length - 1) {
                          _handleReorder(_draggingIndex!, items.length);
                        }

                        setState(() {
                          _draggingIndex = null;
                          _hoveringIndex = null;
                          _hoveringAfterLast = false;
                          _leftDownwards = false;
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
                          opacity: 0.7,
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
                        child: _draggingIndex == index
                            ? Opacity(
                                opacity: 0.3,
                                child: widget.buildChild(item, index),
                              )
                            : widget.buildChild(item, index),
                      ),
                    ),
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
                ),
                if (showBottomIndicator)
                  Container(
                    height: 4,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              ],
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
