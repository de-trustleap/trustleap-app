import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
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
                (child.widthPercentage?.getValueForBreakpoint(breakpoint) ?? 0));
        // Scale if over 100%
        final scaleFactor =
            totalWidthPercentage > 100 ? 100 / totalWidthPercentage : 1.0;
        // Calculate remaining width
        final remainingWidthPercentage = 100 - totalWidthPercentage * scaleFactor;

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

      final flexValue =
          (child.widthPercentage?.getValueForBreakpoint(widget.breakpoint) ??
                  0) *
              widget.scaleFactor;

      final isHovering = _hoveringIndex == index && _draggingIndex != index;

      rowChildren.add(
        Expanded(
          flex: (flexValue * 100).toInt(),
          child: DragTarget<DragData<PageBuilderWidget>>(
            key: ValueKey(child.id.value),
            onWillAcceptWithDetails: (details) {
              final isSameContainer =
                  details.data.containerId == widget.model.id.value;
              if (!isSameContainer) return false;

              final isDifferentIndex = details.data.index != index;
              if (isDifferentIndex) {
                setState(() => _hoveringIndex = index);
              }
              return isDifferentIndex;
            },
            onLeave: (_) {
              setState(() => _hoveringIndex = null);
            },
            onAcceptWithDetails: (details) {
              _handleReorder(details.data.index, index);
            },
            builder: (context, candidateData, rejectedData) {
              return Row(
                children: [
                  if (isHovering)
                    Container(
                      width: 4,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  Expanded(
                    child: DraggableItemProvider<PageBuilderWidget>(
                      dragData: DragData<PageBuilderWidget>(
                          widget.model.id.value, index),
                      onDragStarted: () {
                        setState(() => _draggingIndex = index);
                        Modular.get<PagebuilderDragCubit>().setDragging(true);
                      },
                      onDragEnd: () {
                        setState(() {
                          _draggingIndex = null;
                          _hoveringIndex = null;
                        });
                        Modular.get<PagebuilderDragCubit>().setDragging(false);
                      },
                      buildFeedback: (context) {
                        // Get the actual width of the item from the RenderBox
                        double? width;
                        final renderBox =
                            itemKey.currentContext?.findRenderObject()
                                as RenderBox?;
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
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    // Add DragTarget at the end
    rowChildren.add(
      DragTarget<DragData<PageBuilderWidget>>(
        onWillAcceptWithDetails: (details) {
          final isSameContainer =
              details.data.containerId == widget.model.id.value;
          final targetIndex = items.length;
          final isDifferentIndex = details.data.index != targetIndex;

          if (isSameContainer && isDifferentIndex) {
            setState(() => _hoveringIndex = targetIndex);
            return true;
          }
          return false;
        },
        onLeave: (_) {
          setState(() => _hoveringIndex = null);
        },
        onAcceptWithDetails: (details) {
          _handleReorder(details.data.index, items.length);
        },
        builder: (context, candidateData, rejectedData) {
          final isHovering = _hoveringIndex == items.length;
          return Container(
            width: isHovering ? 4 : 20,
            color: isHovering
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
          );
        },
      ),
    );

    // Add remaining width spacer if needed
    if (widget.remainingWidthPercentage > 0) {
      rowChildren.add(
        Expanded(
          flex: (widget.remainingWidthPercentage * 100).toInt(),
          child: const SizedBox.shrink(),
        ),
      );
    }

    final rowContent = widget.properties?.equalHeights == true
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
