import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late RecommendationManagerCubit recoManagerCubit;
  late MockRecommendationRepository mockRecoRepo;

  setUp(() {
    mockRecoRepo = MockRecommendationRepository();
    recoManagerCubit = RecommendationManagerCubit(mockRecoRepo);
  });

  test("init state should be RecommendationsInitial", () {
    expect(recoManagerCubit.state, RecommendationManagerInitial());
  });

  group("RecommendationManagerCubit_getRecommendations", () {
    final userID = "1";
    final recommendation = PersonalizedRecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: StatusLevel.recommendationSend,
        statusTimestamps: null,
        promoterImageDownloadURL: null);
    final recommendations = [
      UserRecommendation(
          id: UniqueID.fromUniqueString("1"),
          recoID: "1",
          userID: "1",
          priority: RecommendationPriority.medium,
  
          notes: "Test",
          recommendation: recommendation)
    ];

    test("should call reco repo when function is called", () async {
      // Given
      when(mockRecoRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(recommendations));
      // When
      recoManagerCubit.getRecommendations(userID);
      await untilCalled(mockRecoRepo.getRecommendations(userID));
      // Then
      verify(mockRecoRepo.getRecommendations(userID));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationManagerLoadingState and then RecommendationGetRecosSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerLoadingState(),
        RecommendationGetRecosSuccessState(
            recoItems: recommendations,
            showSetAppointmentSnackBar: false,
            showFinishedSnackBar: false,
            showFavoriteSnackbar: false,
            showPrioritySnackbar: false,
            showNotesSnackbar: false)
      ];
      when(mockRecoRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(recommendations));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.getRecommendations(userID);
    });

    test(
        "should emit RecommendationManagerLoadingState and then RecommendationGetUserFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerLoadingState(),
        RecommendationGetRecosFailureState(failure: BackendFailure())
      ];
      when(mockRecoRepo.getRecommendations(userID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.getRecommendations(userID);
    });

    test(
        "should emit RecommendationManagerLoadingState and then RecommendationGetRecosNoRecosState when there are no recommendations",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerLoadingState(),
        RecommendationGetRecosNoRecosState()
      ];
      when(mockRecoRepo.getRecommendations(userID))
          .thenAnswer((_) async => right([]));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.getRecommendations(userID);
    });
  });

  group("RecommendationManagerCubit_deleteRecommendation", () {
    final recoID = "1";
    final userID = "1";
    final userRecoID = "1";
    test("should call user repo when function is called", () async {
      // Given
      when(mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID))
          .thenAnswer((_) async => right(unit));
      // When
      recoManagerCubit.deleteRecommendation(recoID, userID, userRecoID);
      await untilCalled(
          mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID));
      // Then
      verify(mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationManagerLoadingState and then RecommendationDeleteRecoSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerLoadingState(),
        RecommendationDeleteRecoSuccessState()
      ];
      when(mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.deleteRecommendation(recoID, userID, userRecoID);
    });

    test(
        "should emit RecommendationManagerLoadingState and then RecommendationDeleteRecoFailureState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerLoadingState(),
        RecommendationDeleteRecoFailureState(failure: BackendFailure())
      ];
      when(mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.deleteRecommendation(recoID, userID, userRecoID);
    });
  });
}
