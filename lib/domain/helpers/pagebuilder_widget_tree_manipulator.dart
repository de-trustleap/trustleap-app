import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/helpers/pagebuilder_widget_tree_searcher.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_placement_helper.dart';

class PagebuilderWidgetTreeManipulator {
  /// Adds a widget at a specific position relative to a target widget in a list.
  /// This handles the case where widgets are at the top level (e.g., in a Section).
  /// If the target widget is found in the list, it wraps both widgets appropriately
  /// or inserts the new widget at the correct position.
  static List<PageBuilderWidget> addWidgetAtPositionInList(
    List<PageBuilderWidget> widgets,
    String targetWidgetId,
    PageBuilderWidget newWidget,
    DropPosition position,
  ) {
    final targetIndex = widgets.indexWhere((w) => w.id.value == targetWidgetId);

    if (targetIndex != -1) {
      final targetWidget = widgets[targetIndex];
      if (position == DropPosition.inside) {
        final updatedTarget = addWidgetAtPosition(
          targetWidget,
          targetWidgetId,
          newWidget,
          position,
        );
        final updatedWidgets = List<PageBuilderWidget>.from(widgets);
        updatedWidgets[targetIndex] = updatedTarget;
        return updatedWidgets;
      }

      // For before/after (horizontal) positions, wrap in Row
      if (position == DropPosition.before || position == DropPosition.after) {
        final wrapperWidget = PagebuilderWidgetPlacementHelper.wrapWidgets(
          targetWidget: targetWidget,
          newWidget: newWidget,
          position: position,
        );
        final updatedWidgets = List<PageBuilderWidget>.from(widgets);
        updatedWidgets[targetIndex] = wrapperWidget;
        return updatedWidgets;
      }

      // For above/below (vertical) positions, wrap in Column
      if (position == DropPosition.above || position == DropPosition.below) {
        final wrapperWidget = PagebuilderWidgetPlacementHelper.wrapWidgets(
          targetWidget: targetWidget,
          newWidget: newWidget,
          position: position,
        );
        final updatedWidgets = List<PageBuilderWidget>.from(widgets);
        updatedWidgets[targetIndex] = wrapperWidget;
        return updatedWidgets;
      }
    }

    return widgets
        .map((widget) =>
            addWidgetAtPosition(widget, targetWidgetId, newWidget, position))
        .toList();
  }

  /// Adds a widget at a specific position relative to a target widget.
  /// Recursively searches for the target widget and inserts the new widget
  /// at the specified position (before, after, above, below, inside).
  /// Automatically handles wrapping when needed (e.g., horizontal placement in Column).
  static PageBuilderWidget addWidgetAtPosition(
    PageBuilderWidget widget,
    String targetWidgetId,
    PageBuilderWidget newWidget,
    DropPosition position,
  ) {
    // Handle "inside" position - add to children if container/row/column
    if (widget.id.value == targetWidgetId && position == DropPosition.inside) {
      if (PagebuilderWidgetTreeSearcher.canHaveChildren(widget.elementType)) {
        // Special handling for Container - uses containerChild instead of children
        if (widget.elementType == PageBuilderWidgetType.container) {
          if (widget.containerChild == null) {
            final newPadding = widget.padding != null
                ? const PageBuilderSpacing(
                    top: PagebuilderResponsiveOrConstant.constant(16.0),
                    bottom: PagebuilderResponsiveOrConstant.constant(16.0),
                    left: PagebuilderResponsiveOrConstant.constant(16.0),
                    right: PagebuilderResponsiveOrConstant.constant(16.0),
                  )
                : widget.padding;

            return widget.copyWith(
              containerChild: newWidget,
              padding: newPadding,
            );
          }
          return widget;
        }

        final currentChildren = widget.children ?? [];

        // If adding to a Row, use helper to redistribute widthPercentage
        if (widget.elementType == PageBuilderWidgetType.row) {
          final updatedChildren = List<PageBuilderWidget>.from(currentChildren)
            ..add(newWidget);

          final redistributedChildren =
              PagebuilderWidgetPlacementHelper.redistributeWidthPercentages(
                  updatedChildren);

          return widget.copyWith(children: redistributedChildren);
        } else {
          // For Column, just add without width changes
          final updatedChildren = List<PageBuilderWidget>.from(currentChildren)
            ..add(newWidget);
          return widget.copyWith(children: updatedChildren);
        }
      }
      return widget;
    }

    if (widget.containerChild != null) {
      if (widget.containerChild!.id.value == targetWidgetId &&
          position != DropPosition.inside) {
        return _wrapContainerChild(widget, newWidget, position);
      }

      final updatedContainerChild = addWidgetAtPosition(
          widget.containerChild!, targetWidgetId, newWidget, position);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    if (widget.children != null && widget.children!.isNotEmpty) {
      final childIndex =
          PagebuilderWidgetTreeSearcher.findChildIndex(widget, targetWidgetId);

      if (childIndex != -1) {
        // If position is "inside", we need to add to the child itself, not to its parent
        if (position == DropPosition.inside) {
          final targetChild = widget.children![childIndex];
          final updatedChild = addWidgetAtPosition(
            targetChild,
            targetWidgetId,
            newWidget,
            position,
          );
          final updatedChildren =
              List<PageBuilderWidget>.from(widget.children!);
          updatedChildren[childIndex] = updatedChild;
          return widget.copyWith(children: updatedChildren);
        }

        final parentType = widget.elementType;
        final needsWrapping = PagebuilderWidgetPlacementHelper.needsWrapping(
              position: position,
              parentType: parentType,
            ) ||
            !PagebuilderWidgetTreeSearcher.canHaveChildren(parentType);

        if (needsWrapping) {
          final targetWidget = widget.children![childIndex];
          final wrapperWidget = PagebuilderWidgetPlacementHelper.wrapWidgets(
            targetWidget: targetWidget,
            newWidget: newWidget,
            position: position,
          );
          final updatedChildren =
              List<PageBuilderWidget>.from(widget.children!);
          updatedChildren[childIndex] = wrapperWidget;
          return widget.copyWith(children: updatedChildren);
        } else if (PagebuilderWidgetTreeSearcher.canHaveChildren(parentType)) {
          final updatedChildren =
              List<PageBuilderWidget>.from(widget.children!);
          int insertIndex;

          if (position == DropPosition.before ||
              position == DropPosition.above) {
            insertIndex = childIndex;
          } else {
            insertIndex = childIndex + 1;
          }

          if (parentType == PageBuilderWidgetType.row) {
            updatedChildren.insert(insertIndex, newWidget);
            final redistributedChildren =
                PagebuilderWidgetPlacementHelper.redistributeWidthPercentages(
                    updatedChildren);

            return widget.copyWith(children: redistributedChildren);
          } else {
            updatedChildren.insert(insertIndex, newWidget);
            return widget.copyWith(children: updatedChildren);
          }
        } else {
          return widget;
        }
      }

      final updatedChildren = widget.children!
          .map((child) =>
              addWidgetAtPosition(child, targetWidgetId, newWidget, position))
          .toList();
      return widget.copyWith(children: updatedChildren);
    }

    return widget;
  }

  /// Wraps a container's child widget with a new widget at a specific position.
  /// Creates a Row or Column to contain both widgets based on the position.
  static PageBuilderWidget _wrapContainerChild(
    PageBuilderWidget containerWidget,
    PageBuilderWidget newWidget,
    DropPosition position,
  ) {
    final targetWidget = containerWidget.containerChild!;
    final wrapperWidget = PagebuilderWidgetPlacementHelper.wrapWidgets(
      targetWidget: targetWidget,
      newWidget: newWidget,
      position: position,
    );

    return containerWidget.copyWith(containerChild: wrapperWidget);
  }

  /// Updates a specific widget in the tree with new data.
  /// Recursively searches for the widget and replaces it with the updated version.
  static PageBuilderWidget updateWidget(
    PageBuilderWidget widget,
    String targetWidgetId,
    PageBuilderWidget Function(PageBuilderWidget) updateFn,
  ) {
    if (widget.id.value == targetWidgetId) {
      return updateFn(widget);
    }

    if (widget.containerChild != null) {
      final updatedContainerChild =
          updateWidget(widget.containerChild!, targetWidgetId, updateFn);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    if (widget.children != null && widget.children!.isNotEmpty) {
      final updatedChildren = widget.children!
          .map((child) => updateWidget(child, targetWidgetId, updateFn))
          .toList();
      return widget.copyWith(children: updatedChildren);
    }

    return widget;
  }

  /// Reorders children of a widget by moving a child from one index to another.
  /// Returns a new widget with reordered children.
  static PageBuilderWidget reorderChildren(
    PageBuilderWidget widget,
    String containerId,
    int oldIndex,
    int newIndex,
  ) {
    if (widget.id.value == containerId) {
      if (widget.children == null || widget.children!.isEmpty) {
        return widget;
      }

      final items = List<PageBuilderWidget>.from(widget.children!);
      if (oldIndex < 0 ||
          oldIndex >= items.length ||
          newIndex < 0 ||
          newIndex > items.length) {
        return widget;
      }

      final item = items.removeAt(oldIndex);
      final insertIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
      items.insert(insertIndex, item);

      return widget.copyWith(children: items);
    }

    if (widget.containerChild != null) {
      final updatedContainerChild = reorderChildren(
          widget.containerChild!, containerId, oldIndex, newIndex);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    if (widget.children != null && widget.children!.isNotEmpty) {
      final updatedChildren = widget.children!
          .map((child) =>
              reorderChildren(child, containerId, oldIndex, newIndex))
          .toList();
      return widget.copyWith(children: updatedChildren);
    }

    return widget;
  }

  /// Removes all placeholder widgets from a page.
  /// Also removes empty rows, columns, containers, and sections after placeholder removal.
  /// This should be called before saving to ensure placeholders don't get persisted.
  static PageBuilderPage removePlaceholders(PageBuilderPage page) {
    final sectionsWithoutPlaceholders = page.sections
        ?.map((section) {
          final widgetsWithoutPlaceholders = section.widgets
              ?.map((widget) => _removePlaceholdersFromWidget(widget))
              .where((widget) => widget != null)
              .cast<PageBuilderWidget>()
              .toList();
          return section.copyWith(widgets: widgetsWithoutPlaceholders);
        })
        .where(
            (section) => section.widgets != null && section.widgets!.isNotEmpty)
        .toList();

    return page.copyWith(sections: sectionsWithoutPlaceholders);
  }

  /// Recursively removes placeholder widgets from a widget tree.
  /// Also removes empty rows/columns/containers after placeholder removal.
  static PageBuilderWidget? _removePlaceholdersFromWidget(
      PageBuilderWidget widget) {
    if (widget.elementType == PageBuilderWidgetType.placeholder) {
      return null;
    }

    final childrenWithoutPlaceholders = widget.children
        ?.map((child) => _removePlaceholdersFromWidget(child))
        .where((child) => child != null)
        .cast<PageBuilderWidget>()
        .toList();
    final containerChildWithoutPlaceholder = widget.containerChild != null
        ? _removePlaceholdersFromWidget(widget.containerChild!)
        : null;

    if ((widget.elementType == PageBuilderWidgetType.row ||
            widget.elementType == PageBuilderWidgetType.column) &&
        (childrenWithoutPlaceholders == null ||
            childrenWithoutPlaceholders.isEmpty)) {
      return null;
    }

    if (widget.elementType == PageBuilderWidgetType.container &&
        containerChildWithoutPlaceholder == null) {
      return null;
    }

    return widget.copyWith(
      children: childrenWithoutPlaceholders,
      containerChild: containerChildWithoutPlaceholder,
    );
  }
}
