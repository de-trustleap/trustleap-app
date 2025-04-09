import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_reason.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late RecommendationsCubit recommendationCubit;
  late MockUserRepository mockUserRepo;
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
    mockLandingPageRepo = MockLandingPageRepository();
    recommendationCubit =
        RecommendationsCubit(mockUserRepo, mockLandingPageRepo);
  });

  test("init state should be RecommendationsInitial", () {
    expect(recommendationCubit.state, RecommendationsInitial());
  });

  group("RecommendationCubit_GetUser", () {
    final mockUser = CustomUser(id: UniqueID.fromUniqueString("1"));
    test("should call user repo when function is called", () async {
      // Given
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(mockUser));
      // When
      recommendationCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      // Then
      verify(mockUserRepo.getUser());
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit RecommendationLoadingState and then RecommendationGetCurrentUserSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationLoadingState(),
        RecommendationGetCurrentUserSuccessState(user: mockUser)
      ];
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(mockUser));
      // Then
      expectLater(recommendationCubit.stream, emitsInOrder(expectedResult));
      recommendationCubit.getUser();
    });

    test(
        "should emit RecommendationLoadingState and then RecommendationGetUserFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        RecommendationLoadingState(),
        RecommendationGetUserFailureState(failure: BackendFailure())
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recommendationCubit.stream, emitsInOrder(expectedResult));
      recommendationCubit.getUser();
    });
  });

  group("RecommendationCubit_GetParentUser", () {
    const parentID = "1";
    final mockUser = CustomUser(id: UniqueID.fromUniqueString("1"));
    test("should call user repo when function is called", () async {
      // Given
      when(mockUserRepo.getParentUser(parentID: parentID))
          .thenAnswer((_) async => right(mockUser));
      // When
      recommendationCubit.getParentUser(parentID);
      await untilCalled(mockUserRepo.getParentUser(parentID: parentID));
      // Then
      verify(mockUserRepo.getParentUser(parentID: parentID));
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit RecommendationLoadingState and then RecommendationGetParentUserSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationLoadingState(),
        RecommendationGetParentUserSuccessState(user: mockUser)
      ];
      when(mockUserRepo.getParentUser(parentID: parentID))
          .thenAnswer((_) async => right(mockUser));
      // Then
      expectLater(recommendationCubit.stream, emitsInOrder(expectedResult));
      recommendationCubit.getParentUser(parentID);
    });

    test(
        "should emit RecommendationLoadingState and then RecommendationGetUserFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        RecommendationLoadingState(),
        RecommendationGetUserFailureState(failure: BackendFailure())
      ];
      when(mockUserRepo.getParentUser(parentID: parentID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recommendationCubit.stream, emitsInOrder(expectedResult));
      recommendationCubit.getParentUser(parentID);
    });
  });

  group("RecommendationCubit_GetRecommendationReasons", () {
    const landingPageIDs = ["1", "2", "3"];
    final reasons = [
      LandingPage(id: UniqueID.fromUniqueString("1"), name: "Page1"),
      LandingPage(id: UniqueID.fromUniqueString("2"), name: "Page2"),
      LandingPage(id: UniqueID.fromUniqueString("3"), name: "Page3")
    ];
    final names = [
      RecommendationReason(id: UniqueID.fromUniqueString("1"), reason: "Page1", promotionTemplate: "PromotionTemplate1", isActive: true)
    , RecommendationReason(id: UniqueID.fromUniqueString("2"), reason: "Page2", promotionTemplate: "PromotionTemplate2", isActive: false)
    , RecommendationReason(id: UniqueID.fromUniqueString("3"), reason: "Page3", promotionTemplate: "PromotionTemplate3", isActive: true)
    ];

    test("should call landingpages repo when function is called", () async {
      // Given
      when(mockLandingPageRepo.getAllLandingPages(landingPageIDs))
          .thenAnswer((_) async => right(reasons));
      // When
      recommendationCubit.getRecommendationReasons(landingPageIDs);
      await untilCalled(mockLandingPageRepo.getAllLandingPages(landingPageIDs));
      // Then
      verify(mockLandingPageRepo.getAllLandingPages(landingPageIDs));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit RecommendationLoadingState and then RecommendationGetReasonsSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationLoadingState(),
        RecommendationGetReasonsSuccessState(reasons: names)
      ];
      when(mockLandingPageRepo.getAllLandingPages(landingPageIDs))
          .thenAnswer((_) async => right(reasons));
      // Then
      expectLater(recommendationCubit.stream, emitsInOrder(expectedResult));
      recommendationCubit.getRecommendationReasons(landingPageIDs);
    });

    test(
        "should emit RecommendationLoadingState and then RecommendationGetReasonsFailureState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationLoadingState(),
        RecommendationGetReasonsFailureState(failure: BackendFailure())
      ];
      when(mockLandingPageRepo.getAllLandingPages(landingPageIDs))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recommendationCubit.stream, emitsInOrder(expectedResult));
      recommendationCubit.getRecommendationReasons(landingPageIDs);
    });
  });
}
