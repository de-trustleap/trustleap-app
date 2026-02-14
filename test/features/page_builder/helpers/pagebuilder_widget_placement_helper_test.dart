import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/pagebuilder_widget_placement_helper.dart';
import 'package:finanzbegleiter/constants.dart';

void main() {
  group("PagebuilderWidgetPlacementHelper.needsWrapping", () {
    test("returns false if parentType is null", () {
      final result = PagebuilderWidgetPlacementHelper.needsWrapping(
        position: DropPosition.before,
        parentType: null,
      );
      expect(result, isFalse);
    });

    test("returns true for horizontal placement inside column", () {
      final result = PagebuilderWidgetPlacementHelper.needsWrapping(
        position: DropPosition.before,
        parentType: PageBuilderWidgetType.column,
      );
      expect(result, isTrue);
    });

    test("returns true for vertical placement inside row", () {
      final result = PagebuilderWidgetPlacementHelper.needsWrapping(
        position: DropPosition.above,
        parentType: PageBuilderWidgetType.row,
      );
      expect(result, isTrue);
    });

    test("returns false for horizontal placement inside row", () {
      final result = PagebuilderWidgetPlacementHelper.needsWrapping(
        position: DropPosition.before,
        parentType: PageBuilderWidgetType.row,
      );
      expect(result, isFalse);
    });

    test("returns false for vertical placement inside column", () {
      final result = PagebuilderWidgetPlacementHelper.needsWrapping(
        position: DropPosition.above,
        parentType: PageBuilderWidgetType.column,
      );
      expect(result, isFalse);
    });
  });

  group("PagebuilderWidgetPlacementHelper.wrapWidgets", () {
    final target = PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.text,
      properties: null,
      hoverProperties: null,
      children: const [],
      containerChild: null,
      widthPercentage: const PagebuilderResponsiveOrConstant.constant(80),
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    final newWidget = PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.text,
      properties: null,
      hoverProperties: null,
      children: const [],
      containerChild: null,
      widthPercentage: const PagebuilderResponsiveOrConstant.constant(20),
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    test("creates a Column with new widget above", () {
      final wrapped = PagebuilderWidgetPlacementHelper.wrapWidgets(
        targetWidget: target,
        newWidget: newWidget,
        position: DropPosition.above,
      );

      expect(wrapped.elementType, equals(PageBuilderWidgetType.column));
      expect(wrapped.children!.first.id, equals(newWidget.id));
      expect(wrapped.children!.last.id, equals(target.id));
      expect(wrapped.properties, isA<PagebuilderColumnProperties>());
      expect(wrapped.widthPercentage, equals(target.widthPercentage));
    });

    test("creates a Column with new widget below", () {
      final wrapped = PagebuilderWidgetPlacementHelper.wrapWidgets(
        targetWidget: target,
        newWidget: newWidget,
        position: DropPosition.below,
      );

      expect(wrapped.elementType, equals(PageBuilderWidgetType.column));
      expect(wrapped.children!.first.id, equals(target.id));
      expect(wrapped.children!.last.id, equals(newWidget.id));
    });

    test("creates a Row with new widget before", () {
      final wrapped = PagebuilderWidgetPlacementHelper.wrapWidgets(
        targetWidget: target,
        newWidget: newWidget,
        position: DropPosition.before,
      );

      expect(wrapped.elementType, equals(PageBuilderWidgetType.row));
      expect(wrapped.children!.length, equals(2));

      final first = wrapped.children!.first;
      final last = wrapped.children!.last;

      expect(first.widthPercentage?.constantValue, equals(50));
      expect(last.widthPercentage?.constantValue, equals(50));

      expect(first.id, equals(newWidget.id));
      expect(last.id, equals(target.id));
      expect(wrapped.properties, isA<PagebuilderRowProperties>());
    });

    test("creates a Row with new widget after", () {
      final wrapped = PagebuilderWidgetPlacementHelper.wrapWidgets(
        targetWidget: target,
        newWidget: newWidget,
        position: DropPosition.after,
      );

      expect(wrapped.elementType, equals(PageBuilderWidgetType.row));
      expect(wrapped.children!.first.id, equals(target.id));
      expect(wrapped.children!.last.id, equals(newWidget.id));
    });
  });

  group("PagebuilderWidgetPlacementHelper.redistributeWidthPercentages", () {
    test("returns empty list if children is empty", () {
      final result =
          PagebuilderWidgetPlacementHelper.redistributeWidthPercentages([]);
      expect(result, isEmpty);
    });

    test("redistributes width equally among children", () {
      final children = [
        PageBuilderWidget(
          id: UniqueID(),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: const [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        ),
        PageBuilderWidget(
          id: UniqueID(),
          elementType: PageBuilderWidgetType.text,
          properties: null,
          hoverProperties: null,
          children: const [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(70),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null,
        ),
      ];

      final redistributed =
          PagebuilderWidgetPlacementHelper.redistributeWidthPercentages(
              children);

      expect(redistributed, hasLength(2));
      expect(redistributed.first.widthPercentage?.constantValue,
          closeTo(50.0, 0.001));
      expect(redistributed.last.widthPercentage?.constantValue,
          closeTo(50.0, 0.001));
    });
  });
}
