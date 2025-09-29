import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';

void main() {
  group("PagebuilderSection_CopyWith", () {
    test(
        "set maxWidth and widgets with copyWith should set maxWidth and widgets for resulting object",
        () {
      // Given
      final section = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          layout: PageBuilderSectionLayout.column,
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
                widthPercentage: 30,
                background: PagebuilderBackground(
                    backgroundPaint: const PagebuilderPaint.color(Colors.white),
                    imageProperties: null,
                    overlayPaint: null),
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null)
          ],
          background: null,
          maxWidth: 300,
          backgroundConstrained: null);
      final expectedResult = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          layout: PageBuilderSectionLayout.column,
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
                widthPercentage: 30,
                background: PagebuilderBackground(
                    backgroundPaint: const PagebuilderPaint.color(Colors.white),
                    imageProperties: null,
                    overlayPaint: null),
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: Alignment.center)
          ],
          background: null,
          maxWidth: 400,
          backgroundConstrained: null);
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
            widthPercentage: 30,
            background: PagebuilderBackground(
                backgroundPaint: const PagebuilderPaint.color(Colors.white),
                imageProperties: null,
                overlayPaint: null),
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: 300,
            alignment: Alignment.center)
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
          layout: PageBuilderSectionLayout.column,
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
                widthPercentage: 30,
                background: PagebuilderBackground(
                    backgroundPaint: const PagebuilderPaint.color(Colors.white),
                    imageProperties: null,
                    overlayPaint: null),
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null)
          ],
          background: null,
          maxWidth: 300,
          backgroundConstrained: null);
      final section2 = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          layout: PageBuilderSectionLayout.column,
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
                widthPercentage: 30,
                background: PagebuilderBackground(
                    backgroundPaint: const PagebuilderPaint.color(Colors.white),
                    imageProperties: null,
                    overlayPaint: null),
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null)
          ],
          background: null,
          maxWidth: 300,
          backgroundConstrained: null);
      // Then
      expect(section1, section2);
    });
  });
}
