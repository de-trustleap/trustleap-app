import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../repositories/landingpage_repository_test.mocks.dart';
import '../repositories/user_repository_test.mocks.dart';

void main() {
  late LandingPageCubit landingPageCubit;
  late MockLandingPageRepository mockLandingPageRepo;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
    mockUserRepo = MockUserRepository();
    landingPageCubit = LandingPageCubit(mockLandingPageRepo, mockUserRepo);
  });

  test("init state should be LandingPageInitial", () {
    expect(landingPageCubit.state, LandingPageInitial());
  });

  group("LandingPageCubit_CreateLandingPage", () {
    final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        name: "Test",
        text: "Test",
        ownerID: UniqueID.fromUniqueString("1"));
    final testImageData = Uint8List(1);
    const imageHasChanged = false;
    test("should call landingpage repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.createLandingPage(
              testLandingPage, testImageData, imageHasChanged))
          .thenAnswer((_) async => right(unit));
      // When
      landingPageCubit.createLandingPage(
          testLandingPage, testImageData, imageHasChanged);
      await untilCalled(mockLandingPageRepo.createLandingPage(
          testLandingPage, testImageData, imageHasChanged));
      // Then
      verify(mockLandingPageRepo.createLandingPage(
          testLandingPage, testImageData, imageHasChanged));
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
      when(mockLandingPageRepo.createLandingPage(
              testLandingPage, testImageData, imageHasChanged))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.createLandingPage(
          testLandingPage, testImageData, imageHasChanged);
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
      when(mockLandingPageRepo.createLandingPage(
              testLandingPage, testImageData, imageHasChanged))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.createLandingPage(
          testLandingPage, testImageData, imageHasChanged);
    });
  });

  group("LandingPageCubit_EditLandingPage", () {
    final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("2"),
        name: "Test",
        text: "Test",
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
      await untilCalled(
          mockLandingPageRepo.duplicateLandingPage(testId));
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

  group("LandingPageCubit_GetUser", () {
    final mockUser = CustomUser(id: UniqueID.fromUniqueString("1"));
    test("should call user repo when function is called", () async {
      // Given
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(mockUser));
      // When
      landingPageCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      // Then
      verify(mockUserRepo.getUser());
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit GetUserLoadingState and then GetUserSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        GetUserLoadingState(),
        GetUserSuccessState(user: mockUser)
      ];
      // When
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(mockUser));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getUser();
    });

    test(
        "should emit DuplicateLandingPageLoadingState and then DuplicateLandingPageFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        GetUserLoadingState(),
        GetUserFailureState(failure: BackendFailure())
      ];
      // When
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(landingPageCubit.stream, emitsInOrder(expectedResult));
      landingPageCubit.getUser();
    });
  });
}
