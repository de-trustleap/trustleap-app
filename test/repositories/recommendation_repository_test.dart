import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockRecommendationRepository mockRecoRepo;

  setUp(() {
    mockRecoRepo = MockRecommendationRepository();
  });

  group("RecommendationRepositoryImplementation_SaveRecommendation", () {
    final userID = "1";
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Page1",
        landingPageID: "2",
        promotionTemplate: "Test",
        promoterName: "Tester",
        serviceProviderName: "Tester",
        defaultLandingPageID: "3",
        statusLevel: 0,
        statusTimestamps: null);

    test("should return unit when saving of recommendation was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockRecoRepo.saveRecommendation(recommendation, userID))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockRecoRepo.saveRecommendation(recommendation, userID);
      // Then
      verify(mockRecoRepo.saveRecommendation(recommendation, userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.saveRecommendation(recommendation, userID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockRecoRepo.saveRecommendation(recommendation, userID);
      // Then
      verify(mockRecoRepo.saveRecommendation(recommendation, userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });
}
