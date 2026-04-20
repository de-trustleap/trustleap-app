import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/recommendations/domain/draft_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late MockRecommendationRepository mockRecoRepo;
  late RecommendationsAlertCubit recommendationAlertCubit;

  setUp(() {
    mockRecoRepo = MockRecommendationRepository();
    recommendationAlertCubit = RecommendationsAlertCubit(mockRecoRepo);
  });

  group("RecommendationCubit_CreateDraftRecommendation", () {
    const draft = DraftRecommendationItem(
      id: "1",
      ownerID: "owner1",
      landingPageID: "lp1",
      defaultLandingPageID: "dlp1",
      promoterName: "Tester",
      name: "Test",
      serviceProviderName: "Tester",
    );

    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockRecoRepo.createDraftRecommendation(draft))
          .thenAnswer((_) async => right(unit));
      // When
      await recommendationAlertCubit.createDraftRecommendation(draft);
      // Then
      verify(mockRecoRepo.createDraftRecommendation(draft));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should not emit any state when createDraftRecommendation is called",
        () async {
      // Given
      when(mockRecoRepo.createDraftRecommendation(draft))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(recommendationAlertCubit.stream, emitsDone);
      await recommendationAlertCubit.createDraftRecommendation(draft);
      await recommendationAlertCubit.close();
    });
  });

  group("RecommendationCubit_DeleteDraftRecommendation", () {
    const draftID = "draft1";

    test("should call deleteDraftRecommendation on repo when function is called",
        () async {
      // Given
      when(mockRecoRepo.deleteDraftRecommendation(draftID))
          .thenAnswer((_) async => right(unit));
      // When
      await recommendationAlertCubit.deleteDraftRecommendation(draftID);
      // Then
      verify(mockRecoRepo.deleteDraftRecommendation(draftID));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should not emit any state when deleteDraftRecommendation is called",
        () async {
      // Given
      when(mockRecoRepo.deleteDraftRecommendation(draftID))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(recommendationAlertCubit.stream, emitsDone);
      await recommendationAlertCubit.deleteDraftRecommendation(draftID);
      await recommendationAlertCubit.close();
    });
  });

  group("RecommendationCubit_SaveRecommendation", () {
    final userID = "1";
    final recommendation = PersonalizedRecommendationItem(
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
