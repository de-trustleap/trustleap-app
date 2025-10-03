import 'package:flutter_test/flutter_test.dart';
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
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

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
          fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
          fontFamily: "TestFont",
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          isBold: null,
          isItalic: null);

      final mockTextProperties2 = PageBuilderTextProperties(
          text: "Text 2",
          fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
          fontFamily: "TestFont",
          color: Colors.red,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
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
          showPromoterImage: false,
          contentMode: BoxFit.cover,
          overlayPaint: null);

      final mockTextWidget1 = PageBuilderWidget(
          id: UniqueID.fromUniqueString("widget1"),
          elementType: PageBuilderWidgetType.text,
          background: null,
          hoverBackground: null,
          properties: mockTextProperties1,
          hoverProperties: null,
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
          hoverBackground: null,
          properties: mockTextProperties2,
          hoverProperties: null,
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
          hoverBackground: null,
          properties: mockImageProperties,
          hoverProperties: null,
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
          hoverBackground: null,
          properties: null,
          hoverProperties: null,
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
          hoverBackground: null,
          properties: null,
          hoverProperties: null,
          children: [mockTextWidget1, mockImageWidget],
          containerChild: null,
          widthPercentage: 100.0,
          maxWidth: null,
          alignment: null,
          margin: null,
          padding: null);

      final mockSection = PageBuilderSection(
        id: UniqueID.fromUniqueString("section1"),
        name: "Mock Section",
        layout: PageBuilderSectionLayout.column,
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        widgets: [mockColumnWidget, mockRowWidget],
      );

      mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        backgroundColor: null,
        sections: [mockSection],
      );
    });

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
        hoverBackground: null,
        properties: null,
        hoverProperties: null,
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
}