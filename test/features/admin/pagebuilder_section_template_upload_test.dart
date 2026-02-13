import "dart:typed_data";

import "package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_upload.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("PagebuilderSectionTemplateUpload_CopyWith", () {
    test("set type with copyWith should set type for resulting object", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final upload = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final expectedResult = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "product",
      );

      // When
      final result = upload.copyWith(type: "product");

      // Then
      expect(expectedResult, result);
    });

    test(
        "set environment and type with copyWith should set fields for resulting object",
        () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final upload = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final expectedResult = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "prod",
        type: "about",
      );

      // When
      final result = upload.copyWith(environment: "prod", type: "about");

      // Then
      expect(expectedResult, result);
    });

    test("set jsonFileName with copyWith should set jsonFileName for resulting object",
        () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final upload = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final expectedResult = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "updated.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      // When
      final result = upload.copyWith(jsonFileName: "updated.json");

      // Then
      expect(expectedResult, result);
    });

    test(
        "set thumbnailFileName with copyWith should set thumbnailFileName for resulting object",
        () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final upload = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final expectedResult = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "new-thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      // When
      final result = upload.copyWith(thumbnailFileName: "new-thumbnail.png");

      // Then
      expect(expectedResult, result);
    });

    test(
        "set assetFileNames with copyWith should set assetFileNames for resulting object",
        () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final upload = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final expectedResult = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: ["asset1.png", "asset2.png"],
        environment: "staging",
        type: "hero",
      );

      // When
      final result =
          upload.copyWith(assetFileNames: ["asset1.png", "asset2.png"]);

      // Then
      expect(expectedResult, result);
    });
  });

  group("PagebuilderSectionTemplateUpload_Equality", () {
    test("check if value equality works", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final upload1 = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final upload2 = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      // Then
      expect(upload1, upload2);
    });

    test("check if value inequality works with different type", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final upload1 = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final upload2 = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "product",
      );

      // Then
      expect(upload1 == upload2, false);
    });

    test("check if value inequality works with different environment", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final upload1 = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final upload2 = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "prod",
        type: "hero",
      );

      // Then
      expect(upload1 == upload2, false);
    });
  });
}
