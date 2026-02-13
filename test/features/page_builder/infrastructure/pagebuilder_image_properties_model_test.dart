import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_image_properties_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_image_properties.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_border.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PagebuilderImagePropertiesModel_CopyWith", () {
    test("set height with copyWith should set height for resulting object", () {
      // Given
      final model = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"},
          shadow: null);
      final expectedResult = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(400.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"},
          shadow: null);
      // When
      final result = model.copyWith(height: const PagebuilderResponsiveOrConstantModel.constant(400.0));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderImagePropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"},
          shadow: null);
      final expectedResult = {
        "url": "https://test.de",
        "border": {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
        "width": 300.0,
        "height": 300.0,
        "contentMode": "cover",
        "showPromoterImage": false,
        "newImageBase64": "image",
        "overlayPaint": {"color": "FF000000"}
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderImagePropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "url": "https://test.de",
        "border": {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
        "width": 300.0,
        "height": 300.0,
        "contentMode": "cover",
        "showPromoterImage": false,
        "newImageBase64": "image",
        "overlayPaint": {"color": "FF000000"}
      };
      final expectedResult = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"},
          shadow: null);
      // When
      final result = PageBuilderImagePropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderImagePropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderImagePropertiesModel to PagebuilderImageProperties works",
        () {
      // Given
      final model = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"},
          shadow: null);
      final expectedResult = PageBuilderImageProperties(
          url: "https://test.de",
          border: PagebuilderBorder(radius: 12.0, width: 2.0, color: Color(0xFFFF6B00)),
          width: const PagebuilderResponsiveOrConstant.constant(300.0),
          height: const PagebuilderResponsiveOrConstant.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          showPromoterImage: false,
          overlayPaint: const PagebuilderPaint.color(Colors.black),
          shadow: null);
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderImagePropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderImageProperties to PagebuilderImagePropertiesModel works",
        () {
      // Given
      final model = PageBuilderImageProperties(
          url: "https://test.de",
          border: PagebuilderBorder(radius: 12.0, width: 2.0, color: Color(0xFFFF6B00)),
          width: const PagebuilderResponsiveOrConstant.constant(300.0),
          height: const PagebuilderResponsiveOrConstant.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          showPromoterImage: false,
          overlayPaint: const PagebuilderPaint.color(Colors.black),
          shadow: null);
      final expectedResult = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: null,
          overlayPaint: {"color": "FF000000"},
          shadow: null);
      // When
      final result = PageBuilderImagePropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderImagePropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: null,
          overlayPaint: {"color": "FF000000"},
          shadow: null);
      final properties2 = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          border: {"radius": 12.0, "width": 2.0, "color": "FFFF6B00"},
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: null,
          overlayPaint: {"color": "FF000000"},
          shadow: null);
      // Then
      expect(properties1, properties2);
    });
  });
}
