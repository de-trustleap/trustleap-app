import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/model_helper/axis_alignment_converter.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/pagebuilder_widget_factory.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/landing_page_builder_widget_container.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_reorderable_row/reorderable_row_content.dart';
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
          child: ReorderableRowContent(
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
