import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderWidgetTreeSearcher {
  /// Finds a widget by its ID in the widget tree.
  /// Recursively searches through children and containerChild.
  /// Returns null if widget is not found.
  static PageBuilderWidget? findWidgetById(
    PageBuilderWidget widget,
    String targetId,
  ) {
    if (widget.id.value == targetId) {
      return widget;
    }

    if (widget.containerChild != null) {
      final found = findWidgetById(widget.containerChild!, targetId);
      if (found != null) return found;
    }

    if (widget.children != null) {
      for (final child in widget.children!) {
        final found = findWidgetById(child, targetId);
        if (found != null) return found;
      }
    }

    return null;
  }

  static PageBuilderWidget? findWidgetByIdInSection(
    PageBuilderSection section,
    String targetId,
  ) {
    if (section.widgets == null) return null;

    for (final widget in section.widgets!) {
      final found = findWidgetById(widget, targetId);
      if (found != null) return found;
    }
    return null;
  }

  static PageBuilderWidget? findParentOfWidget(
    PageBuilderWidget root,
    String targetChildId,
  ) {
    if (root.containerChild != null) {
      if (root.containerChild!.id.value == targetChildId) {
        return root;
      }
      final found = findParentOfWidget(root.containerChild!, targetChildId);
      if (found != null) return found;
    }

    if (root.children != null) {
      for (final child in root.children!) {
        if (child.id.value == targetChildId) {
          return root;
        }
        final found = findParentOfWidget(child, targetChildId);
        if (found != null) return found;
      }
    }

    return null;
  }

  static int findChildIndex(
    PageBuilderWidget parent,
    String childId,
  ) {
    if (parent.children == null) return -1;

    return parent.children!.indexWhere((child) => child.id.value == childId);
  }

  static bool canHaveChildren(PageBuilderWidgetType? type) {
    return type == PageBuilderWidgetType.row ||
        type == PageBuilderWidgetType.column ||
        type == PageBuilderWidgetType.container;
  }

  static List<PageBuilderWidget> findWidgetsByType(
    PageBuilderWidget root,
    PageBuilderWidgetType targetType,
  ) {
    final results = <PageBuilderWidget>[];

    if (root.elementType == targetType) {
      results.add(root);
    }

    if (root.containerChild != null) {
      results.addAll(findWidgetsByType(root.containerChild!, targetType));
    }

    if (root.children != null) {
      for (final child in root.children!) {
        results.addAll(findWidgetsByType(child, targetType));
      }
    }

    return results;
  }

  /// Gets the path from root to target widget.
  /// Returns a list of widgets representing the path, or null if not found.
  /// The first element is the root, the last is the target.
  static List<PageBuilderWidget>? getPathToWidget(
    PageBuilderWidget root,
    String targetId,
  ) {
    if (root.id.value == targetId) {
      return [root];
    }

    if (root.containerChild != null) {
      final path = getPathToWidget(root.containerChild!, targetId);
      if (path != null) {
        return [root, ...path];
      }
    }

    if (root.children != null) {
      for (final child in root.children!) {
        final path = getPathToWidget(child, targetId);
        if (path != null) {
          return [root, ...path];
        }
      }
    }

    return null;
  }

  /// Gets the depth of a widget in the tree (0 for root).
  /// Returns -1 if widget is not found.
  static int getWidgetDepth(
    PageBuilderWidget root,
    String targetId,
  ) {
    final path = getPathToWidget(root, targetId);
    return path == null ? -1 : path.length - 1;
  }
}
