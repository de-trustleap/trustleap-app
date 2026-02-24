import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("RecommendationItem_CopyWith", () {
    test("set name with copyWith should set name for resulting object", () {
      // Given
      final recoItem = PersonalizedRecommendationItem(
          id: "1",
          name: "Test",
          reason: "Page1",
          landingPageID: "2",
          promotionTemplate: "Test",
          promoterName: "Tester",
          serviceProviderName: "Tester",
          statusLevel: StatusLevel.recommendationSend,
          statusTimestamps: null,
          defaultLandingPageID: "3",
          userID: "1",
          promoterImageDownloadURL: null,
          lastUpdated: null);
      final expectedResult = PersonalizedRecommendationItem(
          id: "1",
          name: "Test Neu",
          reason: "Page1",
          landingPageID: "2",
          promotionTemplate: "Test",
          promoterName: "Tester",
          serviceProviderName: "Tester",
          statusLevel: StatusLevel.recommendationSend,
          statusTimestamps: null,
          defaultLandingPageID: "3",
          userID: "1",
          promoterImageDownloadURL: null,
          lastUpdated: null);
      // When
      final result = recoItem.copyWith(name: "Test Neu");
      // Then
      expect(result, expectedResult);
    });
  });

  group("RecommendationItem_Props", () {
    test("check if value equality works", () {
      // Given
      final recoItem1 = PersonalizedRecommendationItem(
          id: "1",
          name: "Test",
          reason: "Page1",
          landingPageID: "2",
          promotionTemplate: "Test",
          promoterName: "Tester",
          serviceProviderName: "Tester",
          statusLevel: StatusLevel.recommendationSend,
          statusTimestamps: null,
          defaultLandingPageID: "3",
          userID: "1",
          promoterImageDownloadURL: null,
          lastUpdated: null);
      final recoItem2 = PersonalizedRecommendationItem(
          id: "1",
          name: "Test",
          reason: "Page1",
          landingPageID: "2",
          promotionTemplate: "Test",
          promoterName: "Tester",
          serviceProviderName: "Tester",
          statusLevel: StatusLevel.recommendationSend,
          statusTimestamps: null,
          defaultLandingPageID: "3",
          userID: "1",
          promoterImageDownloadURL: null,
          lastUpdated: null);
      // Then
      expect(recoItem2, recoItem1);
    });
  });
}
