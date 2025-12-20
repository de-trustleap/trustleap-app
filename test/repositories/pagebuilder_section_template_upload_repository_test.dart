// ignore_for_file: type=lint
import "dart:typed_data";

import "package:dartz/dartz.dart";
import "package:finanzbegleiter/core/failures/database_failures.dart";
import "package:finanzbegleiter/domain/entities/pagebuilder_section_template_upload.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../mocks.mocks.dart";

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
}
