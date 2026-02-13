// ignore_for_file: type=lint
import "dart:typed_data";

import "package:dartz/dartz.dart";
import "package:finanzbegleiter/core/failures/database_failures.dart";
import "package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_asset_replacement.dart";
import "package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_edit.dart";
import "package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_upload.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../mocks.mocks.dart";

void main() {
  late MockPagebuilderSectionTemplateUploadRepository mockRepo;

  setUp(() {
    mockRepo = MockPagebuilderSectionTemplateUploadRepository();
  });

  group("PagebuilderSectionTemplateUploadRepository_UploadTemplate", () {
    final testTemplate = PagebuilderSectionTemplateUpload(
      jsonData: Uint8List.fromList([1, 2, 3, 4]),
      jsonFileName: "test-section.json",
      thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
      thumbnailFileName: "thumbnail.png",
      assetDataList: [
        Uint8List.fromList([9, 10, 11, 12]),
        Uint8List.fromList([13, 14, 15, 16]),
      ],
      assetFileNames: ["asset1.png", "asset2.png"],
      environment: "staging",
      type: "hero",
    );

    test("should return unit when template has been uploaded successfully",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.uploadTemplate(testTemplate);

      // Then
      verify(mockRepo.uploadTemplate(testTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return unit when template has been uploaded without assets",
        () async {
      // Given
      final templateWithoutAssets = PagebuilderSectionTemplateUpload(
        jsonData: Uint8List.fromList([1, 2, 3, 4]),
        jsonFileName: "test-section.json",
        thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "about",
      );
      final expectedResult = right(unit);
      when(mockRepo.uploadTemplate(templateWithoutAssets))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.uploadTemplate(templateWithoutAssets);

      // Then
      verify(mockRepo.uploadTemplate(templateWithoutAssets));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should return PermissionDeniedFailure when call has failed with permission denied",
        () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // When
      final result = await mockRepo.uploadTemplate(testTemplate);

      // Then
      verify(mockRepo.uploadTemplate(testTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return BackendFailure when call has failed with backend error",
        () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => left(BackendFailure()));

      // When
      final result = await mockRepo.uploadTemplate(testTemplate);

      // Then
      verify(mockRepo.uploadTemplate(testTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should return UnavailableFailure when call has failed with service unavailable error",
        () async {
      // Given
      final expectedResult = left(UnavailableFailure());
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => left(UnavailableFailure()));

      // When
      final result = await mockRepo.uploadTemplate(testTemplate);

      // Then
      verify(mockRepo.uploadTemplate(testTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle template upload to production environment", () async {
      // Given
      final prodTemplate = PagebuilderSectionTemplateUpload(
        jsonData: Uint8List.fromList([1, 2, 3, 4]),
        jsonFileName: "prod-section.json",
        thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "prod",
        type: "product",
      );
      final expectedResult = right(unit);
      when(mockRepo.uploadTemplate(prodTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.uploadTemplate(prodTemplate);

      // Then
      verify(mockRepo.uploadTemplate(prodTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle template upload to both environments", () async {
      // Given
      final bothTemplate = PagebuilderSectionTemplateUpload(
        jsonData: Uint8List.fromList([1, 2, 3, 4]),
        jsonFileName: "both-section.json",
        thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "both",
        type: "callToAction",
      );
      final expectedResult = right(unit);
      when(mockRepo.uploadTemplate(bothTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.uploadTemplate(bothTemplate);

      // Then
      verify(mockRepo.uploadTemplate(bothTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle all section types correctly", () async {
      // Given
      final types = [
        "hero",
        "about",
        "product",
        "callToAction",
        "advantages",
        "footer"
      ];

      for (var type in types) {
        final template = PagebuilderSectionTemplateUpload(
          jsonData: Uint8List.fromList([1, 2, 3, 4]),
          jsonFileName: "$type-section.json",
          thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
          thumbnailFileName: "thumbnail.png",
          assetDataList: [],
          assetFileNames: [],
          environment: "staging",
          type: type,
        );

        when(mockRepo.uploadTemplate(template))
            .thenAnswer((_) async => right(unit));

        // When
        final result = await mockRepo.uploadTemplate(template);

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail("Should not return failure"),
          (value) => expect(value, unit),
        );
      }

      verify(mockRepo.uploadTemplate(any)).called(types.length);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle template with multiple assets correctly", () async {
      // Given
      final multipleAssetsTemplate = PagebuilderSectionTemplateUpload(
        jsonData: Uint8List.fromList([1, 2, 3, 4]),
        jsonFileName: "multi-asset-section.json",
        thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
        thumbnailFileName: "thumbnail.png",
        assetDataList: [
          Uint8List.fromList([9, 10, 11, 12]),
          Uint8List.fromList([13, 14, 15, 16]),
          Uint8List.fromList([17, 18, 19, 20]),
        ],
        assetFileNames: ["asset1.png", "asset2.png", "asset3.png"],
        environment: "staging",
        type: "advantages",
      );
      final expectedResult = right(unit);
      when(mockRepo.uploadTemplate(multipleAssetsTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.uploadTemplate(multipleAssetsTemplate);

      // Then
      verify(mockRepo.uploadTemplate(multipleAssetsTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle large JSON data correctly", () async {
      // Given
      final largeJsonData = Uint8List.fromList(List.generate(10000, (i) => i % 256));
      final largeTemplate = PagebuilderSectionTemplateUpload(
        jsonData: largeJsonData,
        jsonFileName: "large-section.json",
        thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
        thumbnailFileName: "thumbnail.png",
        assetDataList: [],
        assetFileNames: [],
        environment: "staging",
        type: "footer",
      );
      final expectedResult = right(unit);
      when(mockRepo.uploadTemplate(largeTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.uploadTemplate(largeTemplate);

      // Then
      verify(mockRepo.uploadTemplate(largeTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });
  });

  group("PagebuilderSectionTemplateUploadRepository_EditTemplate", () {
    final testEditTemplate = PagebuilderSectionTemplateEdit(
      templateId: "test-template-id",
      environment: "both",
      jsonData: Uint8List.fromList([1, 2, 3, 4]),
      thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
      type: "hero",
    );

    test("should return unit when template has been edited successfully",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(testEditTemplate);

      // Then
      verify(mockRepo.editTemplate(testEditTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return unit when editing with only required fields", () async {
      // Given
      final minimalEditTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "staging",
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(minimalEditTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(minimalEditTemplate);

      // Then
      verify(mockRepo.editTemplate(minimalEditTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return unit when editing with new json data only", () async {
      // Given
      final jsonOnlyTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
        jsonData: Uint8List.fromList([1, 2, 3, 4, 5]),
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(jsonOnlyTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(jsonOnlyTemplate);

      // Then
      verify(mockRepo.editTemplate(jsonOnlyTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return unit when editing with new thumbnail only", () async {
      // Given
      final thumbnailOnlyTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
        thumbnailData: Uint8List.fromList([9, 10, 11, 12]),
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(thumbnailOnlyTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(thumbnailOnlyTemplate);

      // Then
      verify(mockRepo.editTemplate(thumbnailOnlyTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return unit when editing with deleted asset urls", () async {
      // Given
      final deleteAssetsTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
        deletedAssetUrls: [
          "https://example.com/asset1.webp",
          "https://example.com/asset2.webp",
        ],
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(deleteAssetsTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(deleteAssetsTemplate);

      // Then
      verify(mockRepo.editTemplate(deleteAssetsTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return unit when editing with asset replacements", () async {
      // Given
      final replacementsTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
        replacements: [
          PagebuilderSectionTemplateAssetReplacement(
            oldUrl: "https://example.com/old-asset.webp",
            newAssetData: Uint8List.fromList([1, 2, 3]),
          ),
        ],
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(replacementsTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(replacementsTemplate);

      // Then
      verify(mockRepo.editTemplate(replacementsTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return unit when editing with new assets", () async {
      // Given
      final newAssetsTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
        newAssetDataList: [
          Uint8List.fromList([1, 2, 3]),
          Uint8List.fromList([4, 5, 6]),
        ],
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(newAssetsTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(newAssetsTemplate);

      // Then
      verify(mockRepo.editTemplate(newAssetsTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should return BackendFailure when call has failed with backend error",
        () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => left(BackendFailure()));

      // When
      final result = await mockRepo.editTemplate(testEditTemplate);

      // Then
      verify(mockRepo.editTemplate(testEditTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should return PermissionDeniedFailure when call has failed with permission denied",
        () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // When
      final result = await mockRepo.editTemplate(testEditTemplate);

      // Then
      verify(mockRepo.editTemplate(testEditTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should return UnavailableFailure when call has failed with service unavailable error",
        () async {
      // Given
      final expectedResult = left(UnavailableFailure());
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => left(UnavailableFailure()));

      // When
      final result = await mockRepo.editTemplate(testEditTemplate);

      // Then
      verify(mockRepo.editTemplate(testEditTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return NotFoundFailure when template does not exist",
        () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => left(NotFoundFailure()));

      // When
      final result = await mockRepo.editTemplate(testEditTemplate);

      // Then
      verify(mockRepo.editTemplate(testEditTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle different environments correctly", () async {
      // Given
      final stagingTemplate =
          testEditTemplate.copyWith(environment: "staging");
      final prodTemplate = testEditTemplate.copyWith(environment: "prod");
      final bothTemplate = testEditTemplate.copyWith(environment: "both");

      when(mockRepo.editTemplate(stagingTemplate))
          .thenAnswer((_) async => right(unit));
      when(mockRepo.editTemplate(prodTemplate))
          .thenAnswer((_) async => right(unit));
      when(mockRepo.editTemplate(bothTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final stagingResult = await mockRepo.editTemplate(stagingTemplate);
      final prodResult = await mockRepo.editTemplate(prodTemplate);
      final bothResult = await mockRepo.editTemplate(bothTemplate);

      // Then
      expect(stagingResult, right(unit));
      expect(prodResult, right(unit));
      expect(bothResult, right(unit));
    });

    test("should handle type change correctly", () async {
      // Given
      final typeChangeTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
        type: "about",
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(typeChangeTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(typeChangeTemplate);

      // Then
      verify(mockRepo.editTemplate(typeChangeTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle full edit with all fields correctly", () async {
      // Given
      final fullEditTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
        jsonData: Uint8List.fromList([1, 2, 3]),
        thumbnailData: Uint8List.fromList([4, 5, 6]),
        deletedAssetUrls: ["https://example.com/old.webp"],
        replacements: [
          PagebuilderSectionTemplateAssetReplacement(
            oldUrl: "https://example.com/replace.webp",
            newAssetData: Uint8List.fromList([7, 8, 9]),
          ),
        ],
        newAssetDataList: [Uint8List.fromList([10, 11, 12])],
        type: "hero",
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(fullEditTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(fullEditTemplate);

      // Then
      verify(mockRepo.editTemplate(fullEditTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle multiple asset replacements correctly", () async {
      // Given
      final multiReplacementsTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
        replacements: [
          PagebuilderSectionTemplateAssetReplacement(
            oldUrl: "https://example.com/old1.webp",
            newAssetData: Uint8List.fromList([1, 2, 3]),
          ),
          PagebuilderSectionTemplateAssetReplacement(
            oldUrl: "https://example.com/old2.webp",
            newAssetData: Uint8List.fromList([4, 5, 6]),
          ),
          PagebuilderSectionTemplateAssetReplacement(
            oldUrl: "https://example.com/old3.webp",
            newAssetData: Uint8List.fromList([7, 8, 9]),
          ),
        ],
      );
      final expectedResult = right(unit);
      when(mockRepo.editTemplate(multiReplacementsTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockRepo.editTemplate(multiReplacementsTemplate);

      // Then
      verify(mockRepo.editTemplate(multiReplacementsTemplate));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle all section types correctly for edit", () async {
      // Given
      final types = [
        "hero",
        "about",
        "product",
        "callToAction",
        "advantages",
        "footer"
      ];

      for (var type in types) {
        final template = PagebuilderSectionTemplateEdit(
          templateId: "test-template-id-$type",
          environment: "staging",
          type: type,
        );

        when(mockRepo.editTemplate(template))
            .thenAnswer((_) async => right(unit));

        // When
        final result = await mockRepo.editTemplate(template);

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail("Should not return failure"),
          (value) => expect(value, unit),
        );
      }

      verify(mockRepo.editTemplate(any)).called(types.length);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
