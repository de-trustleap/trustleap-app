import 'package:finanzbegleiter/features/recommendations/domain/draft_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("DraftRecommendationItem_Props", () {
    test("two instances with same values should be equal", () {
      // Given
      final draft1 = DraftRecommendationItem(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      final draft2 = DraftRecommendationItem(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      // Then
      expect(draft1, draft2);
    });

    test("two instances with different ids should not be equal", () {
      // Given
      final draft1 = DraftRecommendationItem(
        id: "1",
        ownerID: "owner1",
      );
      final draft2 = DraftRecommendationItem(
        id: "2",
        ownerID: "owner1",
      );
      // Then
      expect(draft1, isNot(draft2));
    });
  });

  group("DraftRecommendationItem_FromRecommendationItem", () {
    final recommendation = PersonalizedRecommendationItem(
      id: "reco1",
      name: "Max Mustermann",
      reason: "Page1",
      landingPageID: "lp1",
      promotionTemplate: "Template",
      promoterName: "Promoter",
      serviceProviderName: "Provider",
      defaultLandingPageID: "dlp1",
      userID: "user1",
      statusLevel: StatusLevel.recommendationSend,
      statusTimestamps: null,
      promoterImageDownloadURL: null,
    );

    test("fromRecommendationItem maps all fields correctly", () {
      // Given
      const ownerID = "owner1";
      final expectedResult = DraftRecommendationItem(
        id: "reco1",
        ownerID: ownerID,
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Max Mustermann",
        serviceProviderName: "Provider",
      );
      // When
      final result = DraftRecommendationItem.fromRecommendationItem(
        recommendation,
        ownerID: ownerID,
      );
      // Then
      expect(result, expectedResult);
    });

    test("fromRecommendationItem uses provided ownerID, not recommendation userID", () {
      // Given
      const ownerID = "differentOwner";
      // When
      final result = DraftRecommendationItem.fromRecommendationItem(
        recommendation,
        ownerID: ownerID,
      );
      // Then
      expect(result.ownerID, ownerID);
    });

    test("fromRecommendationItem maps displayName to name", () {
      // When
      final result = DraftRecommendationItem.fromRecommendationItem(
        recommendation,
        ownerID: "owner1",
      );
      // Then
      expect(result.name, recommendation.displayName);
    });

    test("optional fields are null when recommendation has no landingPageID", () {
      // Given
      final recoWithoutOptionals = PersonalizedRecommendationItem(
        id: "reco2",
        name: "Test",
        reason: null,
        landingPageID: null,
        promotionTemplate: null,
        promoterName: null,
        serviceProviderName: null,
        defaultLandingPageID: null,
        userID: "user1",
        statusLevel: StatusLevel.recommendationSend,
        statusTimestamps: null,
        promoterImageDownloadURL: null,
      );
      // When
      final result = DraftRecommendationItem.fromRecommendationItem(
        recoWithoutOptionals,
        ownerID: "owner1",
      );
      // Then
      expect(result.landingPageID, isNull);
      expect(result.defaultLandingPageID, isNull);
      expect(result.promoterName, isNull);
      expect(result.serviceProviderName, isNull);
    });
  });
}
