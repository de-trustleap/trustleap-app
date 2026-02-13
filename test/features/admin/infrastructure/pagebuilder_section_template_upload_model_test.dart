import "dart:typed_data";

import "package:flutter_test/flutter_test.dart";
import "package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_upload.dart";
import "package:finanzbegleiter/features/admin/infrastructure/pagebuilder_section_template_upload_model.dart";

void main() {
  group("PagebuilderSectionTemplateUploadModel_FromDomain", () {
    test("check if conversion from entity to model works", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);
      final assetData1 = Uint8List.fromList([9, 10, 11, 12]);
      final assetData2 = Uint8List.fromList([13, 14, 15, 16]);

      final entity = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [assetData1, assetData2],
        assetFileNames: ["asset1.png", "asset2.png"],
        environment: "staging",
        type: "hero",
      );

      final expectedModel = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [assetData1, assetData2],
        assetFileNames: ["asset1.png", "asset2.png"],
        environment: "staging",
        type: "hero",
      );

      // When
      final result = PagebuilderSectionTemplateUploadModel.fromDomain(entity);

      // Then
      expect(result, expectedModel);
    });

    test("should handle empty asset lists", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final entity = PagebuilderSectionTemplateUpload(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "prod",
        type: "about",
      );

      final expectedModel = PagebuilderSectionTemplateUploadModel(
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
      final result = PagebuilderSectionTemplateUploadModel.fromDomain(entity);

      // Then
      expect(result, expectedModel);
    });

    test("should handle all environment types", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final environments = ["staging", "prod", "both"];

      for (var env in environments) {
        final entity = PagebuilderSectionTemplateUpload(
          jsonData: jsonData,
          jsonFileName: "test.json",
          thumbnailData: thumbnailData,
          thumbnailFileName: "thumbnail.png",
          assetDataList: [],
          assetFileNames: [],
          environment: env,
          type: "hero",
        );

        // When
        final result =
            PagebuilderSectionTemplateUploadModel.fromDomain(entity);

        // Then
        expect(result.environment, env);
      }
    });

    test("should handle all section types", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final types = [
        "hero",
        "about",
        "product",
        "callToAction",
        "advantages",
        "footer"
      ];

      for (var type in types) {
        final entity = PagebuilderSectionTemplateUpload(
          jsonData: jsonData,
          jsonFileName: "test.json",
          thumbnailData: thumbnailData,
          thumbnailFileName: "thumbnail.png",
          assetDataList: [],
          assetFileNames: [],
          environment: "staging",
          type: type,
        );

        // When
        final result =
            PagebuilderSectionTemplateUploadModel.fromDomain(entity);

        // Then
        expect(result.type, type);
      }
    });
  });

  group("PagebuilderSectionTemplateUploadModel_CopyWith", () {
    test("should create a copy with updated type", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final original = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      // When
      final result = original.copyWith(type: "product");

      // Then
      expect(result.type, "product");
      expect(result.jsonFileName, "test.json");
      expect(result.environment, "staging");
    });

    test("should create a copy with updated environment", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final original = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      // When
      final result = original.copyWith(environment: "prod");

      // Then
      expect(result.environment, "prod");
      expect(result.type, "hero");
    });

    test("should keep original values when no parameters provided", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);
      final assetData = Uint8List.fromList([9, 10, 11, 12]);

      final original = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [assetData],
        assetFileNames: ["asset1.png"],
        environment: "staging",
        type: "hero",
      );

      // When
      final result = original.copyWith();

      // Then
      expect(result, original);
    });
  });

  group("PagebuilderSectionTemplateUploadModel_Props", () {
    test("check if value equality works", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);
      final assetData = Uint8List.fromList([9, 10, 11, 12]);

      final model1 = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [assetData],
        assetFileNames: ["asset1.png"],
        environment: "staging",
        type: "hero",
      );

      final model2 = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [assetData],
        assetFileNames: ["asset1.png"],
        environment: "staging",
        type: "hero",
      );

      // Then
      expect(model1, model2);
    });

    test("check if value inequality works with different type", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final model1 = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final model2 = PagebuilderSectionTemplateUploadModel(
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
      expect(model1 == model2, false);
    });

    test("check if value inequality works with different environment", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final model1 = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final model2 = PagebuilderSectionTemplateUploadModel(
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
      expect(model1 == model2, false);
    });

    test("check if value inequality works with different jsonFileName", () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final model1 = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test1.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final model2 = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test2.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      // Then
      expect(model1 == model2, false);
    });

    test("check if value inequality works with different thumbnailFileName",
        () {
      // Given
      final jsonData = Uint8List.fromList([1, 2, 3, 4]);
      final thumbnailData = Uint8List.fromList([5, 6, 7, 8]);

      final model1 = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail1.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      final model2 = PagebuilderSectionTemplateUploadModel(
        jsonData: jsonData,
        jsonFileName: "test.json",
        thumbnailData: thumbnailData,
        thumbnailFileName: "thumbnail2.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "hero",
      );

      // Then
      expect(model1 == model2, false);
    });
  });
}
