import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/application/landing_page_creator/landing_page_creator_cubit.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_image_data.dart';
import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late LandingPageCreatorCubit cubit;
  late MockLandingPageRepository mockRepo;

  setUp(() {
    mockRepo = MockLandingPageRepository();
    cubit = LandingPageCreatorCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  test("init state should have correct default values", () {
    expect(cubit.state.id, isNull);
    expect(cubit.state.isEditMode, isFalse);
    expect(cubit.state.createDefaultPage, isFalse);
    expect(cubit.state.imageData, const LandingPageImageData.empty());
  });

  group("LandingPageCreatorCubit_Initialize", () {
    test("initialize without landingPage should set isEditMode to false", () {
      // When
      cubit.initialize(createDefaultPage: false);
      // Then
      expect(cubit.state.isEditMode, isFalse);
      expect(cubit.state.landingPage, isNull);
      expect(cubit.state.createDefaultPage, isFalse);
    });

    test("initialize with landingPage should set isEditMode to true", () {
      // Given
      final landingPage = LandingPage(
          id: UniqueID.fromUniqueString("1"), name: "Test");
      // When
      cubit.initialize(landingPage: landingPage);
      // Then
      expect(cubit.state.isEditMode, isTrue);
      expect(cubit.state.landingPage, landingPage);
    });

    test("initialize with createDefaultPage true should set createDefaultPage", () {
      // When
      cubit.initialize(createDefaultPage: true);
      // Then
      expect(cubit.state.createDefaultPage, isTrue);
    });
  });

  group("LandingPageCreatorCubit_UpdateMainImage", () {
    test("updateMainImage should update mainImage in imageData", () {
      // Given
      final image = Uint8List(10);
      // When
      cubit.updateMainImage(image, true);
      // Then
      expect(cubit.state.imageData.mainImage, image);
      expect(cubit.state.imageData.mainImageHasChanged, isTrue);
    });

    test("updateMainImage with null should clear mainImage", () {
      // When
      cubit.updateMainImage(null, false);
      // Then
      expect(cubit.state.imageData.mainImage, isNull);
      expect(cubit.state.imageData.mainImageHasChanged, isFalse);
    });
  });

  group("LandingPageCreatorCubit_UpdateFaviconImage", () {
    test("updateFaviconImage should update faviconImage in imageData", () {
      // Given
      final image = Uint8List(8);
      // When
      cubit.updateFaviconImage(image, true);
      // Then
      expect(cubit.state.imageData.faviconImage, image);
      expect(cubit.state.imageData.faviconImageHasChanged, isTrue);
    });

    test("updateFaviconImage with null should clear faviconImage", () {
      // When
      cubit.updateFaviconImage(null, false);
      // Then
      expect(cubit.state.imageData.faviconImage, isNull);
      expect(cubit.state.imageData.faviconImageHasChanged, isFalse);
    });

    test("updateFaviconImage should not affect other imageData fields", () {
      // Given
      final mainImage = Uint8List(5);
      cubit.updateMainImage(mainImage, true);
      // When
      cubit.updateFaviconImage(Uint8List(8), true);
      // Then
      expect(cubit.state.imageData.mainImage, mainImage);
      expect(cubit.state.imageData.mainImageHasChanged, isTrue);
    });
  });

  group("LandingPageCreatorCubit_UpdateShareImage", () {
    test("updateShareImage should update shareImage in imageData", () {
      // Given
      final image = Uint8List(12);
      // When
      cubit.updateShareImage(image, true);
      // Then
      expect(cubit.state.imageData.shareImage, image);
      expect(cubit.state.imageData.shareImageHasChanged, isTrue);
    });

    test("updateShareImage with null should clear shareImage", () {
      // When
      cubit.updateShareImage(null, false);
      // Then
      expect(cubit.state.imageData.shareImage, isNull);
      expect(cubit.state.imageData.shareImageHasChanged, isFalse);
    });

    test("updateShareImage should not affect other imageData fields", () {
      // Given
      final faviconImage = Uint8List(8);
      cubit.updateFaviconImage(faviconImage, true);
      // When
      cubit.updateShareImage(Uint8List(12), true);
      // Then
      expect(cubit.state.imageData.faviconImage, faviconImage);
      expect(cubit.state.imageData.faviconImageHasChanged, isTrue);
    });
  });

  group("LandingPageCreatorCubit_LoadShareImageTemplates", () {
    final testUrls = [
      "https://storage.googleapis.com/bucket/shareImageTemplates/t1.jpg",
      "https://storage.googleapis.com/bucket/shareImageTemplates/t2.jpg",
    ];

    test(
        "should update shareImageTemplateUrls in state when call is successful",
        () async {
      // Given
      when(mockRepo.getShareImageTemplateUrls())
          .thenAnswer((_) async => right(testUrls));
      // When
      await cubit.loadShareImageTemplates();
      // Then
      expect(cubit.state.shareImageTemplateUrls, testUrls);
    });

    test(
        "should not change shareImageTemplateUrls when call fails",
        () async {
      // Given
      when(mockRepo.getShareImageTemplateUrls())
          .thenAnswer((_) async => left(ObjectNotFound()));
      // When
      await cubit.loadShareImageTemplates();
      // Then
      expect(cubit.state.shareImageTemplateUrls, isNull);
    });
  });

  group("LandingPageCreatorCubit_SetError", () {
    test("setError should set showError to true and errorMessage", () {
      // When
      cubit.setError("Something went wrong");
      // Then
      expect(cubit.state.showError, isTrue);
      expect(cubit.state.errorMessage, "Something went wrong");
    });

    test("clearError should set showError to false and clear errorMessage", () {
      // Given
      cubit.setError("Error");
      // When
      cubit.clearError();
      // Then
      expect(cubit.state.showError, isFalse);
      expect(cubit.state.errorMessage, "");
    });
  });

  group("LandingPageCreatorCubit_SetCompany", () {
    test("setCompany should update company in state", () {
      // Given
      final company =
          Company(id: UniqueID.fromUniqueString("1"), name: "Test GmbH");
      // When
      cubit.setCompany(company);
      // Then
      expect(cubit.state.company, company);
    });
  });

  group("LandingPageCreatorCubit_Reset", () {
    test("reset should restore initial state", () {
      // Given
      cubit.setError("Error");
      cubit.updateFaviconImage(Uint8List(8), true);
      // When
      cubit.reset();
      // Then
      expect(cubit.state.id, isNull);
      expect(cubit.state.isEditMode, isFalse);
      expect(cubit.state.createDefaultPage, isFalse);
      expect(cubit.state.imageData, const LandingPageImageData.empty());
      expect(cubit.state.showError, isFalse);
      expect(cubit.state.errorMessage, "");
    });
  });
}
