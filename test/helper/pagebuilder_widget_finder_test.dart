import 'package:test/test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_finder.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

void main() {
  group('PagebuilderWidgetFinder_findWidgetById', () {
    late PagebuilderWidgetFinder widgetFinder;
    late PageBuilderPage mockPageBuilderPage;
    late UniqueID widgetId1, widgetId2, widgetId3, widgetIdColumn, widgetIdRow;

    setUp(() {
      widgetFinder = PagebuilderWidgetFinder();

      widgetId1 = UniqueID.fromUniqueString("widget1");
      widgetId2 = UniqueID.fromUniqueString("widget2");
      widgetId3 = UniqueID.fromUniqueString("widget3");
      widgetIdColumn = UniqueID.fromUniqueString("columnWidget");
      widgetIdRow = UniqueID.fromUniqueString("rowWidget");

      final mockTextProperties1 = PageBuilderTextProperties(
          text: "Text 1",
          fontSize: 16.0,
          fontFamily: "TestFont",
          color: Colors.black,
          alignment: TextAlign.left,
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          isBold: null,
          isItalic: null);

      final mockTextProperties2 = PageBuilderTextProperties(
          text: "Text 2",
          fontSize: 18.0,
          fontFamily: "TestFont",
          color: Colors.red,
          alignment: TextAlign.center,
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          isBold: null,
          isItalic: null);

      final mockImageProperties = PageBuilderImageProperties(
          url: "https://example.com/image.png",
          borderRadius: 10.0,
          width: 100.0,
          height: 150.0,
          localImage: Uint8List(0),
          alignment: Alignment.center,
          contentMode: BoxFit.cover);

      final mockTextWidget1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString("widget1"),
          elementType: PageBuilderWidgetType.text,
          background: null,
          properties: mockTextProperties1,
          children: [],
          widthPercentage: 100.0,
          containerChild: null,
          maxWidth: null,
          alignment: null,
          margin: null,
          padding:
              PageBuilderSpacing(top: 8.0, bottom: 8.0, left: 5.0, right: 5.0));

      final mockTextWidget2 = PageBuilderWidget(
          id: UniqueID.fromUniqueString("widget2"),
          elementType: PageBuilderWidgetType.text,
          background: null,
          properties: mockTextProperties2,
          children: [],
          widthPercentage: 100.0,
          maxWidth: null,
          containerChild: null,
          alignment: null,
          margin: null,
          padding:
              PageBuilderSpacing(top: 8.0, bottom: 8.0, left: 5.0, right: 5.0));

      final mockImageWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString("widget3"),
          elementType: PageBuilderWidgetType.image,
          background: null,
          properties: mockImageProperties,
          children: [],
          containerChild: null,
          widthPercentage: 100.0,
          maxWidth: null,
          alignment: null,
          margin: null,
          padding: null);

      final mockColumnWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString("columnWidget"),
          elementType: PageBuilderWidgetType.column,
          background: null,
          properties: null,
          children: [mockTextWidget1, mockTextWidget2, mockImageWidget],
          containerChild: null,
          widthPercentage: 100.0,
          maxWidth: null,
          alignment: null,
          margin: null,
          padding: null);

      final mockRowWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString("rowWidget"),
          elementType: PageBuilderWidgetType.row,
          background: null,
          properties: null,
          children: [mockTextWidget1, mockImageWidget],
          containerChild: null,
          widthPercentage: 100.0,
          maxWidth: null,
          alignment: null,
          margin: null,
          padding: null);

      final mockSection = PageBuilderSection(
        id: UniqueID.fromUniqueString("section1"),
        layout: PageBuilderSectionLayout.column,
        backgroundColor: null,
        maxWidth: null,
        widgets: [mockColumnWidget, mockRowWidget],
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        backgroundColor: null,
        sections: [mockSection],
      );

      test('should return null if widget is not found by id', () {
        final nonExistentWidgetId =
            UniqueID.fromUniqueString("nonExistentWidget");
        final foundWidget = widgetFinder.findWidgetById(
            mockPageBuilderPage, nonExistentWidgetId);
        expect(foundWidget, isNull);
      });

      test('should find widget in children of a column widget', () {
        final foundWidget =
            widgetFinder.findWidgetById(mockPageBuilderPage, widgetId1);
        expect(foundWidget?.id, equals(widgetId1));
      });

      test('should find widget in a row widget children', () {
        final foundWidget =
            widgetFinder.findWidgetById(mockPageBuilderPage, widgetId3);
        expect(foundWidget?.id, equals(widgetId3));
      });

      test('should find widget in containerChild if nested', () {
        final containerWidget = PageBuilderWidget(
          id: UniqueID.fromUniqueString("containerWidget"),
          elementType: PageBuilderWidgetType.container,
          children: [],
          background: null,
          properties: null,
          containerChild: mockPageBuilderPage.sections![0].widgets![0],
          widthPercentage: 100.0,
          maxWidth: null,
          alignment: null,
          margin: null,
          padding: null,
        );

        final foundWidget =
            widgetFinder.findWidgetById(mockPageBuilderPage, widgetId1);
        expect(foundWidget?.id, equals(widgetId1));
      });

      test(
          'should return null if widget is not found in containerChild or children',
          () {
        final nonExistentWidgetId =
            UniqueID.fromUniqueString("nonExistentWidget");
        final foundWidget = widgetFinder.findWidgetById(
            mockPageBuilderPage, nonExistentWidgetId);
        expect(foundWidget, isNull);
      });
    });
  });
}
