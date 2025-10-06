import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late MockAppLocalizations mockLocalizations;

  setUp(() {
    mockLocalizations = MockAppLocalizations();
  });

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
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null);

      final expectedResult = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.row,
          properties: PagebuilderRowProperties(
              equalHeights: null,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              switchToColumnFor: null),
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null);
      // When
      final result = model.copyWith(
          elementType: PageBuilderWidgetType.row,
          properties: PagebuilderRowProperties(
              equalHeights: null,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              switchToColumnFor: null));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderWidget_GetWidgetTitle", () {
    test("test if column type returns column string", () {
      // Given
      final model = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.column,
          properties: PagebuilderColumnProperties(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center),
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null);
      final expectedResult = "Spalte";
      when(mockLocalizations.landingpage_pagebuilder_config_menu_column_type)
          .thenReturn("Spalte");
      // When
      final result = model.getWidgetTitle(mockLocalizations);
      // Then
      expect(result, expectedResult);
    });

    test("test if icon type returns icon string", () {
      // Given
      final model = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.icon,
          properties: const PageBuilderIconProperties(
              code: "55",
              size: PagebuilderResponsiveOrConstant.constant(24.0),
              color: Colors.black),
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null);
      final expectedResult = "Icon";
      when(mockLocalizations.landingpage_pagebuilder_config_menu_icon_type)
          .thenReturn("Icon");
      // When
      final result = model.getWidgetTitle(mockLocalizations);
      // Then
      expect(result, expectedResult);
    });

    test("test if unkown type returns unknown string", () {
      // Given
      final model = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.none,
          properties: const PageBuilderIconProperties(
              code: "55",
              size: PagebuilderResponsiveOrConstant.constant(24.0),
              color: Colors.black),
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null);
      final expectedResult = "Unbekannt";
      when(mockLocalizations.landingpage_pagebuilder_config_menu_unknown_type)
          .thenReturn("Unbekannt");
      // When
      final result = model.getWidgetTitle(mockLocalizations);
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
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null);
      final widget2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.column,
          properties: PagebuilderColumnProperties(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center),
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null);
      // Then
      expect(widget1, widget2);
    });
  });
}
