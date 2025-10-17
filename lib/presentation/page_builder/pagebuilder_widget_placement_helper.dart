import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PagebuilderWidgetPlacementHelper {
  static bool needsWrapping({
    required DropPosition position,
    required PageBuilderWidgetType? parentType,
  }) {
    if (parentType == null) return false;

    final isHorizontalPlacement =
        position == DropPosition.before || position == DropPosition.after;
    final isVerticalPlacement =
        position == DropPosition.above || position == DropPosition.below;
    final parentIsColumn = parentType == PageBuilderWidgetType.column;
    final parentIsRow = parentType == PageBuilderWidgetType.row;

    return (isHorizontalPlacement && parentIsColumn) ||
        (isVerticalPlacement && parentIsRow);
  }

  /// Wraps two widgets in an appropriate container (Row or Column) based on position.
  /// For horizontal placement (before/after):
  /// - Creates a Row with 50/50 width distribution
  /// For vertical placement (above/below):
  /// - Creates a Column
  /// - If target widget has widthPercentage, the Column inherits it (for Row parents)
  static PageBuilderWidget wrapWidgets({
    required PageBuilderWidget targetWidget,
    required PageBuilderWidget newWidget,
    required DropPosition position,
  }) {
    final isVertical =
        position == DropPosition.above || position == DropPosition.below;

    List<PageBuilderWidget> children;

    if (isVertical) {
      children = (position == DropPosition.above)
          ? [newWidget, targetWidget]
          : [targetWidget, newWidget];
    } else {
      const equalWidthPercentage =
          PagebuilderResponsiveOrConstant.constant(50.0);
      final newWidgetWithWidth =
          newWidget.copyWith(widthPercentage: equalWidthPercentage);
      final targetWidgetWithWidth =
          targetWidget.copyWith(widthPercentage: equalWidthPercentage);

      children = (position == DropPosition.before)
          ? [newWidgetWithWidth, targetWidgetWithWidth]
          : [targetWidgetWithWidth, newWidgetWithWidth];
    }

    if (isVertical) {
      return PageBuilderWidget(
        id: UniqueID(),
        elementType: PageBuilderWidgetType.column,
        properties: const PagebuilderColumnProperties(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        hoverProperties: null,
        children: children,
        containerChild: null,
        widthPercentage: targetWidget.widthPercentage,
        background: null,
        hoverBackground: null,
        padding: null,
        margin: null,
        maxWidth: null,
        alignment: null,
        customCSS: null,
      );
    } else {
      return PageBuilderWidget(
        id: UniqueID(),
        elementType: PageBuilderWidgetType.row,
        properties: const PagebuilderRowProperties(
          equalHeights: false,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          switchToColumnFor: null,
        ),
        hoverProperties: null,
        children: children,
        containerChild: null,
        widthPercentage: null,
        background: null,
        hoverBackground: null,
        padding: null,
        margin: null,
        maxWidth: null,
        alignment: null,
        customCSS: null,
      );
    }
  }

  static List<PageBuilderWidget> redistributeWidthPercentages(
    List<PageBuilderWidget> children,
  ) {
    if (children.isEmpty) return children;

    final totalChildren = children.length;
    final equalWidth = 100.0 / totalChildren;
    final equalWidthPercentage =
        PagebuilderResponsiveOrConstant.constant(equalWidth);

    return children
        .map((child) => child.copyWith(widthPercentage: equalWidthPercentage))
        .toList();
  }
}
