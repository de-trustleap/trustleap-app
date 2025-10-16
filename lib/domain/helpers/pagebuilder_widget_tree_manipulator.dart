import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/helpers/pagebuilder_widget_tree_searcher.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_placement_helper.dart';

/// Helper for manipulating the PageBuilder widget tree.
///
/// Provides operations to add, update, delete, and reorder widgets
/// within the widget hierarchy. All operations return new modified copies
/// without mutating the original tree.
///
/// Uses PagebuilderWidgetTreeSearcher internally for navigation.
class PagebuilderWidgetTreeManipulator {
  /// Adds a widget at a specific position relative to a target widget in a list.
  ///
  /// This handles the case where widgets are at the top level (e.g., in a Section).
  /// If the target widget is found in the list, it wraps both widgets appropriately
  /// or inserts the new widget at the correct position.
  static List<PageBuilderWidget> addWidgetAtPositionInList(
    List<PageBuilderWidget> widgets,
    String targetWidgetId,
    PageBuilderWidget newWidget,
    DropPosition position,
  ) {
    // Find the target widget in the list
    final targetIndex = widgets.indexWhere((w) => w.id.value == targetWidgetId);

    if (targetIndex != -1) {
      // Target found at top level - need to wrap or insert
      final targetWidget = widgets[targetIndex];

      // For "inside" position, add to the target widget's children
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

    // Target not found at top level - recursively search in each widget
    return widgets
        .map((widget) =>
            addWidgetAtPosition(widget, targetWidgetId, newWidget, position))
        .toList();
  }

  /// Adds a widget at a specific position relative to a target widget.
  ///
  /// Recursively searches for the target widget and inserts the new widget
  /// at the specified position (before, after, above, below, inside).
  ///
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
          // Container should only accept first widget as containerChild
          // If container already has a child, the normal drag logic will handle wrapping
          if (widget.containerChild == null) {
            // Container is empty - add as first child and reduce padding from 50 to 16
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
          // If container already has a child, don't handle here - let it fall through
          // to the normal containerChild search logic below
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

    // Search in containerChild
    if (widget.containerChild != null) {
      // Check if containerChild is the target
      if (widget.containerChild!.id.value == targetWidgetId &&
          position != DropPosition.inside) {
        // Target found in containerChild - wrap both widgets
        return _wrapContainerChild(widget, newWidget, position);
      }

      // Continue recursive search
      final updatedContainerChild = addWidgetAtPosition(
          widget.containerChild!, targetWidgetId, newWidget, position);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    // Search in children
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
          final updatedChildren = List<PageBuilderWidget>.from(widget.children!);
          updatedChildren[childIndex] = updatedChild;
          return widget.copyWith(children: updatedChildren);
        }

        // Found target widget - check if parent can handle multiple children
        final parentType = widget.elementType;

        // Use helper to determine if wrapping is needed
        final needsWrapping = PagebuilderWidgetPlacementHelper.needsWrapping(
              position: position,
              parentType: parentType,
            ) ||
            !PagebuilderWidgetTreeSearcher.canHaveChildren(parentType);

        if (needsWrapping) {
          // Use helper to wrap the widgets in appropriate container (Row or Column)
          final targetWidget = widget.children![childIndex];
          final wrapperWidget = PagebuilderWidgetPlacementHelper.wrapWidgets(
            targetWidget: targetWidget,
            newWidget: newWidget,
            position: position,
          );

          // Replace target widget with wrapper
          final updatedChildren =
              List<PageBuilderWidget>.from(widget.children!);
          updatedChildren[childIndex] = wrapperWidget;
          return widget.copyWith(children: updatedChildren);
        } else if (PagebuilderWidgetTreeSearcher.canHaveChildren(parentType)) {
          // Parent can handle this placement direction - just insert
          final updatedChildren =
              List<PageBuilderWidget>.from(widget.children!);
          int insertIndex;

          // Determine insert index based on position
          if (position == DropPosition.before ||
              position == DropPosition.above) {
            insertIndex = childIndex;
          } else {
            insertIndex = childIndex + 1;
          }

          // If inserting into a Row, use helper to redistribute widthPercentage
          if (parentType == PageBuilderWidgetType.row) {
            // Insert new widget first
            updatedChildren.insert(insertIndex, newWidget);

            // Use helper to redistribute width percentages equally
            final redistributedChildren =
                PagebuilderWidgetPlacementHelper.redistributeWidthPercentages(
                    updatedChildren);

            return widget.copyWith(children: redistributedChildren);
          } else {
            // For Column/Container, just insert without width changes
            updatedChildren.insert(insertIndex, newWidget);
            return widget.copyWith(children: updatedChildren);
          }
        } else {
          // Fallback - should not reach here
          return widget;
        }
      }

      // Target not found in direct children, recursively search deeper
      final updatedChildren = widget.children!
          .map((child) =>
              addWidgetAtPosition(child, targetWidgetId, newWidget, position))
          .toList();
      return widget.copyWith(children: updatedChildren);
    }

    return widget;
  }

  /// Wraps a container's child widget with a new widget at a specific position.
  ///
  /// Creates a Row or Column to contain both widgets based on the position.
  static PageBuilderWidget _wrapContainerChild(
    PageBuilderWidget containerWidget,
    PageBuilderWidget newWidget,
    DropPosition position,
  ) {
    final targetWidget = containerWidget.containerChild!;

    // Use helper to wrap the widgets
    final wrapperWidget = PagebuilderWidgetPlacementHelper.wrapWidgets(
      targetWidget: targetWidget,
      newWidget: newWidget,
      position: position,
    );

    return containerWidget.copyWith(containerChild: wrapperWidget);
  }

  /// Updates a specific widget in the tree with new data.
  ///
  /// Recursively searches for the widget and replaces it with the updated version.
  static PageBuilderWidget updateWidget(
    PageBuilderWidget widget,
    String targetWidgetId,
    PageBuilderWidget Function(PageBuilderWidget) updateFn,
  ) {
    // Check if this is the target widget
    if (widget.id.value == targetWidgetId) {
      return updateFn(widget);
    }

    // Update containerChild
    if (widget.containerChild != null) {
      final updatedContainerChild =
          updateWidget(widget.containerChild!, targetWidgetId, updateFn);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    // Update children
    if (widget.children != null && widget.children!.isNotEmpty) {
      final updatedChildren = widget.children!
          .map((child) => updateWidget(child, targetWidgetId, updateFn))
          .toList();
      return widget.copyWith(children: updatedChildren);
    }

    return widget;
  }

  /// Reorders children of a widget by moving a child from one index to another.
  ///
  /// Returns a new widget with reordered children.
  static PageBuilderWidget reorderChildren(
    PageBuilderWidget widget,
    String containerId,
    int oldIndex,
    int newIndex,
  ) {
    // Check if this is the container
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

    // Search in containerChild
    if (widget.containerChild != null) {
      final updatedContainerChild =
          reorderChildren(widget.containerChild!, containerId, oldIndex, newIndex);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    // Search in children
    if (widget.children != null && widget.children!.isNotEmpty) {
      final updatedChildren = widget.children!
          .map((child) => reorderChildren(child, containerId, oldIndex, newIndex))
          .toList();
      return widget.copyWith(children: updatedChildren);
    }

    return widget;
  }

  /// Deletes a widget from the tree.
  ///
  /// Returns a new widget tree without the deleted widget.
  static PageBuilderWidget? deleteWidget(
    PageBuilderWidget widget,
    String targetWidgetId,
  ) {
    // If this is the widget to delete, return null
    if (widget.id.value == targetWidgetId) {
      return null;
    }

    // Handle containerChild
    if (widget.containerChild != null) {
      if (widget.containerChild!.id.value == targetWidgetId) {
        // Remove containerChild
        return widget.copyWith(containerChild: null);
      }

      final updatedContainerChild =
          deleteWidget(widget.containerChild!, targetWidgetId);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    // Handle children
    if (widget.children != null && widget.children!.isNotEmpty) {
      final updatedChildren = widget.children!
          .where((child) => child.id.value != targetWidgetId)
          .map((child) => deleteWidget(child, targetWidgetId))
          .whereType<PageBuilderWidget>() // Filter out nulls
          .toList();

      return widget.copyWith(children: updatedChildren);
    }

    return widget;
  }
}
