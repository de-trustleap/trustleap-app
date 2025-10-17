import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_factory.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ReorderableColumnWidget extends StatefulWidget {
  final PageBuilderWidget model;
  final PagebuilderColumnProperties? properties;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget Function(PageBuilderWidget, int) buildChild;

  const ReorderableColumnWidget({
    super.key,
    required this.model,
    required this.properties,
    required this.mainAxisAlignment,
    required this.crossAxisAlignment,
    required this.buildChild,
  });

  @override
  State<ReorderableColumnWidget> createState() =>
      _ReorderableColumnWidgetState();
}

class _ReorderableColumnWidgetState extends State<ReorderableColumnWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.model.children == null || widget.model.children!.isEmpty) {
      return const SizedBox.shrink();
    }

    return LandingPageBuilderWidgetContainer(
      model: widget.model,
      child: PagebuilderReorderableElement<PageBuilderWidget>(
        containerId: widget.model.id.value,
        items: widget.model.children!,
        getItemId: (item) => item.id.value,
        isContainer: (item) =>
            item.elementType == PageBuilderWidgetType.container &&
            item.containerChild == null,
        onReorder: (oldIndex, newIndex) {
          Modular.get<PagebuilderBloc>().add(
              ReorderWidgetEvent(widget.model.id.value, oldIndex, newIndex));
        },
        onAddWidget: (widgetLibraryData, targetWidgetId, position) {
          final newWidget = PagebuilderWidgetFactory.createDefaultWidget(
              widgetLibraryData.widgetType);
          Modular.get<PagebuilderBloc>().add(AddWidgetAtPositionEvent(
            newWidget: newWidget,
            targetWidgetId: targetWidgetId,
            position: position,
          ));
        },
        buildChild: (child, index) => widget.buildChild(child, index),
      ),
    );
  }
}
