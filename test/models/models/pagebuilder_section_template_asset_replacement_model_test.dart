import 'dart:typed_data';

import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_asset_replacement.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder_section_template_asset_replacement_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("PagebuilderSectionTemplateAssetReplacementModel_FromDomain", () {
    test("should convert domain entity to model correctly", () {
      // Given
      final assetData = Uint8List.fromList([1, 2, 3, 4, 5]);
      final domainEntity = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: assetData,
      );
      final expectedModel = PagebuilderSectionTemplateAssetReplacementModel(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: assetData,
      );

      // When
      final result =
          PagebuilderSectionTemplateAssetReplacementModel.fromDomain(
              domainEntity);

      // Then
      expect(result, expectedModel);
    });
  });

  group("PagebuilderSectionTemplateAssetReplacementModel_ToMap", () {
    test("should convert model to map correctly", () {
      // Given
      final assetData = Uint8List.fromList([1, 2, 3, 4, 5]);
      final model = PagebuilderSectionTemplateAssetReplacementModel(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: assetData,
      );
      final expectedMap = {
        'oldUrl': "https://example.com/old-image.webp",
        'newAssetBase64': assetData,
      };

      // When
      final result = model.toMap();

      // Then
      expect(result, expectedMap);
    });
  });

  group("PagebuilderSectionTemplateAssetReplacementModel_Props", () {
    test("check if value equality works for identical objects", () {
      // Given
      final assetData = Uint8List.fromList([1, 2, 3, 4, 5]);
      final model1 = PagebuilderSectionTemplateAssetReplacementModel(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: assetData,
      );
      final model2 = PagebuilderSectionTemplateAssetReplacementModel(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: assetData,
      );

      // Then
      expect(model1, model2);
    });

    test("check if value inequality works for different oldUrls", () {
      // Given
      final assetData = Uint8List.fromList([1, 2, 3, 4, 5]);
      final model1 = PagebuilderSectionTemplateAssetReplacementModel(
        oldUrl: "https://example.com/old-image1.webp",
        newAssetData: assetData,
      );
      final model2 = PagebuilderSectionTemplateAssetReplacementModel(
        oldUrl: "https://example.com/old-image2.webp",
        newAssetData: assetData,
      );

      // Then
      expect(model1, isNot(equals(model2)));
    });
  });
}
