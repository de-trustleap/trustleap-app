import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DragData<T> extends Equatable {
  final String containerId;
  final int index;

  const DragData(this.containerId, this.index);

  @override
  List<Object?> get props => [containerId, index];
}

class DraggableItemProvider<T> extends InheritedWidget {
  final DragData<T> dragData;
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

  const PagebuilderReorderableElement({
    super.key,
    required this.containerId,
    required this.items,
    required this.buildChild,
    required this.onReorder,
    required this.getItemId,
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
        DragTarget<DragData<T>>(
          key: ValueKey(widget.getItemId(item)),
          onWillAcceptWithDetails: (details) {
            final isSameContainer =
                details.data.containerId == widget.containerId;

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
              final isDifferentIndex = details.data.index != index;
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

            final isDifferentIndex = details.data.index != index;
            if (isDifferentIndex) {
              setState(() {
                _hoveringIndex = index;
                _hoveringAfterLast = false;
                _leftDownwards = false;
              });
            }

            return isDifferentIndex;
          },
          onMove: (details) {
            // Only handle if we're dragging in this container and this is last item
            if (!isLastItem || _draggingIndex == null) {
              return;
            }

            final isSameContainer = details.data.containerId == widget.containerId;
            if (!isSameContainer) {
              return;
            }

            // Check if we're in the lower part of the element (bottom 30%)
            final renderBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
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
          },
          onLeave: (_) {
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
          },
          onAcceptWithDetails: (details) {
            // If hovering after last and this is the last item, drop at end
            // Otherwise drop at this item's position
            final targetIndex = (_hoveringAfterLast && isLastItem) ? items.length : index;
            _handleReorder(details.data.index, targetIndex);
            setState(() {
              _hoveringAfterLast = false;
            });
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering =
                _hoveringIndex == index && _draggingIndex != index;
            final isLastItem = index == items.length - 1;
            final showIndicatorAfter = isLastItem && _hoveringAfterLast;

            return Column(
              children: [
                if (isHovering)
                  Container(
                    height: 4,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                DraggableItemProvider<T>(
                  dragData: DragData<T>(widget.containerId, index),
                  onDragStarted: () {
                    setState(() => _draggingIndex = index);
                    Modular.get<PagebuilderDragCubit>().setDragging(true);
                  },
                  onDragEnd: () {
                    // If we left downwards, trigger reorder to end
                    if (_leftDownwards && _draggingIndex != null && _draggingIndex != items.length - 1) {
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
                    final renderBox = itemKey.currentContext?.findRenderObject()
                        as RenderBox?;
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
                if (showIndicatorAfter)
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

// TODO: ROW WITH IMAGE AND TEXT NOT WORKING WITH DRAG (DONE)
// TODO: FIX RESPONSIVE MODE (DONE)
// TODO: ADD MORE SPACE TO DRAG ELEMENT AT BEGINNING OR END OF ROW/COLUMN
