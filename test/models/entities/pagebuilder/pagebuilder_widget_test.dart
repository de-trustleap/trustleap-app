import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';

void main() {
  group("PagebuilderWidget_CopyWith", () {
    test(
        "set elementType and properties with copyWith should set elementType and properties for resulting object",
        () {
      // Given
      final model = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.column,
          properties: PagebuilderColumnProperties(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center),
          children: [],
          containerChild: null,
          widthPercentage: null,
          backgroundColor: null,
          padding: null,
          maxWidth: null,
          alignment: null);

      final expectedResult = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.row,
          properties: PagebuilderRowProperties(
              equalHeights: null,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center),
          children: [],
          containerChild: null,
          widthPercentage: null,
          backgroundColor: null,
          padding: null,
          maxWidth: null,
          alignment: null);
      // When
      final result = model.copyWith(
          elementType: PageBuilderWidgetType.row,
          properties: PagebuilderRowProperties(
              equalHeights: null,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderWidget_Props", () {
    test("check if value equality works", () {
      // Given
      final widget1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.column,
          properties: PagebuilderColumnProperties(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center),
          children: [],
          containerChild: null,
          widthPercentage: null,
          backgroundColor: null,
          padding: null,
          maxWidth: null,
          alignment: null);
      final widget2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.column,
          properties: PagebuilderColumnProperties(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center),
          children: [],
          containerChild: null,
          widthPercentage: null,
          backgroundColor: null,
          padding: null,
          maxWidth: null,
          alignment: null);
      // Then
      expect(widget1, widget2);
    });
  });
}
