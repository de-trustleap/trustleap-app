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
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Page1",
        landingPageID: "2",
        promotionTemplate: "Test",
        promoterName: "Tester",
        serviceProviderName: "Tester",
        defaultLandingPageID: "3");

    test("should return unit when saving of recommendation was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockRecoRepo.saveRecommendation(recommendation))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockRecoRepo.saveRecommendation(recommendation);
      // Then
      verify(mockRecoRepo.saveRecommendation(recommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.saveRecommendation(recommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.saveRecommendation(recommendation);
      // Then
      verify(mockRecoRepo.saveRecommendation(recommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });
}
