import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_reorder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/widget_library_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_factory.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/axis_alignment_converter.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_drag_position_detector.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_drag_state.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/draggable_item_provider.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_indicators.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ReorderableRowWidget extends StatelessWidget {
  final PageBuilderWidget model;
  final PagebuilderRowProperties? properties;
  final int? index;
  final Widget Function(PageBuilderWidget, int) buildChild;

  const ReorderableRowWidget({
    super.key,
    required this.model,
    required this.properties,
    this.index,
    required this.buildChild,
  });

  @override
  Widget build(BuildContext context) {
    if (model.children == null || model.children!.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, breakpoint) {
        // Check if we should switch to Column for current breakpoint
        final shouldBeColumn = properties?.switchToColumnFor != null &&
            properties!.switchToColumnFor!.contains(breakpoint);

        if (shouldBeColumn) {
          // Switch to Column layout - use column layout for reorderable element
          return LandingPageBuilderWidgetContainer(
            model: model,
            index: index,
            child: Column(
              // Row's mainAxis (horizontal) becomes Column's crossAxis
              crossAxisAlignment: AxisAlignmentConverter.mainAxisToCrossAxis(
                  properties?.mainAxisAlignment ?? MainAxisAlignment.center),
              // Row's crossAxis (vertical) becomes Column's mainAxis
              mainAxisAlignment: AxisAlignmentConverter.crossAxisToMainAxis(
                  properties?.crossAxisAlignment ?? CrossAxisAlignment.center),
              children: [
                PagebuilderReorderableElement<PageBuilderWidget>(
                  containerId: model.id.value,
                  items: model.children!,
                  getItemId: (item) => item.id.value,
                  isContainer: (item) =>
                      item.elementType == PageBuilderWidgetType.container &&
                      item.containerChild == null,
                  onReorder: (oldIndex, newIndex) {
                    Modular.get<PagebuilderBloc>().add(
                        ReorderWidgetEvent(model.id.value, oldIndex, newIndex));
                  },
                  onAddWidget: (widgetLibraryData, targetWidgetId, position) {
                    // Create new widget from factory
                    final newWidget =
                        PagebuilderWidgetFactory.createDefaultWidget(
                            widgetLibraryData.widgetType);

                    // Add widget at position
                    Modular.get<PagebuilderBloc>().add(AddWidgetAtPositionEvent(
                      newWidget: newWidget,
                      targetWidgetId: targetWidgetId,
                      position: position,
                    ));
                  },
                  buildChild: (child, index) => buildChild(child, index),
                ),
              ],
            ),
          );
        }

        // Regular Row layout with drag and drop
        // Calculate total width percentage
        final totalWidthPercentage = model.children!.fold<double>(
            0,
            (sum, child) =>
                sum +
                (child.widthPercentage?.getValueForBreakpoint(breakpoint) ??
                    0));
        // Scale if over 100%
        final scaleFactor =
            totalWidthPercentage > 100 ? 100 / totalWidthPercentage : 1.0;
        // Calculate remaining width
        final remainingWidthPercentage =
            100 - totalWidthPercentage * scaleFactor;

        return LandingPageBuilderWidgetContainer(
          model: model,
          index: index,
          child: _ReorderableRowContent(
            model: model,
            properties: properties,
            breakpoint: breakpoint,
            scaleFactor: scaleFactor,
            remainingWidthPercentage: remainingWidthPercentage,
            buildChild: buildChild,
          ),
        );
      },
    );
  }
}

class _ReorderableRowContent extends StatefulWidget {
  final PageBuilderWidget model;
  final PagebuilderRowProperties? properties;
  final PagebuilderResponsiveBreakpoint breakpoint;
  final double scaleFactor;
  final double remainingWidthPercentage;
  final Widget Function(PageBuilderWidget, int) buildChild;

  const _ReorderableRowContent({
    required this.model,
    required this.properties,
    required this.breakpoint,
    required this.scaleFactor,
    required this.remainingWidthPercentage,
    required this.buildChild,
  });

  @override
  State<_ReorderableRowContent> createState() => _ReorderableRowContentState();
}

class _ReorderableRowContentState extends State<_ReorderableRowContent> {
  final double _dragAfterLastThreshold = 0.7;
  final double _dragFeedbackOpacity = 0.7;
  final double _draggingChildOpacity = 0.3;

  PagebuilderDragState<PageBuilderWidget> _dragState = const PagebuilderDragState();
  final Map<int, GlobalKey> _itemKeys = {};
  final GlobalKey _containerKey = GlobalKey();

  @override
  void didUpdateWidget(_ReorderableRowContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.children != widget.model.children) {
      setState(() {
        _dragState = _dragState.copyWith(clearReorderedItems: true);
      });
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

      final flexValue =
          (child.widthPercentage?.getValueForBreakpoint(widget.breakpoint) ??
                  0) *
              widget.scaleFactor;

      final isHovering = _dragState.hoveringIndex == index && _dragState.draggingIndex != index;

      rowChildren.add(
        Expanded(
          flex: (flexValue * 100).toInt(),
          child: DragTarget<PagebuilderDragData>(
            key: ValueKey(child.id.value),
            onWillAcceptWithDetails: (details) {
              if (details.data is WidgetLibraryDragData) {
                final targetIsContainer = child.elementType == PageBuilderWidgetType.container &&
                    child.containerChild == null;

                final finalPosition = PagebuilderDragPositionDetector.detectFinalPosition(
                  itemKey: itemKey,
                  globalOffset: details.offset,
                  isLastItem: isLastItem,
                  isInRow: true,
                  targetIsContainer: targetIsContainer,
                );

                setState(() {
                  _dragState = _dragState.copyWith(
                    hoveringIndex: index,
                    hoveringAfterLast: finalPosition == DropPosition.after && isLastItem,
                    leftDownwards: false,
                    libraryWidgetHoverPosition: finalPosition,
                  );
                });

                Modular.get<PagebuilderDragCubit>().setLibraryDragTarget(
                  containerId: widget.model.id.value,
                  containerKey: _containerKey,
                );

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
                final targetIsContainer = child.elementType == PageBuilderWidgetType.container &&
                    child.containerChild == null;

                final finalPosition = PagebuilderDragPositionDetector.detectFinalPosition(
                  itemKey: itemKey,
                  globalOffset: details.offset,
                  isLastItem: isLastItem,
                  isInRow: true,
                  targetIsContainer: targetIsContainer,
                );

                setState(() {
                  _dragState = _dragState.copyWith(
                    hoveringIndex: finalPosition == DropPosition.after && isLastItem
                        ? items.length
                        : index,
                    hoveringAfterLast: finalPosition == DropPosition.after && isLastItem,
                    libraryWidgetHoverPosition: finalPosition,
                  );
                });

                Modular.get<PagebuilderDragCubit>().setLibraryDragTarget(
                  containerId: widget.model.id.value,
                  containerKey: _containerKey,
                );

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
                  final isInRightPart = localPosition.dx > width * _dragAfterLastThreshold;

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
                final isDraggingInThisContainer = _dragState.draggingIndex != null;
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

                final targetIsContainer = child.elementType == PageBuilderWidgetType.container &&
                    child.containerChild == null;
                final finalPosition = PagebuilderDragPositionDetector.detectFinalPosition(
                  itemKey: itemKey,
                  globalOffset: details.offset,
                  isLastItem: isLastItem,
                  isInRow: true,
                  targetIsContainer: targetIsContainer,
                  fallback: _dragState.libraryWidgetHoverPosition ?? DropPosition.before,
                );

                // Check if this drop should be processed
                final isDragging = Modular.get<PagebuilderDragCubit>().state;
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
                libraryWidgetHoverPosition: _dragState.libraryWidgetHoverPosition,
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
                    Modular.get<PagebuilderDragCubit>()
                        .setDragging(false);
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
      final mainAxisAlignment = widget.properties?.mainAxisAlignment ?? MainAxisAlignment.center;

      if (mainAxisAlignment == MainAxisAlignment.center) {
        // For center alignment, split the spacer in half
        final halfSpacerFlex = (widget.remainingWidthPercentage * 100 / 2).toInt();
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
    final needsIntrinsicHeight =
        widget.properties?.equalHeights == true || _dragState.hoveringIndex != null;

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

    return rowContent;
  }
}
