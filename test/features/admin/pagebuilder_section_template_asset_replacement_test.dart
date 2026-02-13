import 'dart:typed_data';

import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_asset_replacement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("PagebuilderSectionTemplateAssetReplacement_Props", () {
    test("check if value equality works for identical objects", () {
      // Given
      final assetData = Uint8List.fromList([1, 2, 3, 4, 5]);
      final replacement1 = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: assetData,
      );
      final replacement2 = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: assetData,
      );
      // Then
      expect(replacement1, replacement2);
    });

    test("check if value inequality works for different oldUrls", () {
      // Given
      final assetData = Uint8List.fromList([1, 2, 3, 4, 5]);
      final replacement1 = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old-image1.webp",
        newAssetData: assetData,
      );
      final replacement2 = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old-image2.webp",
        newAssetData: assetData,
      );
      // Then
      expect(replacement1, isNot(equals(replacement2)));
    });

    test("check if value inequality works for different newAssetData", () {
      // Given
      final replacement1 = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: Uint8List.fromList([1, 2, 3]),
      );
      final replacement2 = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old-image.webp",
        newAssetData: Uint8List.fromList([4, 5, 6]),
      );
      // Then
      expect(replacement1, isNot(equals(replacement2)));
    });
  });

  group("PagebuilderSectionTemplateAssetReplacement_Constructor", () {
    test("should create instance with required fields", () {
      // Given
      final assetData = Uint8List.fromList([1, 2, 3, 4, 5]);
      const oldUrl = "https://example.com/old-image.webp";

      // When
      final replacement = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: oldUrl,
        newAssetData: assetData,
      );

      // Then
      expect(replacement.oldUrl, oldUrl);
      expect(replacement.newAssetData, assetData);
    });
  });
}
