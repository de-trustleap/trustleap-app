import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_widget_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';

void main() {
  group("PagebuilderWidgetModel_CopyWith", () {
    test("set padding with copyWith should set padding for resulting object",
        () {
      // Given
      final model = PageBuilderWidgetModel(
          id: "1",
          elementType: "container",
          properties: {},
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstantModel.constant(30),
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null);
      final expectedResult = PageBuilderWidgetModel(
          id: "1",
          elementType: "container",
          properties: {},
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstantModel.constant(30),
          background: null,
          hoverBackground: null,
          padding: {"top": 16, "bottom": 16, "left": 0, "right": 0},
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null);
      // When
      final result = model
          .copyWith(padding: {"top": 16, "bottom": 16, "left": 0, "right": 0});
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderWidgetModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderWidgetModel(
          id: "1",
          elementType: "container",
          properties: {},
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstantModel.constant(30),
          background: {"backgroundPaint": {"color": "FFFFFFFF"}},
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: 300.0,
          alignment: null,
          customCSS: null);
      final expectedResult = {
        "id": "1",
        "elementType": "container",
        "properties": {},
        "children": [],
        "widthPercentage": 30,
        "background": {"backgroundPaint": {"color": "FFFFFFFF"}},
        "maxWidth": 300
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderWidgetModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "id": "1",
        "elementType": "container",
        "children": [],
        "widthPercentage": 30.0,
        "background": {"backgroundPaint": {"color": "FFFFFFFF"}},
        "maxWidth": 300.0
      };
      final expectedResult = PageBuilderWidgetModel(
          id: "1",
          elementType: "container",
          properties: null,
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstantModel.constant(30.0),
          background: {"backgroundPaint": {"color": "FFFFFFFF"}},
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: 300.0,
          alignment: null,
          customCSS: null);
      // When
      final result = PageBuilderWidgetModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderWidgetModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderWidgetModel to PagebuilderWidget works",
        () {
      // Given
      final model = PageBuilderWidgetModel(
          id: "1",
          elementType: "container",
          properties: {},
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstantModel.constant(30.0),
          background: {"backgroundPaint": {"color": "FFFFFFFF"}},
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: 300.0,
          alignment: null,
          customCSS: null);
      final expectedResult = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.container,
          properties:
              PageBuilderContainerProperties(border: null, shadow: null),
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
          background: PagebuilderBackground(
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
              imageProperties: null,
              overlayPaint: null),
          hoverBackground: null,
          padding: const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(0), bottom: PagebuilderResponsiveOrConstant.constant(0), left: PagebuilderResponsiveOrConstant.constant(0), right: PagebuilderResponsiveOrConstant.constant(0)),
          margin: const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(0), bottom: PagebuilderResponsiveOrConstant.constant(0), left: PagebuilderResponsiveOrConstant.constant(0), right: PagebuilderResponsiveOrConstant.constant(0)),
          maxWidth: 300,
          alignment: null,
          customCSS: null);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderWidgetModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderWidget to PagebuilderWidgetModel works",
        () {
      // Given
      final model = PageBuilderWidget(
          id: UniqueID.fromUniqueString("1"),
          elementType: PageBuilderWidgetType.container,
          properties:
              PageBuilderContainerProperties(border: null, shadow: null),
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstant.constant(30),
          background: PagebuilderBackground(
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
              imageProperties: null,
              overlayPaint: null),
          hoverBackground: null,
          padding: const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(0), bottom: PagebuilderResponsiveOrConstant.constant(0), left: PagebuilderResponsiveOrConstant.constant(0), right: PagebuilderResponsiveOrConstant.constant(0)),
          margin: null,
          maxWidth: 300,
          alignment: null,
          customCSS: null);
      final expectedResult = PageBuilderWidgetModel(
          id: "1",
          elementType: "container",
          properties: {},
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstantModel.constant(30.0),
          background: {"backgroundPaint": {"color": "FFFFFFFF"}},
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: 300.0,
          alignment: null,
          customCSS: null);
      // When
      final result = PageBuilderWidgetModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderWidgetModel_GetPropertiesByType", () {
    test("check if return the right properties for the specific string", () {
      // Given
      final type = "text";
      final properties = {
        "text": "Test",
        "fontSize": 16.0,
        "fontFamily": "Poppins",
        "lineHeight": 1.5
      };
      final model = PageBuilderWidgetModel(
          id: "1",
          elementType: "column",
          properties: properties,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null);
      final expectedResult = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: null,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left));
      // When
      final result = model.getPropertiesByType(type, properties);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderWidgetModel_GetMapFromProperties", () {
    test("check if returns correct map from properties", () {
      // Given
      final properties = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: null,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left));
      final expectedResult = {
        "text": "Test",
        "fontSize": 16.0,
        "fontFamily": "Poppins",
        "alignment": "left",
        "lineHeight": 1.5
      };
      // When
      final result = PageBuilderWidgetModel.getMapFromProperties(properties);
      // Then
      expect(result, expectedResult);
    });
  });


  group("PagebuilderWidgetModel_Props", () {
    test("check if value equality works", () {
      // Given
      final widget1 = PageBuilderWidgetModel(
          id: "1",
          elementType: "container",
          properties: {},
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstantModel.constant(30.0),
          background: {"backgroundPaint": {"color": "FFFFFFFF"}},
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: 300.0,
          alignment: null,
          customCSS: null);
      final widget2 = PageBuilderWidgetModel(
          id: "1",
          elementType: "container",
          properties: {},
          hoverProperties: null,
          children: [],
          containerChild: null,
          widthPercentage: const PagebuilderResponsiveOrConstantModel.constant(30.0),
          background: {"backgroundPaint": {"color": "FFFFFFFF"}},
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: 300.0,
          alignment: null,
          customCSS: null);
      // Then
      expect(widget1, widget2);
    });
  });

  group("PagebuilderWidgetModel_ConvertAlignmentToDomain", () {
    test("check if constant alignment is converted correctly from model to domain", () {
      // Given
      final alignmentModel = const PagebuilderResponsiveOrConstantModel<String>.constant("center");
      final expectedResult = const PagebuilderResponsiveOrConstant<Alignment>.constant(Alignment.center);

      // When
      final result = PageBuilderWidgetModel(
          id: "test",
          elementType: "container",
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: alignmentModel,
          customCSS: null).toDomain().alignment;

      // Then
      expect(result, expectedResult);
    });

    test("check if responsive alignment is converted correctly from model to domain", () {
      // Given
      final alignmentModel = const PagebuilderResponsiveOrConstantModel<String>.responsive({
        "mobile": "topLeft",
        "tablet": "center",
        "desktop": "bottomRight"
      });
      final expectedResult = const PagebuilderResponsiveOrConstant<Alignment>.responsive({
        "mobile": Alignment.topLeft,
        "tablet": Alignment.center,
        "desktop": Alignment.bottomRight
      });

      // When
      final result = PageBuilderWidgetModel(
          id: "test",
          elementType: "container",
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: alignmentModel,
          customCSS: null).toDomain().alignment;

      // Then
      expect(result, expectedResult);
    });

    test("check if null alignment is handled correctly", () {
      // Given
      const PagebuilderResponsiveOrConstantModel<String>? alignmentModel = null;

      // When
      final result = PageBuilderWidgetModel(
          id: "test",
          elementType: "container",
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: alignmentModel,
          customCSS: null).toDomain().alignment;

      // Then
      expect(result, null);
    });
  });

  group("PagebuilderWidgetModel_ConvertAlignmentFromDomain", () {
    test("check if constant alignment is converted correctly from domain to model", () {
      // Given
      final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString("test"),
          elementType: PageBuilderWidgetType.container,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: const PagebuilderResponsiveOrConstant<Alignment>.constant(Alignment.center),
          customCSS: null);
      final expectedResult = const PagebuilderResponsiveOrConstantModel<String>.constant("center");

      // When
      final result = PageBuilderWidgetModel.fromDomain(widget).alignment;

      // Then
      expect(result, expectedResult);
    });

    test("check if responsive alignment is converted correctly from domain to model", () {
      // Given
      final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString("test"),
          elementType: PageBuilderWidgetType.container,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: const PagebuilderResponsiveOrConstant<Alignment>.responsive({
            "mobile": Alignment.topLeft,
            "tablet": Alignment.center,
            "desktop": Alignment.bottomRight
          }),
          customCSS: null);
      final expectedResult = const PagebuilderResponsiveOrConstantModel<String>.responsive({
        "mobile": "topLeft",
        "tablet": "center",
        "desktop": "bottomRight"
      });

      // When
      final result = PageBuilderWidgetModel.fromDomain(widget).alignment;

      // Then
      expect(result, expectedResult);
    });

    test("check if null alignment is handled correctly from domain to model", () {
      // Given
      final widget = PageBuilderWidget(
          id: UniqueID.fromUniqueString("test"),
          elementType: PageBuilderWidgetType.container,
          properties: null,
          hoverProperties: null,
          children: null,
          containerChild: null,
          widthPercentage: null,
          background: null,
          hoverBackground: null,
          padding: null,
          margin: null,
          maxWidth: null,
          alignment: null,
          customCSS: null);

      // When
      final result = PageBuilderWidgetModel.fromDomain(widget).alignment;

      // Then
      expect(result, null);
    });
  });
}
