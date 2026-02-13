import 'dart:typed_data';

import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_asset_replacement.dart';
import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_edit.dart';
import 'package:finanzbegleiter/features/admin/infrastructure/pagebuilder_section_template_asset_replacement_model.dart';
import 'package:finanzbegleiter/features/admin/infrastructure/pagebuilder_section_template_edit_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("PagebuilderSectionTemplateEditModel_FromDomain", () {
    test("should convert domain entity to model with required fields only", () {
      // Given
      final domainEntity = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
      );
      final expectedModel = PagebuilderSectionTemplateEditModel(
        templateId: "test-template-id",
        environment: "both",
      );

      // When
      final result =
          PagebuilderSectionTemplateEditModel.fromDomain(domainEntity);

      // Then
      expect(result, expectedModel);
    });

    test("should convert domain entity to model with all fields", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3]);
      final thumbnailData = Uint8List.fromList([4, 5, 6]);
      final replacementAssetData = Uint8List.fromList([7, 8, 9]);
      final newAssetData = Uint8List.fromList([10, 11, 12]);

      final domainEntity = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "staging",
        jsonData: jsonData,
        thumbnailData: thumbnailData,
        deletedAssetUrls: ["https://example.com/deleted.webp"],
        replacements: [
          PagebuilderSectionTemplateAssetReplacement(
            oldUrl: "https://example.com/old.webp",
            newAssetData: replacementAssetData,
          ),
        ],
        newAssetDataList: [newAssetData],
        type: "hero",
      );

      final expectedModel = PagebuilderSectionTemplateEditModel(
        templateId: "test-template-id",
        environment: "staging",
        jsonData: jsonData,
        thumbnailData: thumbnailData,
        deletedAssetUrls: ["https://example.com/deleted.webp"],
        replacements: [
          PagebuilderSectionTemplateAssetReplacementModel(
            oldUrl: "https://example.com/old.webp",
            newAssetData: replacementAssetData,
          ),
        ],
        newAssetDataList: [newAssetData],
        type: "hero",
      );

      // When
      final result =
          PagebuilderSectionTemplateEditModel.fromDomain(domainEntity);

      // Then
      expect(result, expectedModel);
    });

    test("should convert replacements correctly", () {
      // Given
      final assetData1 = Uint8List.fromList([1, 2, 3]);
      final assetData2 = Uint8List.fromList([4, 5, 6]);

      final domainEntity = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
        replacements: [
          PagebuilderSectionTemplateAssetReplacement(
            oldUrl: "https://example.com/old1.webp",
            newAssetData: assetData1,
          ),
          PagebuilderSectionTemplateAssetReplacement(
            oldUrl: "https://example.com/old2.webp",
            newAssetData: assetData2,
          ),
        ],
      );

      // When
      final result =
          PagebuilderSectionTemplateEditModel.fromDomain(domainEntity);

      // Then
      expect(result.replacements.length, 2);
      expect(result.replacements[0].oldUrl, "https://example.com/old1.webp");
      expect(result.replacements[1].oldUrl, "https://example.com/old2.webp");
    });
  });

  group("PagebuilderSectionTemplateEditModel_ToMap", () {
    test("should convert model to map with required fields only", () {
      // Given
      final model = PagebuilderSectionTemplateEditModel(
        templateId: "test-template-id",
        environment: "both",
      );
      final expectedMap = {
        'templateId': "test-template-id",
        'deletedAssetUrls': <String>[],
        'replacements': <Map<String, dynamic>>[],
        'newAssetDataList': <Uint8List>[],
        'environment': "both",
      };

      // When
      final result = model.toMap();

      // Then
      expect(result, expectedMap);
    });

    test("should convert model to map with all fields", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3]);
      final thumbnailData = Uint8List.fromList([4, 5, 6]);
      final replacementAssetData = Uint8List.fromList([7, 8, 9]);
      final newAssetData = Uint8List.fromList([10, 11, 12]);

      final model = PagebuilderSectionTemplateEditModel(
        templateId: "test-template-id",
        environment: "staging",
        jsonData: jsonData,
        thumbnailData: thumbnailData,
        deletedAssetUrls: ["https://example.com/deleted.webp"],
        replacements: [
          PagebuilderSectionTemplateAssetReplacementModel(
            oldUrl: "https://example.com/old.webp",
            newAssetData: replacementAssetData,
          ),
        ],
        newAssetDataList: [newAssetData],
        type: "hero",
      );

      // When
      final result = model.toMap();

      // Then
      expect(result['templateId'], "test-template-id");
      expect(result['environment'], "staging");
      expect(result['jsonData'], jsonData);
      expect(result['thumbnailData'], thumbnailData);
      expect(result['deletedAssetUrls'], ["https://example.com/deleted.webp"]);
      expect(result['newAssetDataList'], [newAssetData]);
      expect(result['type'], "hero");
      expect(result['replacements'], isA<List>());
      expect((result['replacements'] as List).length, 1);
    });

    test("should not include null optional fields in map", () {
      // Given
      final model = PagebuilderSectionTemplateEditModel(
        templateId: "test-template-id",
        environment: "both",
      );

      // When
      final result = model.toMap();

      // Then
      expect(result.containsKey('jsonData'), isFalse);
      expect(result.containsKey('thumbnailData'), isFalse);
      expect(result.containsKey('type'), isFalse);
    });

    test("should include optional fields when they are set", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3]);
      final model = PagebuilderSectionTemplateEditModel(
        templateId: "test-template-id",
        environment: "both",
        jsonData: jsonData,
        type: "about",
      );

      // When
      final result = model.toMap();

      // Then
      expect(result.containsKey('jsonData'), isTrue);
      expect(result.containsKey('type'), isTrue);
      expect(result['jsonData'], jsonData);
      expect(result['type'], "about");
    });
  });

  group("PagebuilderSectionTemplateEditModel_Props", () {
    test("check if value equality works for identical objects", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3]);
      final model1 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id",
        environment: "both",
        jsonData: jsonData,
        type: "hero",
      );
      final model2 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id",
        environment: "both",
        jsonData: jsonData,
        type: "hero",
      );

      // Then
      expect(model1, model2);
    });

    test("check if value inequality works for different templateIds", () {
      // Given
      final model1 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id-1",
        environment: "both",
      );
      final model2 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id-2",
        environment: "both",
      );

      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value inequality works for different environments", () {
      // Given
      final model1 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id",
        environment: "staging",
      );
      final model2 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id",
        environment: "prod",
      );

      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value inequality works for different types", () {
      // Given
      final model1 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id",
        environment: "both",
        type: "hero",
      );
      final model2 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id",
        environment: "both",
        type: "about",
      );

      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value inequality works for different deletedAssetUrls", () {
      // Given
      final model1 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id",
        environment: "both",
        deletedAssetUrls: ["https://example.com/url1.webp"],
      );
      final model2 = PagebuilderSectionTemplateEditModel(
        templateId: "test-id",
        environment: "both",
        deletedAssetUrls: ["https://example.com/url2.webp"],
      );

      // Then
      expect(model1, isNot(equals(model2)));
    });
  });
}
