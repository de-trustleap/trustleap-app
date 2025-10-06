import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderWidthPercentageValidator {
  final PageBuilderWidget currentWidget;
  final PagebuilderBloc pagebuilderBloc;

  const PagebuilderWidthPercentageValidator({
    required this.currentWidget,
    required this.pagebuilderBloc,
  });

  PageBuilderWidget? findParentRow() {
    final state = pagebuilderBloc.state;
    if (state is! GetLandingPageAndUserSuccessState ||
        currentWidget.widthPercentage == null) {
      return null;
    }

    PageBuilderWidget? parentRow;

    bool containsWidget(PageBuilderWidget widget) {
      if (widget.id == currentWidget.id) return true;

      if (widget.children != null) {
        for (var child in widget.children!) {
          if (containsWidget(child)) return true;
        }
      }

      if (widget.containerChild != null) {
        if (containsWidget(widget.containerChild!)) return true;
      }

      return false;
    }

    void searchForParent(PageBuilderWidget widget) {
      if (widget.elementType == PageBuilderWidgetType.row &&
          widget.children != null) {
        // Check if currentWidget is anywhere in the children tree
        for (var child in widget.children!) {
          if (containsWidget(child)) {
            parentRow = widget;
            return;
          }
        }
      }

      if (widget.children != null) {
        for (var child in widget.children!) {
          searchForParent(child);
        }
      }
      if (widget.containerChild != null) {
        searchForParent(widget.containerChild!);
      }
    }

    if (state.content.content?.sections != null) {
      for (var section in state.content.content!.sections!) {
        if (section.widgets != null) {
          for (var widget in section.widgets!) {
            searchForParent(widget);
          }
        }
      }
    }

    return parentRow;
  }

  double? calculateTotalWidthPercentage(
      PageBuilderWidget? parentRow, PagebuilderResponsiveBreakpoint breakpoint) {
    if (parentRow == null || parentRow.children == null) return null;

    return parentRow.children!.fold<double>(
      0,
      (sum, child) =>
          sum +
          (child.widthPercentage?.getValueForBreakpoint(breakpoint) ?? 0),
    );
  }

  bool shouldShowWarning(PagebuilderResponsiveBreakpoint breakpoint) {
    final parentRow = findParentRow();
    final totalWidth = calculateTotalWidthPercentage(parentRow, breakpoint);
    return totalWidth != null && totalWidth > 100;
  }

  double? getTotalWidth(PagebuilderResponsiveBreakpoint breakpoint) {
    final parentRow = findParentRow();
    return calculateTotalWidthPercentage(parentRow, breakpoint);
  }
}
