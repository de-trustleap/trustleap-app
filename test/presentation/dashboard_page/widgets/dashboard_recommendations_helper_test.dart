import "package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart";
import "package:finanzbegleiter/constants.dart";
import "package:finanzbegleiter/domain/entities/id.dart";
import "package:finanzbegleiter/domain/entities/promoter_recommendations.dart";
import "package:finanzbegleiter/domain/entities/recommendation_item.dart";
import "package:finanzbegleiter/domain/entities/user.dart";
import "package:finanzbegleiter/domain/entities/user_recommendation.dart";
import "package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations_helper.dart";
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
            notesLastEdited: null,
            recommendation: null,
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec2"),
            recoID: "reco2",
            userID: "user1",
            priority: RecommendationPriority.medium,
    
            notes: "Test",
            notesLastEdited: null,
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
            notesLastEdited: null,
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
            notesLastEdited: null,
            recommendation: RecommendationItem(
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
            notesLastEdited: null,
            recommendation: RecommendationItem(
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
          notesLastEdited: null,
          recommendation: RecommendationItem(
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
          notesLastEdited: null,
          recommendation: RecommendationItem(
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
          notesLastEdited: null,
          recommendation: RecommendationItem(
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
            notesLastEdited: null,
            recommendation: RecommendationItem(
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
            notesLastEdited: null,
            recommendation: RecommendationItem(
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
            notesLastEdited: null,
            recommendation: RecommendationItem(
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
            notesLastEdited: null,
            recommendation: RecommendationItem(
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
        );
        expect(dayResult, equals("Letzte 24 Stunden: 1 Empfehlung"));

        // Test week period - should include yesterday and last week
        final weekResult = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: stateWithTimeFiltering,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.week,
          localization: mockLocalizations,
        );
        expect(weekResult, equals("Letzte 7 Tage: 2 Empfehlungen"));

        // Test month period - should include all except very old
        final monthResult = DashboardRecommendationsHelper.getTimePeriodSummaryText(
          state: stateWithTimeFiltering,
          selectedPromoterId: null,
          userRole: Role.promoter,
          timePeriod: TimePeriod.month,
          localization: mockLocalizations,
        );
        expect(monthResult, equals("Letzter Monat: 3 Empfehlungen"));
      });
    });
  });
}