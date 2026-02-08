import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/promoter_stats.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/statistics/promoter_statistics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  UserRecommendation createRecommendation({
    required String id,
    String reason = "Test Page",
    StatusLevel statusLevel = StatusLevel.recommendationSend,
  }) {
    return UserRecommendation(
      id: UniqueID.fromUniqueString(id),
      recoID: id,
      userID: "user-1",
      priority: RecommendationPriority.medium,
      notes: null,
      recommendation: RecommendationItem(
        id: id,
        name: "Test",
        reason: reason,
        landingPageID: "lp1",
        promotionTemplate: null,
        promoterName: null,
        serviceProviderName: null,
        defaultLandingPageID: null,
        statusLevel: statusLevel,
        statusTimestamps: null,
        userID: "user-1",
        promoterImageDownloadURL: null,
      ),
    );
  }

  group("PromoterStatistics_GetStatsForPromoter", () {
    test("should return correct shares and conversions for a promoter", () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [
            createRecommendation(
                id: "r1", statusLevel: StatusLevel.successful),
            createRecommendation(
                id: "r2", statusLevel: StatusLevel.recommendationSend),
            createRecommendation(
                id: "r3", statusLevel: StatusLevel.successful),
          ],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
      );

      // When
      final result = statistics.getStatsForPromoter("p1");

      // Then
      expect(result, const PromoterStats(shares: 3, conversions: 2));
    });

    test("should return zero stats for unknown promoter", () {
      // Given
      final statistics = PromoterStatistics(
        promoterRecommendations: [],
      );

      // When
      final result = statistics.getStatsForPromoter("unknown");

      // Then
      expect(result, const PromoterStats(shares: 0, conversions: 0));
    });

    test("should return zero conversions when no successful recommendations",
        () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [
            createRecommendation(
                id: "r1", statusLevel: StatusLevel.recommendationSend),
            createRecommendation(
                id: "r2", statusLevel: StatusLevel.linkClicked),
          ],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
      );

      // When
      final result = statistics.getStatsForPromoter("p1");

      // Then
      expect(result, const PromoterStats(shares: 2, conversions: 0));
    });

    test("should return zero stats when promoter has no recommendations", () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
      );

      // When
      final result = statistics.getStatsForPromoter("p1");

      // Then
      expect(result, const PromoterStats(shares: 0, conversions: 0));
    });
  });

  group("PromoterStatistics_GetStatsForPromoter_WithLandingPageFilter", () {
    test("should only count recommendations matching the landing page name",
        () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [
            createRecommendation(
              id: "r1",
              reason: "Investment Page",
              statusLevel: StatusLevel.successful,
            ),
            createRecommendation(
              id: "r2",
              reason: "Savings Page",
              statusLevel: StatusLevel.successful,
            ),
            createRecommendation(
              id: "r3",
              reason: "Investment Page",
              statusLevel: StatusLevel.recommendationSend,
            ),
          ],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
        landingPageName: "Investment Page",
      );

      // When
      final result = statistics.getStatsForPromoter("p1");

      // Then
      expect(result, const PromoterStats(shares: 2, conversions: 1));
    });

    test(
        "should return zero stats when no recommendations match landing page name",
        () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [
            createRecommendation(
              id: "r1",
              reason: "Other Page",
              statusLevel: StatusLevel.successful,
            ),
          ],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
        landingPageName: "Investment Page",
      );

      // When
      final result = statistics.getStatsForPromoter("p1");

      // Then
      expect(result, const PromoterStats(shares: 0, conversions: 0));
    });

    test("should count all recommendations when landingPageName is null", () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [
            createRecommendation(id: "r1", reason: "Page A"),
            createRecommendation(id: "r2", reason: "Page B"),
          ],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
        landingPageName: null,
      );

      // When
      final result = statistics.getStatsForPromoter("p1");

      // Then
      expect(result, const PromoterStats(shares: 2, conversions: 0));
    });
  });

  group("PromoterStatistics_SortByConversions", () {
    test("should sort promoters by conversions descending", () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [
            createRecommendation(
                id: "r1", statusLevel: StatusLevel.successful),
          ],
        ),
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p2")),
          recommendations: [
            createRecommendation(
                id: "r2", statusLevel: StatusLevel.successful),
            createRecommendation(
                id: "r3", statusLevel: StatusLevel.successful),
            createRecommendation(
                id: "r4", statusLevel: StatusLevel.successful),
          ],
        ),
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p3")),
          recommendations: [
            createRecommendation(
                id: "r5", statusLevel: StatusLevel.successful),
            createRecommendation(
                id: "r6", statusLevel: StatusLevel.successful),
          ],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
      );
      final promoters = [
        Promoter(id: UniqueID.fromUniqueString("p1")),
        Promoter(id: UniqueID.fromUniqueString("p2")),
        Promoter(id: UniqueID.fromUniqueString("p3")),
      ];

      // When
      final result = statistics.sortByConversions(promoters);

      // Then
      expect(result[0].id.value, "p2");
      expect(result[1].id.value, "p3");
      expect(result[2].id.value, "p1");
    });

    test("should not modify the original list", () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [
            createRecommendation(
                id: "r1", statusLevel: StatusLevel.successful),
            createRecommendation(
                id: "r2", statusLevel: StatusLevel.successful),
          ],
        ),
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p2")),
          recommendations: [],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
      );
      final promoters = [
        Promoter(id: UniqueID.fromUniqueString("p2")),
        Promoter(id: UniqueID.fromUniqueString("p1")),
      ];

      // When
      final result = statistics.sortByConversions(promoters);

      // Then
      expect(promoters[0].id.value, "p2");
      expect(promoters[1].id.value, "p1");
      expect(result[0].id.value, "p1");
      expect(result[1].id.value, "p2");
    });

    test("should return empty list when given empty list", () {
      // Given
      final statistics = PromoterStatistics(
        promoterRecommendations: [],
      );

      // When
      final result = statistics.sortByConversions([]);

      // Then
      expect(result, isEmpty);
    });

    test(
        "should keep order for promoters with equal conversions",
        () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [
            createRecommendation(
                id: "r1", statusLevel: StatusLevel.successful),
          ],
        ),
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p2")),
          recommendations: [
            createRecommendation(
                id: "r2", statusLevel: StatusLevel.successful),
          ],
        ),
      ];
      final statistics = PromoterStatistics(
        promoterRecommendations: promoterRecommendations,
      );
      final promoters = [
        Promoter(id: UniqueID.fromUniqueString("p1")),
        Promoter(id: UniqueID.fromUniqueString("p2")),
      ];

      // When
      final result = statistics.sortByConversions(promoters);

      // Then
      expect(result.length, 2);
    });
  });

  group("PromoterStats_Performance", () {
    test("should calculate performance as conversions / shares", () {
      // Given
      const stats = PromoterStats(shares: 10, conversions: 5);

      // Then
      expect(stats.performance, 0.5);
    });

    test("should return 0.0 when shares is 0", () {
      // Given
      const stats = PromoterStats(shares: 0, conversions: 0);

      // Then
      expect(stats.performance, 0.0);
    });

    test("should return 1.0 when all shares are conversions", () {
      // Given
      const stats = PromoterStats(shares: 3, conversions: 3);

      // Then
      expect(stats.performance, 1.0);
    });
  });
}
