import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/legal_version.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late LandingPageCubit landingPageCubit;
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
    landingPageCubit = LandingPageCubit(mockLandingPageRepo);
  });

  test("init state should be LandingPageInitial", () {
    expect(landingPageCubit.state, LandingPageInitial());
  });

  group("LandingPageCubit_CreateLandingPage", () {
    final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        name: "Test",
        description: "Test",
        ownerID: UniqueID.fromUniqueString("1"));
    final testImageData = Uint8List(1);
    const imageHasChanged = false;
    const templateID = "1";
    test("should call landingpage repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData,
              imageHasChanged, templateID, null))
          .thenAnswer((_) async => right(unit));
      // When
      landingPageCubit.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID);
      await untilCalled(mockLandingPageRepo.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID, null));
      // Then
      verify(mockLandingPageRepo.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID, null));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit CreateLandingPageLoadingState and then CreatedLandingPageSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        CreateLandingPageLoadingState(),
        CreatedLandingPageSuccessState()
      ];
      // When
      when(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData,
              imageHasChanged, templateID, null))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID);
    });

    test(
        "should emit CreateLandingPageLoadingState and then CreatedLandingPageFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        CreateLandingPageLoadingState(),
        CreateLandingPageFailureState(failure: BackendFailure())
      ];
      // When
      when(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData,
              imageHasChanged, templateID, null))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.createLandingPage(
          testLandingPage, testImageData, imageHasChanged, templateID);
    });
  });

  group("LandingPageCubit_EditLandingPage", () {
    final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("2"),
        name: "Test",
        description: "Test",
        ownerID: UniqueID.fromUniqueString("2"));
    final testImageData = Uint8List(2);
    const imageHasChanged = true;
    test("should call landingpage repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.editLandingPage(
              testLandingPage, testImageData, imageHasChanged))
          .thenAnswer((_) async => right(unit));
      // When
      landingPageCubit.editLandingPage(
          testLandingPage, testImageData, imageHasChanged);
      await untilCalled(mockLandingPageRepo.editLandingPage(
          testLandingPage, testImageData, imageHasChanged));
      // Then
      verify(mockLandingPageRepo.editLandingPage(
          testLandingPage, testImageData, imageHasChanged));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit EditLandingPageLoadingState and then EditLandingPageSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        EditLandingPageLoadingState(),
        EditLandingPageSuccessState()
      ];
      // When
      when(mockLandingPageRepo.editLandingPage(
              testLandingPage, testImageData, imageHasChanged))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.editLandingPage(
          testLandingPage, testImageData, imageHasChanged);
    });

    test(
        "should emit EditLandingPageLoadingState and then EditLandingPageFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        EditLandingPageLoadingState(),
        EditLandingPageFailureState(failure: BackendFailure())
      ];
      // When
      when(mockLandingPageRepo.editLandingPage(
              testLandingPage, testImageData, imageHasChanged))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.editLandingPage(
          testLandingPage, testImageData, imageHasChanged);
    });
  });

  group("LandingPageCubit_ToggleLandingPageActivity", () {
    const testId = "1";
    const testIsActive = true;
    const testUserId = "1";
    test("should call landingpage repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.toggleLandingPageActivity(
              testId, testIsActive, testUserId))
          .thenAnswer((_) async => right(unit));
      // When
      landingPageCubit.toggleLandingPageActivity(
          testId, testIsActive, testUserId);
      await untilCalled(mockLandingPageRepo.toggleLandingPageActivity(
          testId, testIsActive, testUserId));
      // Then
      verify(mockLandingPageRepo.toggleLandingPageActivity(
          testId, testIsActive, testUserId));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit ToggleLandingPageActivityLoadingState and then ToggleLandingPageActivitySuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ToggleLandingPageActivityLoadingState(),
        ToggleLandingPageActivitySuccessState(isActive: testIsActive)
      ];
      // When
      when(mockLandingPageRepo.toggleLandingPageActivity(
              testId, testIsActive, testUserId))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.toggleLandingPageActivity(
          testId, testIsActive, testUserId);
    });

    test(
        "should emit ToggleLandingPageActivityLoadingState and then ToggleLandingPageActivitySuccessState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        ToggleLandingPageActivityLoadingState(),
        ToggleLandingPageActivityFailureState(failure: BackendFailure())
      ];
      // When
      when(mockLandingPageRepo.toggleLandingPageActivity(
              testId, testIsActive, testUserId))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.toggleLandingPageActivity(
          testId, testIsActive, testUserId);
    });
  });

  group("LandingPageCubit_DeleteLandingPage", () {
    const testId = "1";
    const testParentUserID = "1";
    test("should call landingpage repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.deleteLandingPage(testId, testParentUserID))
          .thenAnswer((_) async => right(unit));
      // When
      landingPageCubit.deleteLandingPage(testId, testParentUserID);
      await untilCalled(
          mockLandingPageRepo.deleteLandingPage(testId, testParentUserID));
      // Then
      verify(mockLandingPageRepo.deleteLandingPage(testId, testParentUserID));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit DeleteLandingPageLoadingState and then DeleteLandingPageSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        DeleteLandingPageLoadingState(),
        DeleteLandingPageSuccessState()
      ];
      // When
      when(mockLandingPageRepo.deleteLandingPage(testId, testParentUserID))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.deleteLandingPage(testId, testParentUserID);
    });

    test(
        "should emit DeleteLandingPageLoadingState and then DeleteLandingPageFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        DeleteLandingPageLoadingState(),
        DeleteLandingPageFailureState(failure: BackendFailure())
      ];
      // When
      when(mockLandingPageRepo.deleteLandingPage(testId, testParentUserID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.deleteLandingPage(testId, testParentUserID);
    });
  });
  group("LandingPageCubit_DuplicateLandingPage", () {
    const testId = "1";
    test("should call landingpage repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.duplicateLandingPage(testId))
          .thenAnswer((_) async => right(unit));
      // When
      landingPageCubit.duplicateLandingPage(testId);
      await untilCalled(mockLandingPageRepo.duplicateLandingPage(testId));
      // Then
      verify(mockLandingPageRepo.duplicateLandingPage(testId));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit DuplicateLandingPageLoadingState and then DuplicateLandingPageSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        DuplicateLandingPageLoadingState(),
        DuplicateLandingPageSuccessState()
      ];
      // When
      when(mockLandingPageRepo.duplicateLandingPage(testId))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.duplicateLandingPage(testId);
    });

    test(
        "should emit DuplicateLandingPageLoadingState and then DuplicateLandingPageFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        DuplicateLandingPageLoadingState(),
        DuplicateLandingPageFailureState(failure: BackendFailure())
      ];
      // When
      when(mockLandingPageRepo.duplicateLandingPage(testId))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.duplicateLandingPage(testId);
    });
  });


  group("LandingPageCubit_CheckLandingPageImage", () {
    final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        name: "Test",
        description: "Test",
        ownerID: UniqueID.fromUniqueString("1"));
    final testLandingPage2 = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        name: "Test",
        description: "Test",
        thumbnailDownloadURL: "Test",
        ownerID: UniqueID.fromUniqueString("1"));
    final testImageData = Uint8List(1);
    test("should emit LandingPageImageValid when there is a download url", () {
      // Given
      final expectedResult = [isA<LandingPageImageValid>()];
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.checkLandingPageImage(testLandingPage2, testImageData);
    });

    test(
        "should emit LandingPageImageValid when there is no download url and imageData is there",
        () {
      // Given
      final expectedResult = [isA<LandingPageImageValid>()];
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.checkLandingPageImage(testLandingPage, testImageData);
    });

    test(
        "should emit LandingPageNoImageFailureState when there is no imageData",
        () {
      // Given
      final expectedResult = [LandingPageNoImageFailureState()];
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.checkLandingPageImage(testLandingPage, null);
    });
  });

  group("LandingPageCubit_GetPromoters", () {
    final ids = ["1", "2", "3", "4"];
    final landingPageID = "1";
    final unregisteredPromoters = [
      Promoter(
          id: UniqueID.fromUniqueString("1"),
          registered: false,
          landingPages: []),
      Promoter(
          id: UniqueID.fromUniqueString("2"),
          registered: false,
          landingPages: [])
    ];
    final registeredPromoters = [
      Promoter(
          id: UniqueID.fromUniqueString("3"),
          registered: true,
          landingPages: []),
      Promoter(
          id: UniqueID.fromUniqueString("4"),
          registered: true,
          landingPages: [])
    ];
    final landingPages = [
      LandingPage(id: UniqueID.fromUniqueString("1")),
      LandingPage(id: UniqueID.fromUniqueString("2"))
    ];
    test("should call landingpage repo when function is called", () async {
      // Given
      when(mockLandingPageRepo.getUnregisteredPromoters(ids))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(ids))
          .thenAnswer((_) async => right(registeredPromoters));
      when(mockLandingPageRepo.getLandingPagesForPromoters(
              unregisteredPromoters + registeredPromoters))
          .thenAnswer((_) async => right(landingPages));
      // When
      landingPageCubit.getPromoters(ids, landingPageID);
      await untilCalled(mockLandingPageRepo.getUnregisteredPromoters(ids));
      await untilCalled(mockLandingPageRepo.getRegisteredPromoters(ids));
      await untilCalled(mockLandingPageRepo.getLandingPagesForPromoters(
          unregisteredPromoters + registeredPromoters));
      // Then
      verify(mockLandingPageRepo.getUnregisteredPromoters(ids));
      verify(mockLandingPageRepo.getRegisteredPromoters(ids));
      verify(mockLandingPageRepo.getLandingPagesForPromoters(
          unregisteredPromoters + registeredPromoters));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit GetPromotersLoadingState and then GetUserSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        GetPromotersLoadingState(),
        GetPromotersSuccessState(
            promoters: unregisteredPromoters + registeredPromoters)
      ];
      // When
      when(mockLandingPageRepo.getUnregisteredPromoters(ids))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(ids))
          .thenAnswer((_) async => right(registeredPromoters));
      when(mockLandingPageRepo.getLandingPagesForPromoters(
              unregisteredPromoters + registeredPromoters))
          .thenAnswer((_) async => right(landingPages));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getPromoters(ids, landingPageID);
    });

    test(
        "should emit GetPromotersLoadingState and then GetPromotersFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        GetPromotersLoadingState(),
        GetPromotersFailureState(failure: BackendFailure())
      ];
      // When
      when(mockLandingPageRepo.getUnregisteredPromoters(ids))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(ids))
          .thenAnswer((_) async => right(registeredPromoters));
      when(mockLandingPageRepo.getLandingPagesForPromoters(
              unregisteredPromoters + registeredPromoters))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getPromoters(ids, landingPageID);
    });
  });

  group("LandingPageCubit_AssignLandingPagesToPromoters", () {
    test("should assign the correct landing pages to the promoters", () {
      // Given
      final landingPage1 = LandingPage(id: UniqueID.fromUniqueString("1"));
      final landingPage2 = LandingPage(id: UniqueID.fromUniqueString("2"));

      final promoter1 = Promoter(
        id: UniqueID.fromUniqueString("1"),
        landingPageIDs: ["1"],
      );

      final promoter2 = Promoter(
        id: UniqueID.fromUniqueString("2"),
        landingPageIDs: ["2"],
      );

      final promoters = [promoter1, promoter2];
      final landingPages = [landingPage1, landingPage2];

      // When
      final result = landingPageCubit.assignLandingPagesToPromoters(
          promoters, landingPages);

      // Then
      expect(result[0].landingPages, contains(landingPage1));
      expect(result[1].landingPages, contains(landingPage2));
    });

    test(
        "should return empty landingPages list for a promoter with no matching landingPageIDs",
        () {
      // Given
      final landingPage = LandingPage(id: UniqueID.fromUniqueString("1"));

      final promoter = Promoter(
        id: UniqueID.fromUniqueString("1"),
        landingPageIDs: ["2"],
      );

      final promoters = [promoter];
      final landingPages = [landingPage];

      // When
      final result = landingPageCubit.assignLandingPagesToPromoters(
          promoters, landingPages);

      // Then
      expect(result[0].landingPages, isEmpty);
    });

    test("should not modify the original promoter and landingPages lists", () {
      // Given
      final landingPage = LandingPage(id: UniqueID.fromUniqueString("1"));
      final promoter = Promoter(
        id: UniqueID.fromUniqueString("1"),
        landingPageIDs: ["1"],
      );

      final promoters = [promoter];
      final landingPages = [landingPage];

      final originalPromoters = List.of(promoters);
      final originalLandingPages = List.of(landingPages);

      // When
      landingPageCubit.assignLandingPagesToPromoters(promoters, landingPages);

      // Then
      expect(promoters, equals(originalPromoters));
      expect(landingPages, equals(originalLandingPages));
    });

    test("should return an empty list if promoters list is empty", () {
      // Given
      final landingPage = LandingPage(id: UniqueID.fromUniqueString("1"));

      // When
      final result =
          landingPageCubit.assignLandingPagesToPromoters([], [landingPage]);

      // Then
      expect(result, isEmpty);
    });

    test(
        "should return promoters with empty landingPages list if landingPages list is empty",
        () {
      // Given
      final promoter = Promoter(
        id: UniqueID.fromUniqueString("1"),
        landingPageIDs: ["1"],
      );

      // When
      final result =
          landingPageCubit.assignLandingPagesToPromoters([promoter], []);

      // Then
      expect(result[0].landingPages, isEmpty);
    });
  });

  group("LandingPageCubit_GetPromotersWithoutActiveLandingPagesAfterDeletion",
      () {
    test("should return promoters who have no landing pages after deletion",
        () {
      // Given
      final landingPage1 = LandingPage(id: UniqueID.fromUniqueString("1"));
      final promoter = Promoter(
        id: UniqueID.fromUniqueString("1"),
        landingPages: [landingPage1],
      );

      final promoters = [promoter];

      // When
      final result = landingPageCubit
          .getPromotersWithoutActiveLandingPagesAfterDeletion("1", promoters);

      // Then
      expect(result, contains(promoter));
    });

    test(
        "should return promoters who have no active landing pages after deletion",
        () {
      // Given
      final activeLandingPage =
          LandingPage(id: UniqueID.fromUniqueString("1"), isActive: true);
      final inactiveLandingPage =
          LandingPage(id: UniqueID.fromUniqueString("2"), isActive: false);

      final promoter = Promoter(
        id: UniqueID.fromUniqueString("1"),
        landingPages: [activeLandingPage, inactiveLandingPage],
      );

      final promoters = [promoter];

      // When
      final result = landingPageCubit
          .getPromotersWithoutActiveLandingPagesAfterDeletion("1", promoters);

      // Then
      expect(result, contains(promoter));
    });

    test(
        "should not return promoters if they still have at least one active landing page",
        () {
      // Given
      final activeLandingPage1 =
          LandingPage(id: UniqueID.fromUniqueString(""), isActive: true);
      final activeLandingPage2 =
          LandingPage(id: UniqueID.fromUniqueString("2"), isActive: true);

      final promoter = Promoter(
        id: UniqueID.fromUniqueString("1"),
        landingPages: [activeLandingPage1, activeLandingPage2],
      );

      final promoters = [promoter];

      // When
      final result = landingPageCubit
          .getPromotersWithoutActiveLandingPagesAfterDeletion("1", promoters);

      // Then
      expect(result, isEmpty);
    });

    test("should return an empty list if the promoters list is empty", () {
      // When
      final result = landingPageCubit
          .getPromotersWithoutActiveLandingPagesAfterDeletion("1", []);

      // Then
      expect(result, isEmpty);
    });
  });

  group("LandingPageCubit_GetAssignedPromoters", () {
    final associatedUsersIDs = ["1", "2"];
    final unregisteredPromoters = [
      Promoter(id: UniqueID.fromUniqueString("1"), registered: false),
    ];
    final registeredPromoters = [
      Promoter(id: UniqueID.fromUniqueString("2"), registered: true),
    ];

    test("should call landingpage repo when function is called", () async {
      // Given
      when(mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(registeredPromoters));
      // When
      landingPageCubit.getAssignedPromoters(associatedUsersIDs);
      await untilCalled(
          mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs));
      await untilCalled(
          mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs));
      // Then
      verify(
          mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs));
      verify(
          mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit GetPromotersLoadingState and then GetPromotersSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        GetPromotersLoadingState(),
        GetPromotersSuccessState(
            promoters: unregisteredPromoters + registeredPromoters),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(registeredPromoters));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAssignedPromoters(associatedUsersIDs);
    });

    test(
        "should emit GetPromotersLoadingState and then GetPromotersFailureState when getUnregisteredPromoters fails",
        () async {
      // Given
      final expectedResult = [
        GetPromotersLoadingState(),
        GetPromotersFailureState(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAssignedPromoters(associatedUsersIDs);
    });

    test(
        "should emit GetPromotersLoadingState and then GetPromotersFailureState when getRegisteredPromoters fails",
        () async {
      // Given
      final expectedResult = [
        GetPromotersLoadingState(),
        GetPromotersFailureState(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAssignedPromoters(associatedUsersIDs);
    });

    test(
        "should emit GetPromotersLoadingState and then GetPromotersSuccessState with empty list when associatedUsersIDs is null",
        () async {
      // Given
      final expectedResult = [
        GetPromotersLoadingState(),
        GetPromotersSuccessState(promoters: []),
      ];
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAssignedPromoters(null);
    });

    test(
        "should emit GetPromotersLoadingState and then GetPromotersSuccessState with empty list when associatedUsersIDs is empty",
        () async {
      // Given
      final expectedResult = [
        GetPromotersLoadingState(),
        GetPromotersSuccessState(promoters: []),
      ];
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAssignedPromoters([]);
    });
  });

  group("LandingPageCubit_GetAllPromotersForUser", () {
    final registeredIds = ["1", "2"];
    final unregisteredIds = ["3", "4"];
    final registeredPromoters = [
      Promoter(id: UniqueID.fromUniqueString("1"), registered: true),
      Promoter(id: UniqueID.fromUniqueString("2"), registered: true),
    ];
    final unregisteredPromoters = [
      Promoter(id: UniqueID.fromUniqueString("3"), registered: false),
      Promoter(id: UniqueID.fromUniqueString("4"), registered: false),
    ];
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString("user-1"),
      registeredPromoterIDs: registeredIds,
      unregisteredPromoterIDs: unregisteredIds,
    );

    test(
        "should emit GetAllPromotersLoadingState and then GetAllPromotersSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        GetAllPromotersLoadingState(),
        GetAllPromotersSuccessState(
            promoters: unregisteredPromoters + registeredPromoters),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(unregisteredIds))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(registeredIds))
          .thenAnswer((_) async => right(registeredPromoters));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAllPromotersForUser(testUser);
    });

    test(
        "should emit GetAllPromotersLoadingState and then GetAllPromotersFailureState when getUnregisteredPromoters fails",
        () async {
      // Given
      final expectedResult = [
        GetAllPromotersLoadingState(),
        GetAllPromotersFailureState(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(unregisteredIds))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAllPromotersForUser(testUser);
    });

    test(
        "should emit GetAllPromotersLoadingState and then GetAllPromotersFailureState when getRegisteredPromoters fails",
        () async {
      // Given
      final expectedResult = [
        GetAllPromotersLoadingState(),
        GetAllPromotersFailureState(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(unregisteredIds))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(registeredIds))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAllPromotersForUser(testUser);
    });

    test(
        "should emit GetAllPromotersLoadingState and then GetAllPromotersSuccessState with empty list when user has no promoter IDs",
        () async {
      // Given
      final userWithNoPromoters = CustomUser(
        id: UniqueID.fromUniqueString("user-2"),
      );
      final expectedResult = [
        GetAllPromotersLoadingState(),
        GetAllPromotersSuccessState(promoters: []),
      ];
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAllPromotersForUser(userWithNoPromoters);
    });

    test(
        "should emit success with only registered promoters when user has no unregistered promoter IDs",
        () async {
      // Given
      final userOnlyRegistered = CustomUser(
        id: UniqueID.fromUniqueString("user-3"),
        registeredPromoterIDs: registeredIds,
      );
      final expectedResult = [
        GetAllPromotersLoadingState(),
        GetAllPromotersSuccessState(promoters: registeredPromoters),
      ];
      when(mockLandingPageRepo.getRegisteredPromoters(registeredIds))
          .thenAnswer((_) async => right(registeredPromoters));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAllPromotersForUser(userOnlyRegistered);
    });

    test(
        "should emit success with only unregistered promoters when user has no registered promoter IDs",
        () async {
      // Given
      final userOnlyUnregistered = CustomUser(
        id: UniqueID.fromUniqueString("user-4"),
        unregisteredPromoterIDs: unregisteredIds,
      );
      final expectedResult = [
        GetAllPromotersLoadingState(),
        GetAllPromotersSuccessState(promoters: unregisteredPromoters),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(unregisteredIds))
          .thenAnswer((_) async => right(unregisteredPromoters));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getAllPromotersForUser(userOnlyUnregistered);
    });
  });

  group("LandingPageCubit_GetArchivedLandingPageLegals", () {
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
    );

    test("should call landingpage repo when function is called", () async {
      // Given
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => right(testArchivedLegals));
      // When
      landingPageCubit.getArchivedLandingPageLegals(landingPageId);
      await untilCalled(
          mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId));
      // Then
      verify(
          mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit GetArchivedLegalsLoadingState and then GetArchivedLegalsSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        GetArchivedLegalsLoadingState(),
        GetArchivedLegalsSuccessState(archivedLegals: testArchivedLegals),
      ];
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => right(testArchivedLegals));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getArchivedLandingPageLegals(landingPageId);
    });

    test(
        "should emit GetArchivedLegalsLoadingState and then GetArchivedLegalsFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        GetArchivedLegalsLoadingState(),
        GetArchivedLegalsFailureState(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getArchivedLandingPageLegals(landingPageId);
    });
  });
}
