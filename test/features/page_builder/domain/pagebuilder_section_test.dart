import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_background.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PagebuilderSection_CopyWith", () {
    test(
        "set maxWidth and widgets with copyWith should set maxWidth and widgets for resulting object",
        () {
      // Given
      final section = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          name: "Test Section",
          widgets: [
            PageBuilderWidget(
                id: UniqueID.fromUniqueString("2"),
                elementType: PageBuilderWidgetType.column,
                properties: PagebuilderColumnProperties(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start),
                hoverProperties: null,
                children: [],
                containerChild: null,
                widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
                background: PagebuilderBackground(
                    backgroundPaint: const PagebuilderPaint.color(Colors.white),
                    imageProperties: null,
                    overlayPaint: null),
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null,
                customCSS: null)
          ],
          background: null,
          maxWidth: 300,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          visibleOn: null);
      final expectedResult = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          name: "Test Section",
          widgets: [
            PageBuilderWidget(
                id: UniqueID.fromUniqueString("2"),
                elementType: PageBuilderWidgetType.column,
                properties: PagebuilderColumnProperties(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start),
                hoverProperties: null,
                children: [],
                containerChild: null,
                widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
                background: PagebuilderBackground(
                    backgroundPaint: const PagebuilderPaint.color(Colors.white),
                    imageProperties: null,
                    overlayPaint: null),
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: const PagebuilderResponsiveOrConstant.constant(Alignment.center),
                customCSS: null)
          ],
          background: null,
          maxWidth: 400,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          visibleOn: null);
      // When
      final result = section.copyWith(maxWidth: 400, widgets: [
        PageBuilderWidget(
            id: UniqueID.fromUniqueString("2"),
            elementType: PageBuilderWidgetType.column,
            properties: PagebuilderColumnProperties(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start),
            hoverProperties: null,
            children: [],
            containerChild: null,
            widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
            background: PagebuilderBackground(
                backgroundPaint: const PagebuilderPaint.color(Colors.white),
                imageProperties: null,
                overlayPaint: null),
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: 300,
            alignment: const PagebuilderResponsiveOrConstant.constant(Alignment.center),
            customCSS: null)
      ]);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSection_Props", () {
    test("check if value equality works", () {
      // Given
      final section1 = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          name: "Test Section",
          widgets: [
            PageBuilderWidget(
                id: UniqueID.fromUniqueString("2"),
                elementType: PageBuilderWidgetType.column,
                properties: PagebuilderColumnProperties(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start),
                hoverProperties: null,
                children: [],
                containerChild: null,
                widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
                background: PagebuilderBackground(
                    backgroundPaint: const PagebuilderPaint.color(Colors.white),
                    imageProperties: null,
                    overlayPaint: null),
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null,
                customCSS: null)
          ],
          background: null,
          maxWidth: 300,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          visibleOn: null);
      final section2 = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          name: "Test Section",
          widgets: [
            PageBuilderWidget(
                id: UniqueID.fromUniqueString("2"),
                elementType: PageBuilderWidgetType.column,
                properties: PagebuilderColumnProperties(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start),
                hoverProperties: null,
                children: [],
                containerChild: null,
                widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
                background: PagebuilderBackground(
                    backgroundPaint: const PagebuilderPaint.color(Colors.white),
                    imageProperties: null,
                    overlayPaint: null),
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null,
                customCSS: null)
          ],
          background: null,
          maxWidth: 300,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          visibleOn: null);
      // Then
      expect(section1, section2);
    });
  });
}
