import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';

void main() {
  group("PagebuilderSectionModel_CopyWith", () {
    test("set maxWidth with copyWith should set maxWidth for resulting object",
        () {
      // Given
      final section = PageBuilderSectionModel(
          id: "1",
          layout: "column",
          background: null,
          maxWidth: 300, backgroundConstrained: null,
          widgets: []);
      final expectedResult = PageBuilderSectionModel(
          id: "1",
          layout: "column",
          background: null,
          maxWidth: 500, backgroundConstrained: null,
          widgets: []);
      // When
      final result = section.copyWith(maxWidth: 500);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderSectionModel(
          id: "1",
          layout: "column",
          background: null,
          maxWidth: 300, backgroundConstrained: null,
          widgets: []);
      final expectedResult = {
        "id": "1",
        "layout": "column",
        "maxWidth": 300,
        "widgets": []
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "id": "1",
        "layout": "column",
        "maxWidth": 300.0,
        "widgets": []
      };
      final expectedResult = PageBuilderSectionModel(
          id: "1",
          layout: "column",
          background: null,
          maxWidth: 300, backgroundConstrained: null,
          widgets: []);
      // When
      final result = PageBuilderSectionModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderSectionModel to PagebuilderSection works",
        () {
      // Given
      final model = PageBuilderSectionModel(
          id: "1",
          layout: "column",
          background: null,
          maxWidth: 800, backgroundConstrained: null,
          widgets: []);
      final expectedResult = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          layout: PageBuilderSectionLayout.column,
          widgets: [],
          background: null,
          maxWidth: 800, backgroundConstrained: null);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderSection to PagebuilderSectionModel works",
        () {
      // Given
      final model = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          layout: PageBuilderSectionLayout.column,
          widgets: [],
          background: null,
          maxWidth: 800, backgroundConstrained: null);
      final expectedResult = PageBuilderSectionModel(
          id: "1",
          layout: "column",
          background: null,
          maxWidth: 800, backgroundConstrained: null,
          widgets: []);
      // When
      final result = PageBuilderSectionModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionModel_GetPageBuilderWidgetList", () {
    test("check if return correct PagebuilderWidget list from map list", () {
      // Given
      final widgets = [
        {
          "id": "c558084f-fb4d-41ff-b320-b47596e24a0a",
          "elementType": "row",
          "padding": {"top": 40.0, "bottom": 20.0, "left": 20.0, "right": 20.0},
          "maxWidth": 950.0,
          "children": [
            {
              "id": "59473e09-b3f4-4662-ac92-e6c2828b9996",
              "elementType": "image",
              "widthPercentage": 50.0,
              "padding": {"right": 16.0},
              "properties": {
                "borderRadius": 100.0,
                "contentMode": "cover",
                "width": 200.0,
                "height": 200.0,
                "showPromoterImage": false,
                "url":
                    "https://firebasestorage.googleapis.com/v0/b/finanzwegbegleiter.appspot.com/o/landingPageContentImages%2FL9SPWUuY7mJKWUaX16Xt%2F4ce25fce-242b-471b-8a25-83e920e95e8d?alt=media&token=3c7bdc32-f607-4eee-923f-41410591d1d0"
              }
            },
            {
              "id": "660d39c1-70f7-4eb7-ba8b-41580a17d9a6",
              "elementType": "container",
              "widthPercentage": 50.0,
              "properties": {"borderRadius": 10.0},
              "containerChild": {
                "id": "d10d39c1-70f7-4eb7-ba8b-41580a17d9a6",
                "elementType": "text",
                "padding": {
                  "top": 20.0,
                  "right": 20.0,
                  "left": 20.0,
                  "bottom": 20.0
                },
                "properties": {
                  "alignment": "left",
                  "color": "FFFFFFFF",
                  "fontSize": 18.0,
                  "fontFamily": "Merriweather",
                  "isItalic": true,
                  "text":
                      "Du wurdest positiv von Max Mustermann\nweiterempfohlen.\nMax möchte, dass wir uns kennenlernen."
                }
              }
            }
          ]
        }
      ];
      final expectedResult = [
        PageBuilderWidget(
            id: UniqueID.fromUniqueString(
                "c558084f-fb4d-41ff-b320-b47596e24a0a"),
            elementType: PageBuilderWidgetType.row,
            properties: null,
            hoverProperties: null,
            children: [
              PageBuilderWidget(
                  id: UniqueID.fromUniqueString(
                      "59473e09-b3f4-4662-ac92-e6c2828b9996"),
                  elementType: PageBuilderWidgetType.image,
                  properties: PageBuilderImageProperties(
                      url:
                          "https://firebasestorage.googleapis.com/v0/b/finanzwegbegleiter.appspot.com/o/landingPageContentImages%2FL9SPWUuY7mJKWUaX16Xt%2F4ce25fce-242b-471b-8a25-83e920e95e8d?alt=media&token=3c7bdc32-f607-4eee-923f-41410591d1d0",
                      borderRadius: 100,
                      width: 200,
                      height: 200,
                      contentMode: BoxFit.cover,
                      overlayPaint: null,
                      showPromoterImage: false),
                  hoverProperties: null,
                  children: null,
                  containerChild: null,
                  widthPercentage: 50,
                  background: null,
                  hoverBackground: null,
                  padding:
                      PageBuilderSpacing(top: 0, bottom: 0, left: 0, right: 16),
                  margin:
                      PageBuilderSpacing(top: 0, bottom: 0, left: 0, right: 0),
                  maxWidth: null,
                  alignment: null),
              PageBuilderWidget(
                  id: UniqueID.fromUniqueString(
                      "660d39c1-70f7-4eb7-ba8b-41580a17d9a6"),
                  elementType: PageBuilderWidgetType.container,
                  properties: PageBuilderContainerProperties(
                      borderRadius: 10, shadow: null),
                  hoverProperties: null,
                  children: null,
                  containerChild: PageBuilderWidget(
                      id: UniqueID.fromUniqueString(
                          "d10d39c1-70f7-4eb7-ba8b-41580a17d9a6"),
                      elementType: PageBuilderWidgetType.text,
                      properties: PageBuilderTextProperties(
                          text:
                              "Du wurdest positiv von Max Mustermann\nweiterempfohlen.\nMax möchte, dass wir uns kennenlernen.",
                          fontSize: 18,
                          fontFamily: "Merriweather",
                          lineHeight: null,
                          letterSpacing: null,
                          textShadow: null,
                          color: Color(0xFFFFFFFF),
                          alignment: TextAlign.left,
                          isBold: null,
                          isItalic: true),
                      hoverProperties: null,
                      children: null,
                      containerChild: null,
                      widthPercentage: null,
                      background: null,
                      hoverBackground: null,
                      padding: PageBuilderSpacing(
                          top: 20, bottom: 20, left: 20, right: 20),
                      margin: PageBuilderSpacing(
                          top: 0, bottom: 0, left: 0, right: 0),
                      maxWidth: null,
                      alignment: null),
                  widthPercentage: 50,
                  background: null,
                  hoverBackground: null,
                  padding:
                      PageBuilderSpacing(top: 0, bottom: 0, left: 0, right: 0),
                  margin:
                      PageBuilderSpacing(top: 0, bottom: 0, left: 0, right: 0),
                  maxWidth: null,
                  alignment: null)
            ],
            containerChild: null,
            widthPercentage: null,
            background: null,
            hoverBackground: null,
            padding:
                PageBuilderSpacing(top: 40, bottom: 20, left: 20, right: 20),
            margin: PageBuilderSpacing(top: 0, bottom: 0, left: 0, right: 0),
            maxWidth: 950,
            alignment: null)
      ];
      final model = PageBuilderSectionModel(
          id: "1",
          layout: "column",
          background: null,
          maxWidth: 800, backgroundConstrained: null,
          widgets: widgets);
      // When
      final result = model.getPageBuilderWidgetList(widgets);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionModel_GetMapFromPageBuilderWidgetList", () {
    test(
        "check if return correct map list for given list of PagebuilderWidgets",
        () {
      // Given
      final widgets = [
        PageBuilderWidget(
            id: UniqueID.fromUniqueString(
                "c558084f-fb4d-41ff-b320-b47596e24a0a"),
            elementType: PageBuilderWidgetType.row,
            properties: null,
            hoverProperties: null,
            children: [
              PageBuilderWidget(
                  id: UniqueID.fromUniqueString(
                      "59473e09-b3f4-4662-ac92-e6c2828b9996"),
                  elementType: PageBuilderWidgetType.image,
                  properties: PageBuilderImageProperties(
                      url:
                          "https://firebasestorage.googleapis.com/v0/b/finanzwegbegleiter.appspot.com/o/landingPageContentImages%2FL9SPWUuY7mJKWUaX16Xt%2F4ce25fce-242b-471b-8a25-83e920e95e8d?alt=media&token=3c7bdc32-f607-4eee-923f-41410591d1d0",
                      borderRadius: 100,
                      width: 200,
                      height: 200,
                      contentMode: BoxFit.cover,
                      overlayPaint: null,
                      showPromoterImage: false),
                  hoverProperties: null,
                  children: null,
                  containerChild: null,
                  widthPercentage: 50,
                  background: null,
                  hoverBackground: null,
                  padding:
                      PageBuilderSpacing(top: 0, bottom: 0, left: 0, right: 16),
                  margin: null,
                  maxWidth: null,
                  alignment: null),
              PageBuilderWidget(
                  id: UniqueID.fromUniqueString(
                      "660d39c1-70f7-4eb7-ba8b-41580a17d9a6"),
                  elementType: PageBuilderWidgetType.container,
                  properties: PageBuilderContainerProperties(
                      borderRadius: 10, shadow: null),
                  hoverProperties: null,
                  children: null,
                  containerChild: PageBuilderWidget(
                      id: UniqueID.fromUniqueString(
                          "d10d39c1-70f7-4eb7-ba8b-41580a17d9a6"),
                      elementType: PageBuilderWidgetType.text,
                      properties: PageBuilderTextProperties(
                          text:
                              "Du wurdest positiv von Max Mustermann\nweiterempfohlen.\nMax möchte, dass wir uns kennenlernen.",
                          fontSize: 18,
                          fontFamily: "Merriweather",
                          lineHeight: null,
                          letterSpacing: null,
                          textShadow: null,
                          color: Color(0xFFFFFFFF),
                          alignment: TextAlign.left,
                          isBold: null,
                          isItalic: true),
                      hoverProperties: null,
                      children: null,
                      containerChild: null,
                      widthPercentage: null,
                      background: null,
                      hoverBackground: null,
                      padding: PageBuilderSpacing(
                          top: 20, bottom: 20, left: 20, right: 20),
                      margin: null,
                      maxWidth: null,
                      alignment: null),
                  widthPercentage: 50,
                  background: null,
                  hoverBackground: null,
                  padding:
                      PageBuilderSpacing(top: 0, bottom: 0, left: 0, right: 0),
                  margin: null,
                  maxWidth: null,
                  alignment: null)
            ],
            containerChild: null,
            widthPercentage: null,
            background: null,
            hoverBackground: null,
            padding:
                PageBuilderSpacing(top: 40, bottom: 20, left: 20, right: 20),
            margin: null,
            maxWidth: 950,
            alignment: null)
      ];
      final expectedResult = [
        {
          "id": "c558084f-fb4d-41ff-b320-b47596e24a0a",
          "elementType": "row",
          "padding": {"top": 40.0, "bottom": 20.0, "left": 20.0, "right": 20.0},
          "maxWidth": 950.0,
          "children": [
            {
              "id": "59473e09-b3f4-4662-ac92-e6c2828b9996",
              "elementType": "image",
              "widthPercentage": 50.0,
              "padding": {"right": 16.0},
              "properties": {
                "borderRadius": 100.0,
                "width": 200.0,
                "height": 200.0,
                "contentMode": "cover",
                "showPromoterImage": false,
                "url":
                    "https://firebasestorage.googleapis.com/v0/b/finanzwegbegleiter.appspot.com/o/landingPageContentImages%2FL9SPWUuY7mJKWUaX16Xt%2F4ce25fce-242b-471b-8a25-83e920e95e8d?alt=media&token=3c7bdc32-f607-4eee-923f-41410591d1d0"
              }
            },
            {
              "id": "660d39c1-70f7-4eb7-ba8b-41580a17d9a6",
              "elementType": "container",
              "widthPercentage": 50.0,
              "properties": {"borderRadius": 10.0},
              "containerChild": {
                "id": "d10d39c1-70f7-4eb7-ba8b-41580a17d9a6",
                "elementType": "text",
                "padding": {
                  "top": 20.0,
                  "right": 20.0,
                  "left": 20.0,
                  "bottom": 20.0
                },
                "properties": {
                  "alignment": "left",
                  "color": "FFFFFFFF",
                  "fontSize": 18.0,
                  "fontFamily": "Merriweather",
                  "isItalic": true,
                  "text":
                      "Du wurdest positiv von Max Mustermann\nweiterempfohlen.\nMax möchte, dass wir uns kennenlernen."
                }
              }
            }
          ]
        }
      ];
      // When
      final result =
          PageBuilderSectionModel.getMapFromPageBuilderWidgetList(widgets);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionModel_Props", () {
    test("check if value equality works", () {
      // Given
      final section1 = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          layout: PageBuilderSectionLayout.column,
          widgets: [],
          background: null,
          maxWidth: 800, backgroundConstrained: null);
      final section2 = PageBuilderSection(
          id: UniqueID.fromUniqueString("1"),
          layout: PageBuilderSectionLayout.column,
          widgets: [],
          background: null,
          maxWidth: 800, backgroundConstrained: null);
      // Then
      expect(section1, section2);
    });
  });
}
