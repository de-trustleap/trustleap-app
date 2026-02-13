import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/legals/domain/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/legals/domain/legal_version.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_template.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
  });

  group("LandingPageRepositoryImplementation_getAllLandingPages", () {
    final testLandingPages = [
      LandingPage(id: UniqueID.fromUniqueString("1")),
      LandingPage(id: UniqueID.fromUniqueString("2")),
      LandingPage(id: UniqueID.fromUniqueString("3"))
    ];
    const ids = ["1", "2", "3"];
    test("should return landingpages when the call was successful", () async {
      // Given
      final expectedResult = right(testLandingPages);
      when(mockLandingPageRepo.getAllLandingPages(ids))
          .thenAnswer((_) async => right(testLandingPages));
      // When
      final result = await mockLandingPageRepo.getAllLandingPages(ids);
      // Then
      verify(mockLandingPageRepo.getAllLandingPages(ids));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.getAllLandingPages(ids))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.getAllLandingPages(ids);
      // Then
      verify(mockLandingPageRepo.getAllLandingPages(ids));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_createLandingPage", () {
    final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        name: "Test",
        description: "Test",
        ownerID: UniqueID.fromUniqueString("1"));
    final testImageData = Uint8List(1);
    const imageHasChanged = false;
    const templateID = "1";
    test(
        "should return unit when landingpage has been created and the call was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData,
              imageHasChanged, templateID, null))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockLandingPageRepo.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID, null);
      // Then
      verify(mockLandingPageRepo.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID, null));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData,
              imageHasChanged, templateID, null))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID, null);
      // Then
      verify(mockLandingPageRepo.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID, null));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_deleteLandingPage", () {
    const landingPageID = "1";
    const ownerID = "1";
    test(
        "should return unit when landingpage has been deleted and the call was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockLandingPageRepo.deleteLandingPage(landingPageID, ownerID))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockLandingPageRepo.deleteLandingPage(landingPageID, ownerID);
      // Then
      verify(mockLandingPageRepo.deleteLandingPage(landingPageID, ownerID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.deleteLandingPage(landingPageID, ownerID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockLandingPageRepo.deleteLandingPage(landingPageID, ownerID);
      // Then
      verify(mockLandingPageRepo.deleteLandingPage(landingPageID, ownerID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_editLandingPage", () {
    final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        name: "Test",
        description: "Test",
        ownerID: UniqueID.fromUniqueString("1"));
    final testImageData = Uint8List(1);
    const imageHasChanged = false;
    test(
        "should return unit when landingpage has been edited and the call was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockLandingPageRepo.editLandingPage(
              testLandingPage, testImageData, imageHasChanged))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockLandingPageRepo.editLandingPage(
          testLandingPage, testImageData, imageHasChanged);
      // Then
      verify(mockLandingPageRepo.editLandingPage(
          testLandingPage, testImageData, imageHasChanged));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.editLandingPage(
              testLandingPage, testImageData, imageHasChanged))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.editLandingPage(
          testLandingPage, testImageData, imageHasChanged);
      // Then
      verify(mockLandingPageRepo.editLandingPage(
          testLandingPage, testImageData, imageHasChanged));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_duplicateLandingPage", () {
    const landingPageID = "1";
    test(
        "should return unit when landingpage has been duplicated and the call was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockLandingPageRepo.duplicateLandingPage(landingPageID))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockLandingPageRepo.duplicateLandingPage(landingPageID);
      // Then
      verify(mockLandingPageRepo.duplicateLandingPage(landingPageID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.duplicateLandingPage(landingPageID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockLandingPageRepo.duplicateLandingPage(landingPageID);
      // Then
      verify(mockLandingPageRepo.duplicateLandingPage(landingPageID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_getLandingPage", () {
    const landingPageID = "1";
    final testLandingPage = LandingPage(id: UniqueID.fromUniqueString("1"));

    test("should return landing page when the call was successful", () async {
      // Given
      final expectedResult = right(testLandingPage);
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => right(testLandingPage));
      // When
      final result = await mockLandingPageRepo.getLandingPage(landingPageID);
      // Then
      verify(mockLandingPageRepo.getLandingPage(landingPageID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.getLandingPage(landingPageID);
      // Then
      verify(mockLandingPageRepo.getLandingPage(landingPageID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_getLandingPageTemplates", () {
    final testLandingPageTemplates = [
      LandingPageTemplate(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          thumbnailDownloadURL: "Test",
          page: null)
    ];
    test("should return landing page templates when the call was successful",
        () async {
      // Given
      final expectedResult = right(testLandingPageTemplates);
      when(mockLandingPageRepo.getAllLandingPageTemplates())
          .thenAnswer((_) async => right(testLandingPageTemplates));
      // When
      final result = await mockLandingPageRepo.getAllLandingPageTemplates();
      // Then
      verify(mockLandingPageRepo.getAllLandingPageTemplates());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.getAllLandingPageTemplates())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.getAllLandingPageTemplates();
      // Then
      verify(mockLandingPageRepo.getAllLandingPageTemplates());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_getUnregisteredPromoters", () {
    final promoters = [
      Promoter(id: UniqueID.fromUniqueString("1"), registered: false),
      Promoter(id: UniqueID.fromUniqueString("2"), registered: false)
    ];
    final ids = ["1", "2"];
    test("should return unregistered promoters when the call was successful",
        () async {
      // Given
      final expectedResult = right(promoters);
      when(mockLandingPageRepo.getUnregisteredPromoters(ids))
          .thenAnswer((_) async => right(promoters));
      // When
      final result = await mockLandingPageRepo.getUnregisteredPromoters(ids);
      // Then
      verify(mockLandingPageRepo.getUnregisteredPromoters(ids));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.getUnregisteredPromoters(ids))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.getUnregisteredPromoters(ids);
      // Then
      verify(mockLandingPageRepo.getUnregisteredPromoters(ids));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_getRegisteredPromoters", () {
    final promoters = [
      Promoter(id: UniqueID.fromUniqueString("1"), registered: true),
      Promoter(id: UniqueID.fromUniqueString("2"), registered: true)
    ];
    final ids = ["1", "2"];
    test("should return registered promoters when the call was successful",
        () async {
      // Given
      final expectedResult = right(promoters);
      when(mockLandingPageRepo.getRegisteredPromoters(ids))
          .thenAnswer((_) async => right(promoters));
      // When
      final result = await mockLandingPageRepo.getRegisteredPromoters(ids);
      // Then
      verify(mockLandingPageRepo.getRegisteredPromoters(ids));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.getRegisteredPromoters(ids))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.getRegisteredPromoters(ids);
      // Then
      verify(mockLandingPageRepo.getRegisteredPromoters(ids));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_getLandingPagesForPromoters", () {
    final promoters = [
      Promoter(id: UniqueID.fromUniqueString("1"), registered: true),
      Promoter(id: UniqueID.fromUniqueString("2"), registered: true)
    ];
    final landingPages = [
      LandingPage(id: UniqueID.fromUniqueString("1")),
      LandingPage(id: UniqueID.fromUniqueString("2"))
    ];
    test("should return landingpages when the call was successful", () async {
      // Given
      final expectedResult = right(landingPages);
      when(mockLandingPageRepo.getLandingPagesForPromoters(promoters))
          .thenAnswer((_) async => right(landingPages));
      // When
      final result =
          await mockLandingPageRepo.getLandingPagesForPromoters(promoters);
      // Then
      verify(mockLandingPageRepo.getLandingPagesForPromoters(promoters));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.getLandingPagesForPromoters(promoters))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockLandingPageRepo.getLandingPagesForPromoters(promoters);
      // Then
      verify(mockLandingPageRepo.getLandingPagesForPromoters(promoters));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group(
      "LandingPageRepositoryImplementation_getArchivedLandingPageLegals", () {
    const landingPageId = "1";
    final testArchivedLegals = ArchivedLandingPageLegals(
      id: landingPageId,
      privacyPolicyVersions: [
        LegalVersion(
          content: "Privacy v1",
          archivedAt: DateTime(2024, 1, 1),
          version: 1,
        ),
      ],
      initialInformationVersions: [
        LegalVersion(
          content: "Initial Info v1",
          archivedAt: DateTime(2024, 1, 1),
          version: 1,
        ),
      ],
      termsAndConditionsVersions: [
        LegalVersion(
          content: "Terms v1",
          archivedAt: DateTime(2024, 1, 1),
          version: 1,
        ),
      ],
    );

    test(
        "should return archived legals when the call was successful",
        () async {
      // Given
      final expectedResult = right(testArchivedLegals);
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => right(testArchivedLegals));
      // When
      final result = await mockLandingPageRepo
          .getArchivedLandingPageLegals(landingPageId);
      // Then
      verify(
          mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo
          .getArchivedLandingPageLegals(landingPageId);
      // Then
      verify(
          mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should return empty archived legals when no document exists",
        () async {
      // Given
      final emptyLegals =
          ArchivedLandingPageLegals(id: landingPageId);
      final expectedResult = right(emptyLegals);
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => right(emptyLegals));
      // When
      final result = await mockLandingPageRepo
          .getArchivedLandingPageLegals(landingPageId);
      // Then
      verify(
          mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });
}
