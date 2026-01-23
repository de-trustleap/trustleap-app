import 'dart:typed_data';

import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_asset_replacement.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_edit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("PagebuilderSectionTemplateEdit_Constructor", () {
    test("should create instance with required fields only", () {
      // Given
      const templateId = "test-template-id";
      const environment = "both";

      // When
      final edit = PagebuilderSectionTemplateEdit(
        templateId: templateId,
        environment: environment,
      );

      // Then
      expect(edit.templateId, templateId);
      expect(edit.environment, environment);
      expect(edit.jsonData, isNull);
      expect(edit.thumbnailData, isNull);
      expect(edit.deletedAssetUrls, isEmpty);
      expect(edit.replacements, isEmpty);
      expect(edit.newAssetDataList, isEmpty);
      expect(edit.type, isNull);
    });

    test("should create instance with all fields", () {
      // Given
      const templateId = "test-template-id";
      const environment = "staging";
      final jsonData = Uint8List.fromList([1, 2, 3]);
      final thumbnailData = Uint8List.fromList([4, 5, 6]);
      final deletedAssetUrls = ["https://example.com/deleted.webp"];
      final replacement = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old.webp",
        newAssetData: Uint8List.fromList([7, 8, 9]),
      );
      final newAssetDataList = [Uint8List.fromList([10, 11, 12])];
      const type = "hero";

      // When
      final edit = PagebuilderSectionTemplateEdit(
        templateId: templateId,
        environment: environment,
        jsonData: jsonData,
        thumbnailData: thumbnailData,
        deletedAssetUrls: deletedAssetUrls,
        replacements: [replacement],
        newAssetDataList: newAssetDataList,
        type: type,
      );

      // Then
      expect(edit.templateId, templateId);
      expect(edit.environment, environment);
      expect(edit.jsonData, jsonData);
      expect(edit.thumbnailData, thumbnailData);
      expect(edit.deletedAssetUrls, deletedAssetUrls);
      expect(edit.replacements, [replacement]);
      expect(edit.newAssetDataList, newAssetDataList);
      expect(edit.type, type);
    });
  });

  group("PagebuilderSectionTemplateEdit_CopyWith", () {
    test("should copy with new templateId", () {
      // Given
      final original = PagebuilderSectionTemplateEdit(
        templateId: "original-id",
        environment: "both",
      );

      // When
      final result = original.copyWith(templateId: "new-id");

      // Then
      expect(result.templateId, "new-id");
      expect(result.environment, "both");
    });

    test("should copy with new environment", () {
      // Given
      final original = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
      );

      // When
      final result = original.copyWith(environment: "staging");

      // Then
      expect(result.templateId, "test-id");
      expect(result.environment, "staging");
    });

    test("should copy with new jsonData", () {
      // Given
      final original = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
      );
      final newJsonData = Uint8List.fromList([1, 2, 3]);

      // When
      final result = original.copyWith(jsonData: newJsonData);

      // Then
      expect(result.jsonData, newJsonData);
    });

    test("should copy with new thumbnailData", () {
      // Given
      final original = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
      );
      final newThumbnailData = Uint8List.fromList([4, 5, 6]);

      // When
      final result = original.copyWith(thumbnailData: newThumbnailData);

      // Then
      expect(result.thumbnailData, newThumbnailData);
    });

    test("should copy with new deletedAssetUrls", () {
      // Given
      final original = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
        deletedAssetUrls: ["https://example.com/old.webp"],
      );

      // When
      final result = original.copyWith(
        deletedAssetUrls: ["https://example.com/new-deleted.webp"],
      );

      // Then
      expect(result.deletedAssetUrls, ["https://example.com/new-deleted.webp"]);
    });

    test("should copy with new replacements", () {
      // Given
      final original = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
      );
      final newReplacement = PagebuilderSectionTemplateAssetReplacement(
        oldUrl: "https://example.com/old.webp",
        newAssetData: Uint8List.fromList([1, 2, 3]),
      );

      // When
      final result = original.copyWith(replacements: [newReplacement]);

      // Then
      expect(result.replacements, [newReplacement]);
    });

    test("should copy with new newAssetDataList", () {
      // Given
      final original = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
      );
      final newAssetData = Uint8List.fromList([7, 8, 9]);

      // When
      final result = original.copyWith(newAssetDataList: [newAssetData]);

      // Then
      expect(result.newAssetDataList, [newAssetData]);
    });

    test("should copy with new type", () {
      // Given
      final original = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
        type: "hero",
      );

      // When
      final result = original.copyWith(type: "about");

      // Then
      expect(result.type, "about");
    });

    test("should preserve all fields when copying with single field", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3]);
      final thumbnailData = Uint8List.fromList([4, 5, 6]);
      final original = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
        jsonData: jsonData,
        thumbnailData: thumbnailData,
        deletedAssetUrls: ["https://example.com/deleted.webp"],
        type: "hero",
      );

      // When
      final result = original.copyWith(environment: "prod");

      // Then
      expect(result.templateId, "test-id");
      expect(result.environment, "prod");
      expect(result.jsonData, jsonData);
      expect(result.thumbnailData, thumbnailData);
      expect(result.deletedAssetUrls, ["https://example.com/deleted.webp"]);
      expect(result.type, "hero");
    });
  });

  group("PagebuilderSectionTemplateEdit_Props", () {
    test("check if value equality works for identical objects", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3]);
      final edit1 = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
        jsonData: jsonData,
        type: "hero",
      );
      final edit2 = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
        jsonData: jsonData,
        type: "hero",
      );

      // Then
      expect(edit1, edit2);
    });

    test("check if value inequality works for different templateIds", () {
      // Given
      final edit1 = PagebuilderSectionTemplateEdit(
        templateId: "test-id-1",
        environment: "both",
      );
      final edit2 = PagebuilderSectionTemplateEdit(
        templateId: "test-id-2",
        environment: "both",
      );

      // Then
      expect(edit1, isNot(equals(edit2)));
    });

    test("check if value inequality works for different environments", () {
      // Given
      final edit1 = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "staging",
      );
      final edit2 = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "prod",
      );

      // Then
      expect(edit1, isNot(equals(edit2)));
    });

    test("check if value inequality works for different types", () {
      // Given
      final edit1 = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
        type: "hero",
      );
      final edit2 = PagebuilderSectionTemplateEdit(
        templateId: "test-id",
        environment: "both",
        type: "about",
      );

      // Then
      expect(edit1, isNot(equals(edit2)));
    });
  });
}
