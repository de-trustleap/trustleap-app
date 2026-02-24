import "package:finanzbegleiter/features/dashboard/application/recommendation/dashboard_recommendations_cubit.dart";
import "package:finanzbegleiter/constants.dart";
import "package:finanzbegleiter/core/id.dart";
import "package:finanzbegleiter/features/landing_pages/domain/landing_page.dart";
import "package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart";
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import "package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart";
import "package:finanzbegleiter/features/auth/domain/user.dart";
import "package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart";
import "package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_recommendations_helper.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:finanzbegleiter/l10n/generated/app_localizations.dart";
import "package:mockito/mockito.dart";

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get dashboard_recommendations_all_promoter => "Alle";
  
  @override
  String get dashboard_recommendations_missing_promoter_name => "Unbekannter Promoter";
  
  @override
  String get dashboard_recommendations_own_recommendations => "Eigene Empfehlungen";
  
  @override
  String dashboard_recommendations_last_24_hours(int count) {
    return "Letzte 24 Stunden: $count ${count == 1 ? 'Empfehlung' : 'Empfehlungen'}";
  }
  
  @override
  String dashboard_recommendations_last_7_days(int count) {
    return "Letzte 7 Tage: $count ${count == 1 ? 'Empfehlung' : 'Empfehlungen'}";
  }
  
  @override
  String dashboard_recommendations_last_month(int count) {
    return "Letzter Monat: $count ${count == 1 ? 'Empfehlung' : 'Empfehlungen'}";
  }
}

void main() {
  late MockAppLocalizations mockLocalizations;

  setUp(() {
    mockLocalizations = MockAppLocalizations();
  });

  group("DashboardRecommendationsHelper", () {
    group("getPromoterItems", () {
      test("should return list with \"Alle\" option first", () {
        final promoterRecommendations = <PromoterRecommendations>[];

        final result = DashboardRecommendationsHelper.getPromoterItems(
            promoterRecommendations, mockLocalizations, null);

        expect(result.length, equals(1));
        expect(result.first.value, isNull);
        expect((result.first.child as Text).data, equals("Alle"));
      });

      test("should create dropdown items for each promoter with full names",
          () {
        final promoter1 = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          firstName: "John",
          lastName: "Doe",
        );
        final promoter2 = CustomUser(
          id: UniqueID.fromUniqueString("2"),
          firstName: "Jane",
          lastName: "Smith",
        );

        final promoterRecommendations = [
          PromoterRecommendations(promoter: promoter1, recommendations: []),
          PromoterRecommendations(promoter: promoter2, recommendations: []),
        ];

        final result = DashboardRecommendationsHelper.getPromoterItems(
            promoterRecommendations, mockLocalizations, null);

        expect(result.length, equals(3)); // "Alle" + 2 promoters
        expect(result[1].value, equals("2"));
        expect((result[1].child as Text).data, equals("Jane Smith"));
        expect(result[2].value, equals("1"));
        expect((result[2].child as Text).data, equals("John Doe"));
      });

      test("should handle promoters with missing names", () {
        final promoter = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          firstName: null,
          lastName: null,
        );

        final promoterRecommendations = [
          PromoterRecommendations(promoter: promoter, recommendations: []),
        ];

        final result = DashboardRecommendationsHelper.getPromoterItems(
            promoterRecommendations, mockLocalizations, null);

        expect(result.length, equals(2));
        expect((result[1].child as Text).data, equals("Unbekannter Promoter"));
      });

      test("should handle promoters with empty names", () {
        final promoter = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          firstName: "",
          lastName: "",
        );

        final promoterRecommendations = [
          PromoterRecommendations(promoter: promoter, recommendations: []),
        ];

        final result = DashboardRecommendationsHelper.getPromoterItems(
            promoterRecommendations, mockLocalizations, null);

        expect(result.length, equals(2));
        expect((result[1].child as Text).data, equals("Unbekannter Promoter"));
      });

      test("should handle promoters with partial names", () {
        final promoter1 = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          firstName: "John",
          lastName: null,
        );
        final promoter2 = CustomUser(
          id: UniqueID.fromUniqueString("2"),
          firstName: null,
          lastName: "Doe",
        );

        final promoterRecommendations = [
          PromoterRecommendations(promoter: promoter1, recommendations: []),
          PromoterRecommendations(promoter: promoter2, recommendations: []),
        ];

        final result = DashboardRecommendationsHelper.getPromoterItems(
            promoterRecommendations, mockLocalizations, null);

        expect(result.length, equals(3));
        expect((result[1].child as Text).data, equals("Doe"));
        expect((result[2].child as Text).data, equals("John"));
      });

      test("should show 'Eigene Empfehlungen' for company user", () {
        final companyUser = CustomUser(
          id: UniqueID.fromUniqueString("company123"),
          firstName: "Company",
          lastName: "User",
        );
        final promoter = CustomUser(
          id: UniqueID.fromUniqueString("promoter456"),
          firstName: "John",
          lastName: "Doe",
        );

        final promoterRecommendations = [
          PromoterRecommendations(promoter: companyUser, recommendations: []),
          PromoterRecommendations(promoter: promoter, recommendations: []),
        ];

        final result = DashboardRecommendationsHelper.getPromoterItems(
            promoterRecommendations, mockLocalizations, "company123");

        expect(result.length, equals(3)); // "Alle" + company user + promoter
        expect((result[1].child as Text).data, equals("Eigene Empfehlungen"));
        expect((result[2].child as Text).data, equals("John Doe"));
      });
    });

    group("getFilteredRecommendations", () {
      late DashboardRecommendationsGetRecosSuccessState state;
      late List<UserRecommendation> allRecommendations;
      late List<UserRecommendation> recommendations1;
      late List<UserRecommendation> recommendations2;

      setUp(() {
        recommendations1 = [
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec1"),
            recoID: "reco1",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: null,
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec2"),
            recoID: "reco2",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: null,
          ),
        ];

        recommendations2 = [
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec3"),
            recoID: "reco3",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: null,
          ),
        ];

        allRecommendations = [...recommendations1, ...recommendations2];

        final promoter1 = CustomUser(
          id: UniqueID.fromUniqueString("promoter1"),
          firstName: "John",
          lastName: "Doe",
        );
        final promoter2 = CustomUser(
          id: UniqueID.fromUniqueString("promoter2"),
          firstName: "Jane",
          lastName: "Smith",
        );

        state = DashboardRecommendationsGetRecosSuccessState(
          recommendation: allRecommendations,
          promoterRecommendations: [
            PromoterRecommendations(
                promoter: promoter1, recommendations: recommendations1),
            PromoterRecommendations(
                promoter: promoter2, recommendations: recommendations2),
          ],
        );
      });

      test("should return all recommendations when no promoter selected", () {
        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: state,
          selectedPromoterId: null,
          userRole: Role.company,
        );

        expect(result, equals(allRecommendations));
      });

      test("should return all recommendations when user is promoter", () {
        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: state,
          selectedPromoterId: "promoter1",
          userRole: Role.promoter,
        );

        expect(result, equals(allRecommendations));
      });

      test("should return filtered recommendations for selected promoter", () {
        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: state,
          selectedPromoterId: "promoter1",
          userRole: Role.company,
        );

        expect(result, equals(recommendations1));
      });

      test("should return empty list when promoter not found", () {
        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: state,
          selectedPromoterId: "nonexistent",
          userRole: Role.company,
        );

        expect(result, isEmpty);
      });

      test("should return all recommendations when promoterRecommendations is null", () {
        final stateWithoutPromoterRecs = DashboardRecommendationsGetRecosSuccessState(
          recommendation: allRecommendations,
          promoterRecommendations: null,
        );

        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: stateWithoutPromoterRecs,
          selectedPromoterId: "promoter1",
          userRole: Role.company,
        );

        expect(result, equals(allRecommendations));
      });

      test("should filter recommendations by landing page when selected", () {
        final landingPage1 = LandingPage(
          id: UniqueID.fromUniqueString("lp1"),
          name: "Investment Page",
        );
        final landingPage2 = LandingPage(
          id: UniqueID.fromUniqueString("lp2"),
          name: "Savings Page",
        );

        final recommendationWithInvestment = UserRecommendation(
          id: UniqueID.fromUniqueString("rec1"),
          recoID: "reco1",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item1",
            name: "Test",
            reason: "Investment Page", // matches landingPage1.name
            landingPageID: "lp1",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
          ),
        );

        final recommendationWithSavings = UserRecommendation(
          id: UniqueID.fromUniqueString("rec2"),
          recoID: "reco2",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item2",
            name: "Test",
            reason: "Savings Page", // matches landingPage2.name
            landingPageID: "lp2",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
          ),
        );

        final stateWithLandingPages = DashboardRecommendationsGetRecosSuccessState(
          recommendation: [recommendationWithInvestment, recommendationWithSavings],
          promoterRecommendations: null,
          allLandingPages: [landingPage1, landingPage2],
          filteredLandingPages: [landingPage1, landingPage2],
        );

        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: stateWithLandingPages,
          selectedPromoterId: null,
          userRole: Role.promoter,
          selectedLandingPageId: "lp1",
        );

        expect(result.length, equals(1));
        expect(result.first.recommendation?.reason, equals("Investment Page"));
      });

      test("should return all recommendations when no landing page selected", () {
        final landingPage1 = LandingPage(
          id: UniqueID.fromUniqueString("lp1"),
          name: "Investment Page",
        );

        final recommendationWithInvestment = UserRecommendation(
          id: UniqueID.fromUniqueString("rec1"),
          recoID: "reco1",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item1",
            name: "Test",
            reason: "Investment Page",
            landingPageID: "lp1",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
          ),
        );

        final stateWithLandingPages = DashboardRecommendationsGetRecosSuccessState(
          recommendation: [recommendationWithInvestment],
          promoterRecommendations: null,
          allLandingPages: [landingPage1],
          filteredLandingPages: [landingPage1],
        );

        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: stateWithLandingPages,
          selectedPromoterId: null,
          userRole: Role.promoter,
          selectedLandingPageId: null, // No landing page selected
        );

        expect(result.length, equals(1));
        expect(result.first.recommendation?.reason, equals("Investment Page"));
      });

      test("should return empty list when landing page selected but no matching recommendations", () {
        final landingPage1 = LandingPage(
          id: UniqueID.fromUniqueString("lp1"),
          name: "Investment Page",
        );

        final recommendationWithDifferentReason = UserRecommendation(
          id: UniqueID.fromUniqueString("rec1"),
          recoID: "reco1",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item1",
            name: "Test",
            reason: "Different Reason", // doesn't match landingPage1.name
            landingPageID: "lp1",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
          ),
        );

        final stateWithLandingPages = DashboardRecommendationsGetRecosSuccessState(
          recommendation: [recommendationWithDifferentReason],
          promoterRecommendations: null,
          allLandingPages: [landingPage1],
          filteredLandingPages: [landingPage1],
        );

        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: stateWithLandingPages,
          selectedPromoterId: null,
          userRole: Role.promoter,
          selectedLandingPageId: "lp1",
        );

        expect(result.length, equals(0));
      });

      test("should filter by both promoter and landing page", () {
        final landingPage1 = LandingPage(
          id: UniqueID.fromUniqueString("lp1"),
          name: "Investment Page",
        );

        final promoter1 = CustomUser(
          id: UniqueID.fromUniqueString("promoter1"),
          firstName: "John",
          lastName: "Doe",
        );

        final promoter2 = CustomUser(
          id: UniqueID.fromUniqueString("promoter2"),
          firstName: "Jane",
          lastName: "Smith",
        );

        final rec1 = UserRecommendation(
          id: UniqueID.fromUniqueString("rec1"),
          recoID: "reco1",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item1",
            name: "Test",
            reason: "Investment Page",
            landingPageID: "lp1",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
          ),
        );

        final rec2 = UserRecommendation(
          id: UniqueID.fromUniqueString("rec2"),
          recoID: "reco2",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item2",
            name: "Test",
            reason: "Different Reason",
            landingPageID: "lp1",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
          ),
        );

        final rec3 = UserRecommendation(
          id: UniqueID.fromUniqueString("rec3"),
          recoID: "reco3",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item3",
            name: "Test",
            reason: "Investment Page",
            landingPageID: "lp1",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
          ),
        );

        final stateWithBothFilters = DashboardRecommendationsGetRecosSuccessState(
          recommendation: [rec1, rec2, rec3],
          promoterRecommendations: [
            PromoterRecommendations(promoter: promoter1, recommendations: [rec1, rec2]),
            PromoterRecommendations(promoter: promoter2, recommendations: [rec3]),
          ],
          allLandingPages: [landingPage1],
          filteredLandingPages: [landingPage1],
        );

        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: stateWithBothFilters,
          selectedPromoterId: "promoter1", // Filter by promoter1 first
          userRole: Role.company,
          selectedLandingPageId: "lp1", // Then filter by landing page
        );

        // Should only return rec1 (from promoter1 with matching reason)
        expect(result.length, equals(1));
        expect(result.first.id.value, equals("rec1"));
        expect(result.first.recommendation?.reason, equals("Investment Page"));
      });
    });

    group("getTimePeriodSummaryText", () {
      late DashboardRecommendationsGetRecosSuccessState state;
      late List<UserRecommendation> recommendations;

      setUp(() {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(hours: 12));
        
        recommendations = [
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec1"),
            recoID: "reco1",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: PersonalizedRecommendationItem(
              id: "item1",
              name: "Test",
              reason: "Test",
              landingPageID: "test",
              promotionTemplate: "test",
              promoterName: "Test",
              serviceProviderName: "Test",
              defaultLandingPageID: "test",
              statusLevel: StatusLevel.recommendationSend,
              statusTimestamps: {},
              userID: "user1",
              promoterImageDownloadURL: "test",
              createdAt: yesterday,
            ),
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec2"),
            recoID: "reco2",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: PersonalizedRecommendationItem(
              id: "item2",
              name: "Test",
              reason: "Test",
              landingPageID: "test",
              promotionTemplate: "test",
              promoterName: "Test",
              serviceProviderName: "Test",
              defaultLandingPageID: "test",
              statusLevel: StatusLevel.recommendationSend,
              statusTimestamps: {},
              userID: "user1",
              promoterImageDownloadURL: "test",
              createdAt: yesterday,
            ),
          ),
        ];

        state = DashboardRecommendationsGetRecosSuccessState(
          recommendation: recommendations,
          promoterRecommendations: null,
        );
      });

      test("should return correct text for day period with plural", () {
        final result = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: state,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.day,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );

        expect(result, equals("Letzte 24 Stunden: 2 Empfehlungen"));
      });

      test("should return correct text for week period with plural", () {
        final result = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: state,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.week,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );

        expect(result, equals("Letzte 7 Tage: 2 Empfehlungen"));
      });

      test("should return correct text for month period with plural", () {
        final result = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: state,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.month,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );

        expect(result, equals("Letzter Monat: 2 Empfehlungen"));
      });

      test("should return correct text for single recommendation", () {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(hours: 12));
        
        final singleRecommendation = [UserRecommendation(
          id: UniqueID.fromUniqueString("rec1"),
          recoID: "reco1",
          userID: "user1",
          priority: RecommendationPriority.medium,
  
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item1",
            name: "Test",
            reason: "Test",
            landingPageID: "test",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
            createdAt: yesterday,
          ),
        )];
        final stateWithSingleRec = DashboardRecommendationsGetRecosSuccessState(
          recommendation: singleRecommendation,
          promoterRecommendations: null,
        );

        final result = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: stateWithSingleRec,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.day,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );

        expect(result, equals("Letzte 24 Stunden: 1 Empfehlung"));
      });

      test("should return correct text for zero recommendations", () {
        final emptyState = DashboardRecommendationsGetRecosSuccessState(
          recommendation: [],
          promoterRecommendations: null,
        );

        final result = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: emptyState,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.day,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );

        expect(result, equals("Letzte 24 Stunden: 0 Empfehlungen"));
      });

      test("should filter recommendations by selected promoter for company user", () {
        final promoter1 = CustomUser(
          id: UniqueID.fromUniqueString("promoter1"),
          firstName: "John",
          lastName: "Doe",
        );
        final promoter2 = CustomUser(
          id: UniqueID.fromUniqueString("promoter2"),
          firstName: "Jane",
          lastName: "Smith",
        );

        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(hours: 12));
        
        final recommendations1 = [UserRecommendation(
          id: UniqueID.fromUniqueString("rec1"),
          recoID: "reco1",
          userID: "user1",
          priority: RecommendationPriority.medium,
  
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item1",
            name: "Test",
            reason: "Test",
            landingPageID: "test",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
            createdAt: yesterday,
          ),
        )];
        final recommendations2 = [UserRecommendation(
          id: UniqueID.fromUniqueString("rec2"),
          recoID: "reco2",
          userID: "user1",
          priority: RecommendationPriority.medium,
  
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item2",
            name: "Test",
            reason: "Test",
            landingPageID: "test",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
            createdAt: yesterday,
          ),
        )];

        final stateWithPromoters = DashboardRecommendationsGetRecosSuccessState(
          recommendation: [...recommendations1, ...recommendations2],
          promoterRecommendations: [
            PromoterRecommendations(
                promoter: promoter1, recommendations: recommendations1),
            PromoterRecommendations(
                promoter: promoter2, recommendations: recommendations2),
          ],
        );

        final result = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: stateWithPromoters,
          selectedPromoterId: "promoter1",
          userRole: Role.company,
          timePeriod: TimePeriod.day,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );

        expect(result, equals("Letzte 24 Stunden: 1 Empfehlung"));
      });

      test("should filter recommendations by time period correctly", () {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(hours: 12));
        final lastWeek = now.subtract(const Duration(days: 3));
        final lastMonth = now.subtract(const Duration(days: 20));
        final veryOld = now.subtract(const Duration(days: 60));

        final recommendationsWithTime = [
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec1"),
            recoID: "reco1",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: PersonalizedRecommendationItem(
              id: "item1",
              name: "Test",
              reason: "Test",
              landingPageID: "test",
              promotionTemplate: "test",
              promoterName: "Test",
              serviceProviderName: "Test",
              defaultLandingPageID: "test",
              statusLevel: StatusLevel.recommendationSend,
              statusTimestamps: {},
              userID: "user1",
              promoterImageDownloadURL: "test",
              createdAt: yesterday,
            ),
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec2"),
            recoID: "reco2",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: PersonalizedRecommendationItem(
              id: "item2",
              name: "Test",
              reason: "Test",
              landingPageID: "test",
              promotionTemplate: "test",
              promoterName: "Test",
              serviceProviderName: "Test",
              defaultLandingPageID: "test",
              statusLevel: StatusLevel.recommendationSend,
              statusTimestamps: {},
              userID: "user1",
              promoterImageDownloadURL: "test",
              createdAt: lastWeek,
            ),
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec3"),
            recoID: "reco3",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: PersonalizedRecommendationItem(
              id: "item3",
              name: "Test",
              reason: "Test",
              landingPageID: "test",
              promotionTemplate: "test",
              promoterName: "Test",
              serviceProviderName: "Test",
              defaultLandingPageID: "test",
              statusLevel: StatusLevel.recommendationSend,
              statusTimestamps: {},
              userID: "user1",
              promoterImageDownloadURL: "test",
              createdAt: lastMonth,
            ),
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec4"),
            recoID: "reco4",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            recommendation: PersonalizedRecommendationItem(
              id: "item4",
              name: "Test",
              reason: "Test",
              landingPageID: "test",
              promotionTemplate: "test",
              promoterName: "Test",
              serviceProviderName: "Test",
              defaultLandingPageID: "test",
              statusLevel: StatusLevel.recommendationSend,
              statusTimestamps: {},
              userID: "user1",
              promoterImageDownloadURL: "test",
              createdAt: veryOld,
            ),
          ),
        ];

        final stateWithTimeFiltering = DashboardRecommendationsGetRecosSuccessState(
          recommendation: recommendationsWithTime,
          promoterRecommendations: null,
        );

        // Test day period - should include yesterday
        final dayResult = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: stateWithTimeFiltering,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.day,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );
        expect(dayResult, equals("Letzte 24 Stunden: 1 Empfehlung"));

        // Test week period - should include yesterday and last week
        final weekResult = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: stateWithTimeFiltering,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.week,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );
        expect(weekResult, equals("Letzte 7 Tage: 2 Empfehlungen"));

        // Test month period - should include all except very old
        final monthResult = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: stateWithTimeFiltering,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.month,
          localization: mockLocalizations,
          selectedLandingPageId: null,
        );
        expect(monthResult, equals("Letzter Monat: 3 Empfehlungen"));
      });

      test("should filter by landing page in summary text", () {
        final landingPage1 = LandingPage(
          id: UniqueID.fromUniqueString("lp1"),
          name: "Investment Page",
        );

        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(hours: 12));

        final recommendationWithMatchingReason = UserRecommendation(
          id: UniqueID.fromUniqueString("rec1"),
          recoID: "reco1",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item1",
            name: "Test",
            reason: "Investment Page", // matches landingPage1.name
            landingPageID: "lp1",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
            createdAt: yesterday,
          ),
        );

        final recommendationWithDifferentReason = UserRecommendation(
          id: UniqueID.fromUniqueString("rec2"),
          recoID: "reco2",
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: "item2",
            name: "Test",
            reason: "Different Reason", // doesn't match landingPage1.name
            landingPageID: "lp1",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
            createdAt: yesterday,
          ),
        );

        final stateWithLandingPageFiltering = DashboardRecommendationsGetRecosSuccessState(
          recommendation: [recommendationWithMatchingReason, recommendationWithDifferentReason],
          promoterRecommendations: null,
          allLandingPages: [landingPage1],
          filteredLandingPages: [landingPage1],
        );

        final result = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: stateWithLandingPageFiltering,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.day,
          localization: mockLocalizations,
          selectedLandingPageId: "lp1", // Filter by landing page
        );

        // Should only count the recommendation with matching reason
        expect(result, equals("Letzte 24 Stunden: 1 Empfehlung"));
      });
    });

    group("calculateTrend", () {
      late DashboardRecommendationsGetRecosSuccessState state;
      late DateTime now;

      setUp(() {
        now = DateTime(2024, 1, 15, 12, 0, 0); // Fixed time for consistent tests
      });

      UserRecommendation createRecommendation({
        required String id,
        required DateTime createdAt,
        StatusLevel statusLevel = StatusLevel.recommendationSend,
      }) {
        return UserRecommendation(
          id: UniqueID.fromUniqueString(id),
          recoID: id,
          userID: "user1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: PersonalizedRecommendationItem(
            id: id,
            name: "Test",
            reason: "Test",
            landingPageID: "test",
            promotionTemplate: "test",
            promoterName: "Test",
            serviceProviderName: "Test",
            defaultLandingPageID: "test",
            statusLevel: statusLevel,
            statusTimestamps: {},
            userID: "user1",
            promoterImageDownloadURL: "test",
            createdAt: createdAt,
          ),
        );
      }

      group("Day period", () {
        test("should calculate positive trend when current period has more recommendations", () {
          final recommendations = [
            // Current period (last 24 hours): 3 recommendations
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(hours: 2))),
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 12))),
            createRecommendation(id: "rec3", createdAt: now.subtract(Duration(hours: 20))),
            // Previous period (24-48 hours ago): 2 recommendations
            createRecommendation(id: "rec4", createdAt: now.subtract(Duration(hours: 30))),
            createRecommendation(id: "rec5", createdAt: now.subtract(Duration(hours: 40))),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            now: now,
          );

          expect(result.currentPeriodCount, equals(3));
          expect(result.previousPeriodCount, equals(2));
          expect(result.percentageChange, equals(50.0)); // (3-2)/2 * 100 = 50%
          expect(result.isIncreasing, isTrue);
          expect(result.isDecreasing, isFalse);
          expect(result.isStable, isFalse);
        });

        test("should calculate negative trend when current period has fewer recommendations", () {
          final recommendations = [
            // Current period (last 24 hours): 1 recommendation
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(hours: 12))),
            // Previous period (24-48 hours ago): 3 recommendations
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 30))),
            createRecommendation(id: "rec3", createdAt: now.subtract(Duration(hours: 36))),
            createRecommendation(id: "rec4", createdAt: now.subtract(Duration(hours: 42))),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            now: now,
          );

          expect(result.currentPeriodCount, equals(1));
          expect(result.previousPeriodCount, equals(3));
          expect(result.percentageChange, closeTo(-66.67, 0.01)); // (1-3)/3 * 100 = -66.67%
          expect(result.isIncreasing, isFalse);
          expect(result.isDecreasing, isTrue);
          expect(result.isStable, isFalse);
        });

        test("should calculate zero trend when both periods have same count", () {
          final recommendations = [
            // Current period (last 24 hours): 2 recommendations
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(hours: 6))),
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 18))),
            // Previous period (24-48 hours ago): 2 recommendations
            createRecommendation(id: "rec3", createdAt: now.subtract(Duration(hours: 30))),
            createRecommendation(id: "rec4", createdAt: now.subtract(Duration(hours: 42))),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            now: now,
          );

          expect(result.currentPeriodCount, equals(2));
          expect(result.previousPeriodCount, equals(2));
          expect(result.percentageChange, equals(0.0));
          expect(result.isIncreasing, isFalse);
          expect(result.isDecreasing, isFalse);
          expect(result.isStable, isTrue);
        });
      });

      group("Week period", () {
        test("should calculate trend for weekly data", () {
          final recommendations = [
            // Current period (last 7 days): 4 recommendations
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(days: 1))),
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(days: 3))),
            createRecommendation(id: "rec3", createdAt: now.subtract(Duration(days: 5))),
            createRecommendation(id: "rec4", createdAt: now.subtract(Duration(days: 6))),
            // Previous period (7-14 days ago): 2 recommendations
            createRecommendation(id: "rec5", createdAt: now.subtract(Duration(days: 9))),
            createRecommendation(id: "rec6", createdAt: now.subtract(Duration(days: 12))),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.week,
            now: now,
          );

          expect(result.currentPeriodCount, equals(4));
          expect(result.previousPeriodCount, equals(2));
          expect(result.percentageChange, equals(100.0)); // (4-2)/2 * 100 = 100%
          expect(result.isIncreasing, isTrue);
        });
      });

      group("Month period", () {
        test("should calculate trend for monthly data", () {
          final recommendations = [
            // Current month: 3 recommendations
            createRecommendation(id: "rec1", createdAt: DateTime(2024, 1, 5)),
            createRecommendation(id: "rec2", createdAt: DateTime(2024, 1, 10)),
            createRecommendation(id: "rec3", createdAt: DateTime(2024, 1, 14)),
            // Previous month: 1 recommendation
            createRecommendation(id: "rec4", createdAt: DateTime(2023, 12, 15)),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.month,
            now: now,
          );

          expect(result.currentPeriodCount, equals(3));
          expect(result.previousPeriodCount, equals(1));
          expect(result.percentageChange, equals(200.0)); // (3-1)/1 * 100 = 200%
          expect(result.isIncreasing, isTrue);
        });
      });

      group("Status level filtering", () {
        test("should filter recommendations by status level for active recommendations", () {
          final recommendations = [
            // Current period
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(hours: 12)), statusLevel: StatusLevel.recommendationSend), // index 0
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 12)), statusLevel: StatusLevel.linkClicked),        // index 1
            createRecommendation(id: "rec3", createdAt: now.subtract(Duration(hours: 12)), statusLevel: StatusLevel.contactFormSent),    // index 2
            // Previous period
            createRecommendation(id: "rec4", createdAt: now.subtract(Duration(hours: 36)), statusLevel: StatusLevel.recommendationSend), // index 0
            createRecommendation(id: "rec5", createdAt: now.subtract(Duration(hours: 36)), statusLevel: StatusLevel.linkClicked),        // index 1
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          // Test filtering for statusLevel 2 - should include statusLevel <= 2
          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            statusLevel: 2,
            now: now,
          );

          expect(result.currentPeriodCount, equals(2)); // rec1 (0) + rec2 (1) 
          expect(result.previousPeriodCount, equals(2)); // rec4 (0) + rec5 (1)
          expect(result.percentageChange, equals(0.0));
        });

        test("should include archived recommendations (successful/failed) for all status levels", () {
          final recommendations = [
            // Current period - mix of active and archived
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(hours: 12)), statusLevel: StatusLevel.recommendationSend),
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 12)), statusLevel: StatusLevel.successful), // archived
            createRecommendation(id: "rec3", createdAt: now.subtract(Duration(hours: 12)), statusLevel: StatusLevel.failed),     // archived
            // Previous period
            createRecommendation(id: "rec4", createdAt: now.subtract(Duration(hours: 36)), statusLevel: StatusLevel.successful), // archived
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          // Test with statusLevel 1 (recommendationSend) - should include archived recs
          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            statusLevel: 1,
            now: now,
          );

          expect(result.currentPeriodCount, equals(3)); // rec1 (matching level) + rec2 (archived) + rec3 (archived)
          expect(result.previousPeriodCount, equals(1)); // rec4 (archived)
          expect(result.percentageChange, equals(200.0)); // (3-1)/1 * 100 = 200%
        });
      });

      group("Edge cases", () {
        test("should handle empty recommendations list", () {
          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: [],
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            now: now,
          );

          expect(result.currentPeriodCount, equals(0));
          expect(result.previousPeriodCount, equals(0));
          expect(result.percentageChange, equals(0.0));
          expect(result.isStable, isTrue);
        });

        test("should handle zero previous count with positive current count (200% increase)", () {
          final recommendations = [
            // Current period: 2 recommendations
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(hours: 12))),
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 18))),
            // Previous period: 0 recommendations (no data)
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            now: now,
          );

          expect(result.currentPeriodCount, equals(2));
          expect(result.previousPeriodCount, equals(0));
          expect(result.percentageChange, equals(200.0)); // 2 recommendations * 100% = 200%
          expect(result.isIncreasing, isTrue);
        });

        test("should handle zero current count with positive previous count (negative trend)", () {
          final recommendations = [
            // Current period: 0 recommendations
            // Previous period: 3 recommendations
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(hours: 30))),
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 36))),
            createRecommendation(id: "rec3", createdAt: now.subtract(Duration(hours: 42))),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            now: now,
          );

          expect(result.currentPeriodCount, equals(0));
          expect(result.previousPeriodCount, equals(3));
          expect(result.percentageChange, equals(-100.0)); // (0-3)/3 * 100 = -100%
          expect(result.isDecreasing, isTrue);
        });

        test("should handle recommendations with null createdAt", () {
          final recommendationsWithNullDate = [
            UserRecommendation(
              id: UniqueID.fromUniqueString("rec1"),
              recoID: "rec1",
              userID: "user1",
              priority: RecommendationPriority.medium,
              notes: "Test",
              recommendation: null, // null recommendation
            ),
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 12))),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendationsWithNullDate,
            promoterRecommendations: null,
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            now: now,
          );

          expect(result.currentPeriodCount, equals(1)); // Only rec2 counted
          expect(result.previousPeriodCount, equals(0));
          expect(result.percentageChange, equals(100.0));
        });
      });

      group("Promoter filtering", () {
        test("should filter by selected promoter for company user", () {
          final promoter1 = CustomUser(
            id: UniqueID.fromUniqueString("promoter1"),
            firstName: "John",
            lastName: "Doe",
          );
          final promoter2 = CustomUser(
            id: UniqueID.fromUniqueString("promoter2"),
            firstName: "Jane",
            lastName: "Smith",
          );

          final promoter1Recs = [
            createRecommendation(id: "rec1", createdAt: now.subtract(Duration(hours: 12))),
            createRecommendation(id: "rec2", createdAt: now.subtract(Duration(hours: 36))),
          ];
          final promoter2Recs = [
            createRecommendation(id: "rec3", createdAt: now.subtract(Duration(hours: 6))),
            createRecommendation(id: "rec4", createdAt: now.subtract(Duration(hours: 30))),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: [...promoter1Recs, ...promoter2Recs],
            promoterRecommendations: [
              PromoterRecommendations(promoter: promoter1, recommendations: promoter1Recs),
              PromoterRecommendations(promoter: promoter2, recommendations: promoter2Recs),
            ],
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: "promoter1",
            userRole: Role.company,
            timePeriod: TimePeriod.day,
            now: now,
          );

          expect(result.currentPeriodCount, equals(1)); // Only rec1 from promoter1
          expect(result.previousPeriodCount, equals(1)); // Only rec2 from promoter1
          expect(result.percentageChange, equals(0.0));
        });
      });

      group("Landing page filtering", () {
        test("should filter by selected landing page", () {
          final landingPage1 = LandingPage(
            id: UniqueID.fromUniqueString("lp1"),
            name: "Investment Page",
          );

          final recommendations = [
            UserRecommendation(
              id: UniqueID.fromUniqueString("rec1"),
              recoID: "rec1",
              userID: "user1",
              priority: RecommendationPriority.medium,
              notes: "Test",
              recommendation: PersonalizedRecommendationItem(
                id: "rec1",
                name: "Test",
                reason: "Investment Page", // matches landingPage1.name
                landingPageID: "lp1",
                promotionTemplate: "test",
                promoterName: "Test",
                serviceProviderName: "Test",
                defaultLandingPageID: "test",
                statusLevel: StatusLevel.recommendationSend,
                statusTimestamps: {},
                userID: "user1",
                promoterImageDownloadURL: "test",
                createdAt: now.subtract(Duration(hours: 12)),
              ),
            ),
            UserRecommendation(
              id: UniqueID.fromUniqueString("rec2"),
              recoID: "rec2",
              userID: "user1",
              priority: RecommendationPriority.medium,
              notes: "Test",
              recommendation: PersonalizedRecommendationItem(
                id: "rec2",
                name: "Test",
                reason: "Different Page", // doesn't match
                landingPageID: "lp2",
                promotionTemplate: "test",
                promoterName: "Test",
                serviceProviderName: "Test",
                defaultLandingPageID: "test",
                statusLevel: StatusLevel.recommendationSend,
                statusTimestamps: {},
                userID: "user1",
                promoterImageDownloadURL: "test",
                createdAt: now.subtract(Duration(hours: 36)),
              ),
            ),
          ];

          state = DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations,
            promoterRecommendations: null,
            allLandingPages: [landingPage1],
            filteredLandingPages: [landingPage1],
          );

          final result = DashboardRecommendationsHelper.calculateTrend(
            state: state,
            selectedPromoterId: null,
            userRole: Role.promoter,
            timePeriod: TimePeriod.day,
            selectedLandingPageId: "lp1",
            now: now,
          );

          expect(result.currentPeriodCount, equals(1)); // Only rec1 matches landing page
          expect(result.previousPeriodCount, equals(0)); // rec2 doesn't match
          expect(result.percentageChange, equals(100.0));
        });
      });
    });
  });
}