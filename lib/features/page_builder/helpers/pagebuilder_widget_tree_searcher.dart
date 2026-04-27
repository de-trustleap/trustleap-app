import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';

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

  static int countWidgetsByType(
      PageBuilderPage page, PageBuilderWidgetType type) {
    int count = 0;
    for (final section in page.sections ?? []) {
      for (final widget in section.widgets ?? []) {
        count += _countInWidget(widget, type);
      }
    }
    return count;
  }

  static int _countInWidget(
      PageBuilderWidget widget, PageBuilderWidgetType type) {
    int count = widget.elementType == type ? 1 : 0;
    if (widget.containerChild != null) {
      count += _countInWidget(widget.containerChild!, type);
    }
    for (final child in widget.children ?? []) {
      count += _countInWidget(child, type);
    }
    return count;
  }
}
