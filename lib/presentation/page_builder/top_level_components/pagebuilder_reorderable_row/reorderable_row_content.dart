import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_reorder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/widget_library_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_drag_position_detector.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_drag_state.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_factory.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/draggable_item_provider.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_indicators.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_row/reorderable_row_resize_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ReorderableRowContent extends StatefulWidget {
  final PageBuilderWidget model;
  final PagebuilderRowProperties? properties;
  final PagebuilderResponsiveBreakpoint breakpoint;
  final double scaleFactor;
  final double remainingWidthPercentage;
  final Widget Function(PageBuilderWidget, int) buildChild;

  const ReorderableRowContent({
    super.key,
    required this.model,
    required this.properties,
    required this.breakpoint,
    required this.scaleFactor,
    required this.remainingWidthPercentage,
    required this.buildChild,
  });

  @override
  State<ReorderableRowContent> createState() => ReorderableRowContentState();
}

class ReorderableRowContentState extends State<ReorderableRowContent> {
  final double _dragAfterLastThreshold = 0.7;
  final double _dragFeedbackOpacity = 0.7;
  final double _draggingChildOpacity = 0.3;
  final double _resizeHoverThreshold = 10.0;

  PagebuilderDragState<PageBuilderWidget> _dragState =
      const PagebuilderDragState();
  final Map<int, GlobalKey> _itemKeys = {};
  final GlobalKey _containerKey = GlobalKey();

  int?
      _resizeHoverIndex; // Index of the gap where resize indicator should show (between index-1 and index)

  // Local resize state for smooth dragging
  bool _isResizing = false;
  double _resizeDelta = 0.0;
  int? _resizeLeftIndex;
  int? _resizeRightIndex;
  double _containerWidth = 0.0;

  @override
  void didUpdateWidget(ReorderableRowContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.children != widget.model.children) {
      setState(() {
        _dragState = _dragState.copyWith(clearReorderedItems: true);
      });

      // Clear local resize state when new props arrive
      if (_isResizing) {
        setState(() {
          _isResizing = false;
          _resizeDelta = 0.0;
          _resizeLeftIndex = null;
          _resizeRightIndex = null;
        });
      }
    }
  }

  void _handleReorder(int oldIndex, int newIndex) {
    final items = _dragState.reorderedItems ?? widget.model.children!;
    if (items.isNotEmpty) {
      final updatedItems = List<PageBuilderWidget>.from(items);
      final item = updatedItems.removeAt(oldIndex);
      final insertIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
      updatedItems.insert(insertIndex, item);

      setState(() {
        _dragState = _dragState.copyWith(
          reorderedItems: updatedItems,
          clearHoveringIndex: true,
          clearDraggingIndex: true,
          hoveringAfterLast: false,
          leftDownwards: false,
        );
      });

      Modular.get<PagebuilderDragCubit>().setDragging(false);
      Modular.get<PagebuilderBloc>()
          .add(ReorderWidgetEvent(widget.model.id.value, oldIndex, newIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _dragState.reorderedItems ?? widget.model.children!;
    final rowChildren = <Widget>[];

    for (var entry in items.asMap().entries) {
      final index = entry.key;
      final child = entry.value;

      _itemKeys.putIfAbsent(index, () => GlobalKey());
      final itemKey = _itemKeys[index]!;
      final isLastItem = index == items.length - 1;

      // Calculate flex value with local resize delta for smooth dragging
      double flexValue =
          (child.widthPercentage?.getValueForBreakpoint(widget.breakpoint) ??
                  0) *
              widget.scaleFactor;

      // Apply local resize delta during dragging
      if (_isResizing &&
          _resizeLeftIndex != null &&
          _resizeRightIndex != null &&
          _containerWidth > 0) {
        if (index == _resizeLeftIndex) {
          final deltaPercentage = (_resizeDelta / _containerWidth) * 100;
          flexValue = ((child.widthPercentage
                          ?.getValueForBreakpoint(widget.breakpoint) ??
                      0) +
                  deltaPercentage) *
              widget.scaleFactor;
        } else if (index == _resizeRightIndex) {
          final deltaPercentage = (_resizeDelta / _containerWidth) * 100;
          flexValue = ((child.widthPercentage
                          ?.getValueForBreakpoint(widget.breakpoint) ??
                      0) -
                  deltaPercentage) *
              widget.scaleFactor;
        }
      }

      final isHovering = _dragState.hoveringIndex == index &&
          _dragState.draggingIndex != index;

      rowChildren.add(
        Expanded(
          flex: (flexValue * 100).toInt(),
          child: DragTarget<PagebuilderDragData>(
            key: ValueKey(child.id.value),
            onWillAcceptWithDetails: (details) {
              if (details.data is WidgetLibraryDragData) {
                final targetIsContainer =
                    child.elementType == PageBuilderWidgetType.container &&
                        child.containerChild == null;

                final finalPosition =
                    PagebuilderDragPositionDetector.detectFinalPosition(
                  itemKey: itemKey,
                  globalOffset: details.offset,
                  isLastItem: isLastItem,
                  isInRow: true,
                  targetIsContainer: targetIsContainer,
                );

                setState(() {
                  _dragState = _dragState.copyWith(
                    hoveringIndex: index,
                    hoveringAfterLast:
                        finalPosition == DropPosition.after && isLastItem,
                    leftDownwards: false,
                    libraryWidgetHoverPosition: finalPosition,
                  );
                });

                final dragCubit = Modular.get<PagebuilderDragCubit>();
                if (dragCubit.state.libraryDragTargetContainerId !=
                    widget.model.id.value) {
                  dragCubit.setLibraryDragTarget(
                    containerId: widget.model.id.value,
                    containerKey: _containerKey,
                  );
                }

                return true;
              } else if (details.data
                  is PagebuilderReorderDragData<PageBuilderWidget>) {
                final reorderData = details.data
                    as PagebuilderReorderDragData<PageBuilderWidget>;
                final isSameContainer =
                    reorderData.containerId == widget.model.id.value;
                if (!isSameContainer) return false;

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
                final targetIsContainer =
                    child.elementType == PageBuilderWidgetType.container &&
                        child.containerChild == null;

                final finalPosition =
                    PagebuilderDragPositionDetector.detectFinalPosition(
                  itemKey: itemKey,
                  globalOffset: details.offset,
                  isLastItem: isLastItem,
                  isInRow: true,
                  targetIsContainer: targetIsContainer,
                );

                setState(() {
                  _dragState = _dragState.copyWith(
                    hoveringIndex:
                        finalPosition == DropPosition.after && isLastItem
                            ? items.length
                            : index,
                    hoveringAfterLast:
                        finalPosition == DropPosition.after && isLastItem,
                    libraryWidgetHoverPosition: finalPosition,
                  );
                });

                final dragCubit = Modular.get<PagebuilderDragCubit>();
                if (dragCubit.state.libraryDragTargetContainerId !=
                    widget.model.id.value) {
                  dragCubit.setLibraryDragTarget(
                    containerId: widget.model.id.value,
                    containerKey: _containerKey,
                  );
                }

                return;
              }

              // Only handle if we're dragging in this container and this is last item
              if (!isLastItem || _dragState.draggingIndex == null) {
                return;
              }

              if (details.data
                  is PagebuilderReorderDragData<PageBuilderWidget>) {
                final reorderData = details.data
                    as PagebuilderReorderDragData<PageBuilderWidget>;
                final isSameContainer =
                    reorderData.containerId == widget.model.id.value;
                if (!isSameContainer) {
                  return;
                }

                // Check if we're in the right part of the element (right 30%)
                final renderBox =
                    itemKey.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final localPosition = renderBox.globalToLocal(details.offset);
                  final width = renderBox.size.width;
                  final isInRightPart =
                      localPosition.dx > width * _dragAfterLastThreshold;

                  if (isInRightPart) {
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
                Modular.get<PagebuilderDragCubit>().clearLibraryDragTarget();
              } else if (data
                  is PagebuilderReorderDragData<PageBuilderWidget>) {
                // Only handle onLeave if we're dragging in this container
                final isDraggingInThisContainer =
                    _dragState.draggingIndex != null;
                if (!isDraggingInThisContainer) {
                  return;
                }

                // For last item, mark that we left rightwards if we were hovering after last
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
                final widgetLibraryData = details.data as WidgetLibraryDragData;
                final targetWidgetId = child.id.value;

                final targetIsContainer =
                    child.elementType == PageBuilderWidgetType.container &&
                        child.containerChild == null;
                final finalPosition =
                    PagebuilderDragPositionDetector.detectFinalPosition(
                  itemKey: itemKey,
                  globalOffset: details.offset,
                  isLastItem: isLastItem,
                  isInRow: true,
                  targetIsContainer: targetIsContainer,
                  fallback: _dragState.libraryWidgetHoverPosition ??
                      DropPosition.before,
                );

                // Check if this drop should be processed
                final isDragging =
                    Modular.get<PagebuilderDragCubit>().state.isDragging;
                if (!isDragging) {
                  return;
                }

                // Create new widget from factory
                final newWidget = PagebuilderWidgetFactory.createDefaultWidget(
                    widgetLibraryData.widgetType);

                // Add widget at position
                Modular.get<PagebuilderBloc>().add(AddWidgetAtPositionEvent(
                  newWidget: newWidget,
                  targetWidgetId: targetWidgetId,
                  position: finalPosition,
                ));

                setState(() {
                  _dragState = _dragState.clearHover();
                });

                // Reset drag state
                Modular.get<PagebuilderDragCubit>().setDragging(false);
              } else if (details.data
                  is PagebuilderReorderDragData<PageBuilderWidget>) {
                final reorderData = details.data
                    as PagebuilderReorderDragData<PageBuilderWidget>;
                // If hovering after last and this is the last item, drop at end
                if (_dragState.hoveringAfterLast && isLastItem) {
                  _handleReorder(reorderData.index, items.length);
                  return;
                }

                // When dragging left to right, insert AFTER this element (index + 1)
                // When dragging right to left, insert BEFORE this element (index)
                final targetIndex =
                    reorderData.index < index ? index + 1 : index;
                _handleReorder(reorderData.index, targetIndex);
              }
            },
            builder: (context, candidateData, rejectedData) {
              return PagebuilderDragIndicators(
                isHovering: isHovering,
                libraryWidgetHoverPosition:
                    _dragState.libraryWidgetHoverPosition,
                draggingIndex: _dragState.draggingIndex,
                index: index,
                isLastItem: isLastItem,
                hoveringAfterLast: _dragState.hoveringAfterLast,
                isInRow: true,
                expandHeight: widget.properties?.equalHeights == true,
                child: DraggableItemProvider<PageBuilderWidget>(
                  dragData: PagebuilderReorderDragData<PageBuilderWidget>(
                      widget.model.id.value, index),
                  onDragStarted: () {
                    setState(() {
                      _dragState = _dragState.copyWith(draggingIndex: index);
                    });
                    Modular.get<PagebuilderDragCubit>().setDragging(
                      true,
                      containerId: widget.model.id.value,
                      containerKey: _containerKey,
                    );
                  },
                  onDragEnd: () {
                    // If we left rightwards, trigger reorder to end
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
                    final renderBox = itemKey.currentContext?.findRenderObject()
                        as RenderBox?;
                    if (renderBox != null) {
                      width = renderBox.size.width;
                    }

                    return Opacity(
                      opacity: _dragFeedbackOpacity,
                      child: Material(
                        child: SizedBox(
                          width: width,
                          child: widget.buildChild(child, index),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    key: itemKey,
                    child: _dragState.draggingIndex == index
                        ? Opacity(
                            opacity: _draggingChildOpacity,
                            child: widget.buildChild(child, index),
                          )
                        : widget.buildChild(child, index),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    // Add remaining width spacer if needed
    if (widget.remainingWidthPercentage > 0) {
      final mainAxisAlignment =
          widget.properties?.mainAxisAlignment ?? MainAxisAlignment.center;

      if (mainAxisAlignment == MainAxisAlignment.center) {
        // For center alignment, split the spacer in half
        final halfSpacerFlex =
            (widget.remainingWidthPercentage * 100 / 2).toInt();
        final leftSpacer = Expanded(
          flex: halfSpacerFlex,
          child: const SizedBox.shrink(),
        );
        final rightSpacer = Expanded(
          flex: halfSpacerFlex,
          child: const SizedBox.shrink(),
        );
        rowChildren.insert(0, leftSpacer);
        rowChildren.add(rightSpacer);
      } else {
        final spacer = Expanded(
          flex: (widget.remainingWidthPercentage * 100).toInt(),
          child: const SizedBox.shrink(),
        );

        // Add spacer at beginning if end-aligned, otherwise at end
        if (mainAxisAlignment == MainAxisAlignment.end) {
          rowChildren.insert(0, spacer);
        } else {
          rowChildren.add(spacer);
        }
      }
    }

    // Use IntrinsicHeight when equalHeights is true OR when hovering
    // (hovering needs IntrinsicHeight to make the indicator visible)
    final needsIntrinsicHeight = widget.properties?.equalHeights == true ||
        _dragState.hoveringIndex != null;

    final effectiveCrossAxis = widget.properties?.equalHeights == true
        ? (widget.properties?.crossAxisAlignment ?? CrossAxisAlignment.stretch)
        : (widget.properties?.crossAxisAlignment ?? CrossAxisAlignment.center);

    final rowContent = needsIntrinsicHeight
        ? IntrinsicHeight(
            child: Row(
              key: _containerKey,
              mainAxisAlignment: widget.properties?.mainAxisAlignment ??
                  MainAxisAlignment.center,
              crossAxisAlignment: effectiveCrossAxis,
              children: rowChildren,
            ),
          )
        : Row(
            key: _containerKey,
            mainAxisAlignment: widget.properties?.mainAxisAlignment ??
                MainAxisAlignment.center,
            children: rowChildren,
          );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        rowContent,
        ReorderableRowResizeOverlay(
          rowModel: widget.model,
          items: items,
          breakpoint: widget.breakpoint,
          scaleFactor: widget.scaleFactor,
          resizeHoverThreshold: _resizeHoverThreshold,
          resizeHoverIndex: _resizeHoverIndex,
          isResizing: _isResizing,
          resizeDelta: _resizeDelta,
          resizeLeftIndex: _resizeLeftIndex,
          resizeRightIndex: _resizeRightIndex,
          containerWidth: _containerWidth,
          onResizeHoverChange: (index) {
            setState(() {
              _resizeHoverIndex = index;
            });
          },
          onResizeStateChange: ({
            required bool isResizing,
            required double resizeDelta,
            required int? resizeLeftIndex,
            required int? resizeRightIndex,
            required double containerWidth,
          }) {
            setState(() {
              _isResizing = isResizing;
              _resizeDelta = resizeDelta;
              _resizeLeftIndex = resizeLeftIndex;
              _resizeRightIndex = resizeRightIndex;
              _containerWidth = containerWidth;
            });
          },
        ),
      ],
    );
  }
}
