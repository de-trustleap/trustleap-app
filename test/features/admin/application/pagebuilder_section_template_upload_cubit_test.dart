import "dart:typed_data";

import "package:dartz/dartz.dart";
import "package:finanzbegleiter/features/admin/application/pagebuilder_section_template_upload_cubit.dart";
import "package:finanzbegleiter/core/failures/database_failures.dart";
import "package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_asset_replacement.dart";
import "package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_edit.dart";
import "package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_upload.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../mocks.mocks.dart";

void main() {
  late PagebuilderSectionTemplateUploadCubit cubit;
  late MockPagebuilderSectionTemplateUploadRepository mockRepo;

  setUp(() {
    mockRepo = MockPagebuilderSectionTemplateUploadRepository();
    cubit = PagebuilderSectionTemplateUploadCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  test("init state should be PagebuilderSectionTemplateUploadInitial", () {
    expect(cubit.state, isA<PagebuilderSectionTemplateUploadInitial>());
  });

  group("PagebuilderSectionTemplateUploadCubit_UploadTemplate", () {
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

    test("should call repository when function is called", () async {
      // Given
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      cubit.uploadTemplate(testTemplate);
      await untilCalled(mockRepo.uploadTemplate(testTemplate));

      // Then
      verify(mockRepo.uploadTemplate(testTemplate));
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should emit PagebuilderSectionTemplateUploadLoading and then PagebuilderSectionTemplateUploadSuccess when upload was successful",
        () async {
      // Given
      final expectedResult = [
        isA<PagebuilderSectionTemplateUploadLoading>(),
        isA<PagebuilderSectionTemplateUploadSuccess>()
      ];
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.uploadTemplate(testTemplate);
    });

    test(
        "should emit Loading and then Failure when upload has failed with PermissionDeniedFailure",
        () async {
      // Given
      final failure = PermissionDeniedFailure();
      final expectedResult = [
        isA<PagebuilderSectionTemplateUploadLoading>(),
        predicate<PagebuilderSectionTemplateUploadFailure>(
            (state) => state.failure == failure)
      ];
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => left(failure));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.uploadTemplate(testTemplate);
    });

    test(
        "should emit Loading and then Failure when upload has failed with BackendFailure",
        () async {
      // Given
      final failure = BackendFailure();
      final expectedResult = [
        isA<PagebuilderSectionTemplateUploadLoading>(),
        predicate<PagebuilderSectionTemplateUploadFailure>(
            (state) => state.failure == failure)
      ];
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => left(failure));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.uploadTemplate(testTemplate);
    });

    test(
        "should emit Loading and then Failure when upload has failed with UnavailableFailure",
        () async {
      // Given
      final failure = UnavailableFailure();
      final expectedResult = [
        isA<PagebuilderSectionTemplateUploadLoading>(),
        predicate<PagebuilderSectionTemplateUploadFailure>(
            (state) => state.failure == failure)
      ];
      when(mockRepo.uploadTemplate(testTemplate))
          .thenAnswer((_) async => left(failure));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.uploadTemplate(testTemplate);
    });

    test("should handle template without assets correctly", () async {
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
      final expectedResult = [
        isA<PagebuilderSectionTemplateUploadLoading>(),
        isA<PagebuilderSectionTemplateUploadSuccess>()
      ];
      when(mockRepo.uploadTemplate(templateWithoutAssets))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.uploadTemplate(templateWithoutAssets);
    });

    test("should handle different section types correctly", () async {
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
        cubit.uploadTemplate(template);
        await untilCalled(mockRepo.uploadTemplate(template));

        // Then
        expect(cubit.state, isA<PagebuilderSectionTemplateUploadSuccess>());
      }

      verify(mockRepo.uploadTemplate(any)).called(types.length);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle different environments correctly", () async {
      // Given
      final environments = ["staging", "prod", "both"];

      for (var env in environments) {
        final template = PagebuilderSectionTemplateUpload(
          jsonData: Uint8List.fromList([1, 2, 3, 4]),
          jsonFileName: "test-section.json",
          thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
          thumbnailFileName: "thumbnail.png",
          assetDataList: [],
          assetFileNames: [],
          environment: env,
          type: "hero",
        );

        when(mockRepo.uploadTemplate(template))
            .thenAnswer((_) async => right(unit));

        // When
        cubit.uploadTemplate(template);
        await untilCalled(mockRepo.uploadTemplate(template));

        // Then
        expect(cubit.state, isA<PagebuilderSectionTemplateUploadSuccess>());
      }

      verify(mockRepo.uploadTemplate(any)).called(environments.length);
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
      final expectedResult = [
        isA<PagebuilderSectionTemplateUploadLoading>(),
        isA<PagebuilderSectionTemplateUploadSuccess>()
      ];
      when(mockRepo.uploadTemplate(multipleAssetsTemplate))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.uploadTemplate(multipleAssetsTemplate);
    });
  });

  group("PagebuilderSectionTemplateUploadCubit state equality", () {
    test("two PagebuilderSectionTemplateUploadInitial should be equal", () {
      final state1 = PagebuilderSectionTemplateUploadInitial();
      final state2 = PagebuilderSectionTemplateUploadInitial();

      expect(state1, equals(state2));
    });

    test("two PagebuilderSectionTemplateUploadLoading should be equal", () {
      final state1 = PagebuilderSectionTemplateUploadLoading();
      final state2 = PagebuilderSectionTemplateUploadLoading();

      expect(state1, equals(state2));
    });

    test("two PagebuilderSectionTemplateUploadSuccess should be equal", () {
      final state1 = PagebuilderSectionTemplateUploadSuccess();
      final state2 = PagebuilderSectionTemplateUploadSuccess();

      expect(state1, equals(state2));
    });

    test(
        "two PagebuilderSectionTemplateUploadFailure with same failure should be equal",
        () {
      final failure = BackendFailure();
      final state1 = PagebuilderSectionTemplateUploadFailure(failure: failure);
      final state2 = PagebuilderSectionTemplateUploadFailure(failure: failure);

      expect(state1, equals(state2));
    });

    test(
        "two PagebuilderSectionTemplateUploadFailure with different failures should not be equal",
        () {
      final state1 =
          PagebuilderSectionTemplateUploadFailure(failure: BackendFailure());
      final state2 = PagebuilderSectionTemplateUploadFailure(
          failure: PermissionDeniedFailure());

      expect(state1, isNot(equals(state2)));
    });
  });

  group("PagebuilderSectionTemplateUploadCubit_EditTemplate", () {
    final testEditTemplate = PagebuilderSectionTemplateEdit(
      templateId: "test-template-id",
      environment: "staging",
      jsonData: Uint8List.fromList([1, 2, 3, 4]),
      thumbnailData: Uint8List.fromList([5, 6, 7, 8]),
      deletedAssetUrls: ["https://example.com/deleted.webp"],
      replacements: [
        PagebuilderSectionTemplateAssetReplacement(
          oldUrl: "https://example.com/old.webp",
          newAssetData: Uint8List.fromList([9, 10, 11, 12]),
        ),
      ],
      newAssetDataList: [Uint8List.fromList([13, 14, 15, 16])],
      type: "hero",
    );

    test("should call repository when function is called", () async {
      // Given
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => right(unit));

      // When
      cubit.editTemplate(testEditTemplate);
      await untilCalled(mockRepo.editTemplate(testEditTemplate));

      // Then
      verify(mockRepo.editTemplate(testEditTemplate));
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should emit PagebuilderSectionTemplateEditLoading and then PagebuilderSectionTemplateEditSuccess when edit was successful",
        () async {
      // Given
      final expectedResult = [
        isA<PagebuilderSectionTemplateEditLoading>(),
        isA<PagebuilderSectionTemplateEditSuccess>()
      ];
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.editTemplate(testEditTemplate);
    });

    test(
        "should emit Loading and then Failure when edit has failed with PermissionDeniedFailure",
        () async {
      // Given
      final failure = PermissionDeniedFailure();
      final expectedResult = [
        isA<PagebuilderSectionTemplateEditLoading>(),
        predicate<PagebuilderSectionTemplateEditFailure>(
            (state) => state.failure == failure)
      ];
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => left(failure));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.editTemplate(testEditTemplate);
    });

    test(
        "should emit Loading and then Failure when edit has failed with BackendFailure",
        () async {
      // Given
      final failure = BackendFailure();
      final expectedResult = [
        isA<PagebuilderSectionTemplateEditLoading>(),
        predicate<PagebuilderSectionTemplateEditFailure>(
            (state) => state.failure == failure)
      ];
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => left(failure));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.editTemplate(testEditTemplate);
    });

    test(
        "should emit Loading and then Failure when edit has failed with UnavailableFailure",
        () async {
      // Given
      final failure = UnavailableFailure();
      final expectedResult = [
        isA<PagebuilderSectionTemplateEditLoading>(),
        predicate<PagebuilderSectionTemplateEditFailure>(
            (state) => state.failure == failure)
      ];
      when(mockRepo.editTemplate(testEditTemplate))
          .thenAnswer((_) async => left(failure));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.editTemplate(testEditTemplate);
    });

    test("should handle edit with minimal fields correctly", () async {
      // Given
      final minimalEditTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "both",
      );
      final expectedResult = [
        isA<PagebuilderSectionTemplateEditLoading>(),
        isA<PagebuilderSectionTemplateEditSuccess>()
      ];
      when(mockRepo.editTemplate(minimalEditTemplate))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.editTemplate(minimalEditTemplate);
    });

    test("should handle different section types correctly", () async {
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
        cubit.editTemplate(template);
        await untilCalled(mockRepo.editTemplate(template));

        // Then
        expect(cubit.state, isA<PagebuilderSectionTemplateEditSuccess>());
      }

      verify(mockRepo.editTemplate(any)).called(types.length);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle different environments correctly", () async {
      // Given
      final environments = ["staging", "prod", "both"];

      for (var env in environments) {
        final template = PagebuilderSectionTemplateEdit(
          templateId: "test-template-id-$env",
          environment: env,
        );

        when(mockRepo.editTemplate(template))
            .thenAnswer((_) async => right(unit));

        // When
        cubit.editTemplate(template);
        await untilCalled(mockRepo.editTemplate(template));

        // Then
        expect(cubit.state, isA<PagebuilderSectionTemplateEditSuccess>());
      }

      verify(mockRepo.editTemplate(any)).called(environments.length);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle edit with multiple replacements correctly", () async {
      // Given
      final multiReplacementTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "staging",
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
      final expectedResult = [
        isA<PagebuilderSectionTemplateEditLoading>(),
        isA<PagebuilderSectionTemplateEditSuccess>()
      ];
      when(mockRepo.editTemplate(multiReplacementTemplate))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.editTemplate(multiReplacementTemplate);
    });

    test("should handle edit with multiple deleted assets correctly",
        () async {
      // Given
      final multiDeleteTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "staging",
        deletedAssetUrls: [
          "https://example.com/deleted1.webp",
          "https://example.com/deleted2.webp",
          "https://example.com/deleted3.webp",
        ],
      );
      final expectedResult = [
        isA<PagebuilderSectionTemplateEditLoading>(),
        isA<PagebuilderSectionTemplateEditSuccess>()
      ];
      when(mockRepo.editTemplate(multiDeleteTemplate))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.editTemplate(multiDeleteTemplate);
    });

    test("should handle edit with multiple new assets correctly", () async {
      // Given
      final multiNewAssetTemplate = PagebuilderSectionTemplateEdit(
        templateId: "test-template-id",
        environment: "staging",
        newAssetDataList: [
          Uint8List.fromList([1, 2, 3]),
          Uint8List.fromList([4, 5, 6]),
          Uint8List.fromList([7, 8, 9]),
        ],
      );
      final expectedResult = [
        isA<PagebuilderSectionTemplateEditLoading>(),
        isA<PagebuilderSectionTemplateEditSuccess>()
      ];
      when(mockRepo.editTemplate(multiNewAssetTemplate))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.editTemplate(multiNewAssetTemplate);
    });
  });

  group("PagebuilderSectionTemplateUploadCubit Edit state equality", () {
    test("two PagebuilderSectionTemplateEditLoading should be equal", () {
      final state1 = PagebuilderSectionTemplateEditLoading();
      final state2 = PagebuilderSectionTemplateEditLoading();

      expect(state1, equals(state2));
    });

    test("two PagebuilderSectionTemplateEditSuccess should be equal", () {
      final state1 = PagebuilderSectionTemplateEditSuccess();
      final state2 = PagebuilderSectionTemplateEditSuccess();

      expect(state1, equals(state2));
    });

    test(
        "two PagebuilderSectionTemplateEditFailure with same failure should be equal",
        () {
      final failure = BackendFailure();
      final state1 = PagebuilderSectionTemplateEditFailure(failure: failure);
      final state2 = PagebuilderSectionTemplateEditFailure(failure: failure);

      expect(state1, equals(state2));
    });

    test(
        "two PagebuilderSectionTemplateEditFailure with different failures should not be equal",
        () {
      final state1 =
          PagebuilderSectionTemplateEditFailure(failure: BackendFailure());
      final state2 = PagebuilderSectionTemplateEditFailure(
          failure: PermissionDeniedFailure());

      expect(state1, isNot(equals(state2)));
    });
  });
}
