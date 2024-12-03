import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';

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
                children: [],
                containerChild: null,
                widthPercentage: 30,
                background: PagebuilderBackground(
                    backgroundColor: Colors.white,
                    imageProperties: null,
                    overlayColor: null),
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null)
          ],
          backgroundColor: null,
          maxWidth: 300);
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
                children: [],
                containerChild: null,
                widthPercentage: 30,
                background: PagebuilderBackground(
                    backgroundColor: Colors.white,
                    imageProperties: null,
                    overlayColor: null),
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: Alignment.center)
          ],
          backgroundColor: null,
          maxWidth: 400);
      // When
      final result = section.copyWith(maxWidth: 400, widgets: [
        PageBuilderWidget(
            id: UniqueID.fromUniqueString("2"),
            elementType: PageBuilderWidgetType.column,
            properties: PagebuilderColumnProperties(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start),
            children: [],
            containerChild: null,
            widthPercentage: 30,
            background: PagebuilderBackground(
                backgroundColor: Colors.white,
                imageProperties: null,
                overlayColor: null),
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
                children: [],
                containerChild: null,
                widthPercentage: 30,
                background: PagebuilderBackground(
                    backgroundColor: Colors.white,
                    imageProperties: null,
                    overlayColor: null),
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null)
          ],
          backgroundColor: null,
          maxWidth: 300);
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
                children: [],
                containerChild: null,
                widthPercentage: 30,
                background: PagebuilderBackground(
                    backgroundColor: Colors.white,
                    imageProperties: null,
                    overlayColor: null),
                padding: null,
                margin: null,
                maxWidth: 300,
                alignment: null)
          ],
          backgroundColor: null,
          maxWidth: 300);
      // Then
      expect(section1, section2);
    });
  });
}
