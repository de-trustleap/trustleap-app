import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_reorder_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/widget_library_drag_data.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget_factory.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/axis_alignment_converter.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
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
  List<PageBuilderWidget>? _reorderedItems;
  int? _draggingIndex;
  int? _hoveringIndex;
  final Map<int, GlobalKey> _itemKeys = {};
  bool _hoveringAfterLast = false;
  bool _leftRightwards = false;

  // For WidgetLibraryDragData positioning (all 4 directions)
  DropPosition? _libraryWidgetHoverPosition;

  @override
  void didUpdateWidget(_ReorderableRowContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.children != widget.model.children) {
      _reorderedItems = null;
    }
  }

  void _handleReorder(int oldIndex, int newIndex) {
    final items = _reorderedItems ?? widget.model.children!;
    if (items.isNotEmpty) {
      final updatedItems = List<PageBuilderWidget>.from(items);
      final item = updatedItems.removeAt(oldIndex);
      final insertIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
      updatedItems.insert(insertIndex, item);

      setState(() {
        _reorderedItems = updatedItems;
        _hoveringIndex = null;
        _draggingIndex = null;
        _hoveringAfterLast = false;
        _leftRightwards = false;
      });

      Modular.get<PagebuilderDragCubit>().setDragging(false);
      Modular.get<PagebuilderBloc>()
          .add(ReorderWidgetEvent(widget.model.id.value, oldIndex, newIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _reorderedItems ?? widget.model.children!;
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

      final isHovering = _hoveringIndex == index && _draggingIndex != index;

      rowChildren.add(
        Expanded(
          flex: (flexValue * 100).toInt(),
          child: DragTarget<PagebuilderDragData>(
            key: ValueKey(child.id.value),
            onWillAcceptWithDetails: (details) {
              // Handle WidgetLibraryDragData - always accept
              if (details.data is WidgetLibraryDragData) {
                // Initial position detection
                final renderBox =
                    itemKey.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final localPosition = renderBox.globalToLocal(details.offset);
                  final size = renderBox.size;

                  // Determine if hover is on edges (30% threshold)
                  final leftEdge = localPosition.dx < size.width * 0.3;
                  final rightEdge = localPosition.dx > size.width * 0.7;
                  final topEdge = localPosition.dy < size.height * 0.3;
                  final bottomEdge = localPosition.dy > size.height * 0.3;

                  DropPosition initialPosition = DropPosition.before;
                  if (topEdge) {
                    initialPosition = DropPosition.above;
                  } else if (bottomEdge && isLastItem) {
                    initialPosition = DropPosition.below;
                  } else if (leftEdge) {
                    initialPosition = DropPosition.before;
                  } else if (rightEdge) {
                    initialPosition = DropPosition.after;
                  }

                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = bottomEdge && isLastItem;
                    _leftRightwards = false;
                    _libraryWidgetHoverPosition = initialPosition;
                  });
                } else {
                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = false;
                    _leftRightwards = false;
                    _libraryWidgetHoverPosition = DropPosition.before;
                  });
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
                  if (isDifferentIndex && !_hoveringAfterLast) {
                    setState(() {
                      _hoveringIndex = index;
                      _hoveringAfterLast = false;
                      _leftRightwards = false;
                    });
                  }
                  return isDifferentIndex || _hoveringAfterLast;
                }

                final isDifferentIndex = reorderData.index != index;
                if (isDifferentIndex) {
                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = false;
                    _leftRightwards = false;
                  });
                }
                return isDifferentIndex;
              }
              return false;
            },
            onMove: (details) {
              // Handle WidgetLibraryDragData - detect position for all 4 directions
              if (details.data is WidgetLibraryDragData) {
                final renderBox =
                    itemKey.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox == null) return;

                final localPosition = renderBox.globalToLocal(details.offset);
                final size = renderBox.size;

                // Determine if hover is on edges (30% threshold)
                final leftEdge = localPosition.dx < size.width * 0.3;
                final rightEdge = localPosition.dx > size.width * 0.7;
                final topEdge = localPosition.dy < size.height * 0.3;
                final bottomEdge = localPosition.dy > size.height * 0.7;

                // Prioritize vertical positioning (top/bottom) for Rows
                if (topEdge) {
                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = false;
                    _libraryWidgetHoverPosition = DropPosition.above;
                  });
                } else if (bottomEdge) {
                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = false;
                    _libraryWidgetHoverPosition = DropPosition.below;
                  });
                } else if (leftEdge) {
                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = false;
                    _libraryWidgetHoverPosition = DropPosition.before;
                  });
                } else if (rightEdge && isLastItem) {
                  // Right edge only for last item
                  setState(() {
                    _hoveringIndex = items.length;
                    _hoveringAfterLast = true;
                    _libraryWidgetHoverPosition = DropPosition.after;
                  });
                } else if (rightEdge) {
                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = false;
                    _libraryWidgetHoverPosition = DropPosition.after;
                  });
                } else {
                  // Center - default to before
                  setState(() {
                    _hoveringIndex = index;
                    _hoveringAfterLast = false;
                    _libraryWidgetHoverPosition = DropPosition.before;
                  });
                }
                return;
              }

              // Only handle if we're dragging in this container and this is last item
              if (!isLastItem || _draggingIndex == null) {
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
                  final isInRightPart = localPosition.dx > width * 0.7;

                  if (isInRightPart) {
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
              } else if (data
                  is PagebuilderReorderDragData<PageBuilderWidget>) {
                // Only handle onLeave if we're dragging in this container
                final isDraggingInThisContainer = _draggingIndex != null;
                if (!isDraggingInThisContainer) {
                  return;
                }

                // For last item, mark that we left rightwards if we were hovering after last
                if (isLastItem) {
                  if (_hoveringAfterLast) {
                    setState(() {
                      _leftRightwards = true;
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
                    _leftRightwards = false;
                  });
                }
              }
            },
            onAcceptWithDetails: (details) {
              if (details.data is WidgetLibraryDragData) {
                // Handle new widget from library
                final widgetLibraryData = details.data as WidgetLibraryDragData;
                final targetWidgetId = child.id.value;

                // Use detected hover position from onMove
                final position =
                    _libraryWidgetHoverPosition ?? DropPosition.before;

                // Create new widget from factory
                final newWidget = PagebuilderWidgetFactory.createDefaultWidget(
                    widgetLibraryData.widgetType);

                // Add widget at position
                Modular.get<PagebuilderBloc>().add(AddWidgetAtPositionEvent(
                  newWidget: newWidget,
                  targetWidgetId: targetWidgetId,
                  position: position,
                ));

                setState(() {
                  _hoveringIndex = null;
                  _hoveringAfterLast = false;
                  _libraryWidgetHoverPosition = null;
                });

                // Reset drag state
                Modular.get<PagebuilderDragCubit>().setDragging(false);
              } else if (details.data
                  is PagebuilderReorderDragData<PageBuilderWidget>) {
                final reorderData = details.data
                    as PagebuilderReorderDragData<PageBuilderWidget>;
                // If hovering after last and this is the last item, drop at end
                if (_hoveringAfterLast && isLastItem) {
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
              // Determine indicator position
              // For library widgets: use detected position (_libraryWidgetHoverPosition)
              // For reorder: use drag direction logic
              final showLeftIndicator = isHovering &&
                  _libraryWidgetHoverPosition == DropPosition.before;
              final showRightIndicator = isHovering &&
                  _libraryWidgetHoverPosition == DropPosition.after;
              final showTopIndicator = isHovering &&
                  (_libraryWidgetHoverPosition == DropPosition.above);
              final showBottomIndicator = isHovering &&
                  _libraryWidgetHoverPosition == DropPosition.below;

              // For reorder: show horizontal indicators based on drag direction
              final showIndicatorBefore = isHovering &&
                  _draggingIndex != null &&
                  _draggingIndex! > index;
              final showIndicatorAfter = (isHovering &&
                      _draggingIndex != null &&
                      (_draggingIndex! < index)) ||
                  (isLastItem && _hoveringAfterLast);

              return Column(
                children: [
                  if (showTopIndicator &&
                      !showLeftIndicator &&
                      !showRightIndicator)
                    Container(
                      height: 4,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  Stack(
                    children: [
                      DraggableItemProvider<PageBuilderWidget>(
                        dragData: PagebuilderReorderDragData<PageBuilderWidget>(
                            widget.model.id.value, index),
                        onDragStarted: () {
                          setState(() => _draggingIndex = index);
                          Modular.get<PagebuilderDragCubit>().setDragging(true);
                        },
                        onDragEnd: () {
                          // If we left rightwards, trigger reorder to end
                          if (_leftRightwards &&
                              _draggingIndex != null &&
                              _draggingIndex != items.length - 1) {
                            _handleReorder(_draggingIndex!, items.length);
                          }

                          setState(() {
                            _draggingIndex = null;
                            _hoveringIndex = null;
                            _hoveringAfterLast = false;
                            _leftRightwards = false;
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
                            opacity: 0.7,
                            child: Material(
                              child: SizedBox(
                                width: width,
                                child: widget.buildChild(child, index),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            if (showIndicatorBefore)
                              Container(
                                width: 4,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            Expanded(
                              child: Container(
                                key: itemKey,
                                child: _draggingIndex == index
                                    ? Opacity(
                                        opacity: 0.3,
                                        child: widget.buildChild(child, index),
                                      )
                                    : widget.buildChild(child, index),
                              ),
                            ),
                            if (showIndicatorAfter)
                              Container(
                                width: 4,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          ],
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
        ),
      );
    }

    // Add remaining width spacer if needed
    if (widget.remainingWidthPercentage > 0) {
      rowChildren.add(
        Expanded(
          flex: (widget.remainingWidthPercentage * 100).toInt(),
          child: const SizedBox.shrink(),
        ),
      );
    }

    // Use IntrinsicHeight when equalHeights is true OR when hovering
    // (hovering needs IntrinsicHeight to make the indicator visible)
    final needsIntrinsicHeight =
        widget.properties?.equalHeights == true || _hoveringIndex != null;

    final rowContent = needsIntrinsicHeight
        ? IntrinsicHeight(
            child: Row(
              mainAxisAlignment: widget.properties?.mainAxisAlignment ??
                  MainAxisAlignment.center,
              crossAxisAlignment: widget.properties?.crossAxisAlignment ??
                  CrossAxisAlignment.center,
              children: rowChildren,
            ),
          )
        : Row(
            mainAxisAlignment: widget.properties?.mainAxisAlignment ??
                MainAxisAlignment.center,
            children: rowChildren,
          );

    return rowContent;
  }
}

// TODO: CODE IST KOMPLEX GEWORDEN. FOLGENDE KLASSEN MÜSSEN KLARER STRUKTURIERT WERDEN: PAGEBUILDERBLOC, RECORDABLEROWWIDGET, PAGEBUILDERREORDABLEELEMENT
// TODO: ES FUNKTIONIERT NOCH WENN MIT DRAG AND DROP UND AUTOMATISCH WRAPPEN MIT COLUMN ODER ROW WENN DAS PARENT EINES WIDGETS DIREKT DIE SECTION IST.
// TODO: WIDGET FACTORY MIT SINNVOLLEN WERTEN ANPASSEN
// TODO: TESTS SCHREIBEN. VOR ALLEM FÜR HELPER KLASSEN UND PAGEBUILDERBLOC.
