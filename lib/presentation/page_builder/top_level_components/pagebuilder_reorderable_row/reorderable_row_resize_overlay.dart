import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ReorderableRowResizeOverlay extends StatelessWidget {
  final PageBuilderWidget rowModel;
  final List<PageBuilderWidget> items;
  final PagebuilderResponsiveBreakpoint breakpoint;
  final double scaleFactor;
  final double resizeHoverThreshold;
  final int? resizeHoverIndex;
  final bool isResizing;
  final double resizeDelta;
  final int? resizeLeftIndex;
  final int? resizeRightIndex;
  final double containerWidth;
  final void Function(int? index) onResizeHoverChange;
  final void Function({
    required bool isResizing,
    required double resizeDelta,
    required int? resizeLeftIndex,
    required int? resizeRightIndex,
    required double containerWidth,
  }) onResizeStateChange;

  const ReorderableRowResizeOverlay({
    super.key,
    required this.rowModel,
    required this.items,
    required this.breakpoint,
    required this.scaleFactor,
    required this.resizeHoverThreshold,
    required this.resizeHoverIndex,
    required this.isResizing,
    required this.resizeDelta,
    required this.resizeLeftIndex,
    required this.resizeRightIndex,
    required this.containerWidth,
    required this.onResizeHoverChange,
    required this.onResizeStateChange,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final resizeAreas = <Widget>[];
          final percentageLabels = <Widget>[];

          // Create resize areas between each pair of elements
          double leftOffset = 0;
          for (int i = 0; i < items.length; i++) {
            // Calculate width with local resize delta if resizing
            double basePercentage =
                items[i].widthPercentage?.getValueForBreakpoint(breakpoint) ??
                    0;
            double baseWidth = basePercentage * scaleFactor;

            double currentPercentage = basePercentage;
            double childWidth = baseWidth;

            if (isResizing &&
                resizeLeftIndex != null &&
                resizeRightIndex != null) {
              if (i == resizeLeftIndex) {
                final deltaPercentage =
                    (resizeDelta / constraints.maxWidth) * 100;
                currentPercentage = basePercentage + deltaPercentage;
                childWidth = baseWidth + deltaPercentage * scaleFactor;
              } else if (i == resizeRightIndex) {
                final deltaPercentage =
                    (resizeDelta / constraints.maxWidth) * 100;
                currentPercentage = basePercentage - deltaPercentage;
                childWidth = baseWidth - deltaPercentage * scaleFactor;
              }
            }

            final widthInPixels = (childWidth / 100) * constraints.maxWidth;

            // Add percentage label above each element during resizing
            if (isResizing) {
              percentageLabels.add(
                Positioned(
                  left: leftOffset + (widthInPixels / 2) - 30,
                  top: -28,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${currentPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }

            // Add resize area after this element (between i and i+1)
            if (i < items.length - 1) {
              final gapIndex = i + 1;
              final isHovered = resizeHoverIndex == gapIndex;
              // Show indicator if hovered OR if currently resizing this gap
              final isActiveResize = isResizing &&
                  resizeLeftIndex == (gapIndex - 1) &&
                  resizeRightIndex == gapIndex;
              final shouldShowIndicator = isHovered || isActiveResize;

              resizeAreas.add(
                Positioned(
                  left: leftOffset + widthInPixels - resizeHoverThreshold,
                  top: 0,
                  bottom: 0,
                  width: resizeHoverThreshold * 2, // 20px wide hover area
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    onEnter: (_) {
                      onResizeHoverChange(gapIndex);
                      // Clear widget hover
                      Modular.get<PagebuilderHoverCubit>().setHovered(null);
                    },
                    onExit: (_) {
                      if (resizeHoverIndex == gapIndex) {
                        onResizeHoverChange(null);
                      }
                    },
                    child: GestureDetector(
                      onHorizontalDragStart: (_) {
                        final leftChildIndex = gapIndex - 1;
                        final rightChildIndex = gapIndex;
                        // Disable hover and start local resize state
                        Modular.get<PagebuilderHoverCubit>().setDisabled(true);

                        onResizeStateChange(
                          isResizing: true,
                          resizeDelta: 0.0,
                          resizeLeftIndex: leftChildIndex,
                          resizeRightIndex: rightChildIndex,
                          containerWidth: constraints.maxWidth,
                        );
                      },
                      onHorizontalDragUpdate: (details) {
                        // Update local state for smooth feedback
                        onResizeStateChange(
                          isResizing: isResizing,
                          resizeDelta: resizeDelta + details.delta.dx,
                          resizeLeftIndex: resizeLeftIndex,
                          resizeRightIndex: resizeRightIndex,
                          containerWidth: containerWidth,
                        );
                      },
                      onHorizontalDragEnd: (_) {
                        // Calculate final widths
                        if (resizeLeftIndex == null ||
                            resizeRightIndex == null ||
                            containerWidth == 0) {
                          return;
                        }

                        final leftChild = items[resizeLeftIndex!];
                        final rightChild = items[resizeRightIndex!];

                        final deltaPercentage =
                            (resizeDelta / containerWidth) * 100;

                        final leftWidth = (leftChild.widthPercentage
                                    ?.getValueForBreakpoint(breakpoint) ??
                                0) +
                            deltaPercentage;
                        final rightWidth = (rightChild.widthPercentage
                                    ?.getValueForBreakpoint(breakpoint) ??
                                0) -
                            deltaPercentage;

                        // Validate widths
                        if (leftWidth < 5 || rightWidth < 5) {
                          onResizeStateChange(
                            isResizing: false,
                            resizeDelta: 0.0,
                            resizeLeftIndex: null,
                            resizeRightIndex: null,
                            containerWidth: 0,
                          );
                          Modular.get<PagebuilderHoverCubit>()
                              .setDisabled(false);
                          return;
                        }

                        final helper =
                            PagebuilderResponsiveConfigHelper(breakpoint);

                        // Update all children with new widths
                        final updatedChildren =
                            items.asMap().entries.map((entry) {
                          final index = entry.key;
                          final child = entry.value;

                          if (index == resizeLeftIndex) {
                            return child.copyWith(
                              widthPercentage: helper.setValue(
                                child.widthPercentage,
                                leftWidth,
                              ),
                            );
                          } else if (index == resizeRightIndex) {
                            return child.copyWith(
                              widthPercentage: helper.setValue(
                                child.widthPercentage,
                                rightWidth,
                              ),
                            );
                          }
                          return child;
                        }).toList();

                        // Update the row widget with new children
                        final updatedRow = rowModel.copyWith(
                          children: updatedChildren,
                        );

                        Modular.get<PagebuilderBloc>().add(
                          UpdateWidgetEvent(updatedRow),
                        );
                        Modular.get<PagebuilderHoverCubit>().setDisabled(false);
                      },
                      child: Center(
                        child: Container(
                          width: shouldShowIndicator ? 8 : 0,
                          decoration: BoxDecoration(
                            color: shouldShowIndicator
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.5)
                                : Colors.transparent,
                          ),
                          child: shouldShowIndicator
                              ? Center(
                                  child: Container(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            leftOffset += widthInPixels;
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [...resizeAreas, ...percentageLabels],
          );
        },
      ),
    );
  }
}
