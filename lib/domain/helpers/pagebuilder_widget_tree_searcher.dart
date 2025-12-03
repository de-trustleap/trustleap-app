import 'package:finanzbegleiter/constants.dart';
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
}
