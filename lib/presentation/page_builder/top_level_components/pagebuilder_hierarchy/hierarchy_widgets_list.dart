import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_hierarchy/hierarchy_widget_item.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:flutter/material.dart';

class HierarchyWidgetsList extends StatelessWidget {
  final String sectionId;
  final List<PageBuilderWidget> widgets;
  final Function(String widgetId, bool isSection) onItemSelected;
  final Function(String parentId, int oldIndex, int newIndex)? onWidgetReorder;

  const HierarchyWidgetsList({
    super.key,
    required this.sectionId,
    required this.widgets,
    required this.onItemSelected,
    required this.onWidgetReorder,
  });

  @override
  Widget build(BuildContext context) {
    return PagebuilderReorderableElement<PageBuilderWidget>(
      containerId: sectionId,
      items: widgets,
      getItemId: (widget) => widget.id.value,
      isContainer: (widget) =>
          widget.elementType == PageBuilderWidgetType.container,
      onReorder: (oldIndex, newIndex) {
        onWidgetReorder?.call(sectionId, oldIndex, newIndex);
      },
      buildChild: (widget, index) {
        return HierarchyWidgetItem(
          widget: widget,
          depth: 0,
          onItemSelected: onItemSelected,
          onWidgetReorder: onWidgetReorder,
          showDragHandle: widgets.length > 1,
        );
      },
    );
  }
}
