import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
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

  test("init state should be CompanyInitial", () {
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
    test("should call landingpage repo if function is called", () async {
      // Given
    });
  });
}
