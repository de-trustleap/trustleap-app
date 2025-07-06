import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockRecommendationRepository mockRecoRepo;
  late RecommendationsAlertCubit recommendationAlertCubit;

  setUp(() {
    mockRecoRepo = MockRecommendationRepository();
    recommendationAlertCubit = RecommendationsAlertCubit(mockRecoRepo);
  });
  group("RecommendationCubit_SaveRecommendation", () {
    final userID = "1";
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Page1",
        landingPageID: "2",
        promotionTemplate: "Test",
        promoterName: "Tester",
        serviceProviderName: "Tester",
        userID: "1",
        statusLevel: StatusLevel.recommendationSend,
        statusTimestamps: null,
        defaultLandingPageID: "3",
        promoterImageDownloadURL: null,
        lastUpdated: null);

    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockRecoRepo.saveRecommendation(recommendation, userID))
          .thenAnswer((_) async => right(unit));
      // When
      recommendationAlertCubit.saveRecommendation(recommendation, userID);
      await untilCalled(
          mockRecoRepo.saveRecommendation(recommendation, userID));
      // Then
      verify(mockRecoRepo.saveRecommendation(recommendation, userID));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationSaveLoadingState and then RecommendationSaveSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSaveLoadingState(recommendation: recommendation),
        RecommendationSaveSuccessState(recommendation: recommendation)
      ];
      when(mockRecoRepo.saveRecommendation(recommendation, userID))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(
          recommendationAlertCubit.stream, emitsInOrder(expectedResult));
      recommendationAlertCubit.saveRecommendation(recommendation, userID);
    });

    test(
        "should emit RecommendationSaveLoadingState and then RecommendationSaveFailureState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSaveLoadingState(recommendation: recommendation),
        RecommendationSaveFailureState(
            failure: BackendFailure(), recommendation: recommendation)
      ];
      when(mockRecoRepo.saveRecommendation(recommendation, userID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(
          recommendationAlertCubit.stream, emitsInOrder(expectedResult));
      recommendationAlertCubit.saveRecommendation(recommendation, userID);
    });
  });
}
