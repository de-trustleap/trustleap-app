import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_image_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PagebuilderImagePropertiesModel_CopyWith", () {
    test("set height with copyWith should set height for resulting object", () {
      // Given
      final model = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"});
      final expectedResult = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(400.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"});
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
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"});
      final expectedResult = {
        "url": "https://test.de",
        "borderRadius": 12.0,
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
        "borderRadius": 12.0,
        "width": 300.0,
        "height": 300.0,
        "contentMode": "cover",
        "showPromoterImage": false,
        "newImageBase64": "image",
        "overlayPaint": {"color": "FF000000"}
      };
      final expectedResult = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"});
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
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: "image",
          overlayPaint: {"color": "FF000000"});
      final expectedResult = PageBuilderImageProperties(
          url: "https://test.de",
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstant.constant(300.0),
          height: const PagebuilderResponsiveOrConstant.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          showPromoterImage: false,
          overlayPaint: const PagebuilderPaint.color(Colors.black));
      // When
      final result = model.toDomain();
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
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstant.constant(300.0),
          height: const PagebuilderResponsiveOrConstant.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          showPromoterImage: false,
          overlayPaint: const PagebuilderPaint.color(Colors.black));
      final expectedResult = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: null,
          overlayPaint: {"color": "FF000000"});
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
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: null,
          overlayPaint: {"color": "FF000000"});
      final properties2 = PageBuilderImagePropertiesModel(
          url: "https://test.de",
          borderRadius: 12.0,
          width: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(300.0),
          contentMode: const PagebuilderResponsiveOrConstantModel.constant("cover"),
          showPromoterImage: false,
          newImageBase64: null,
          overlayPaint: {"color": "FF000000"});
      // Then
      expect(properties1, properties2);
    });
  });
}
