import "package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart";
import "package:finanzbegleiter/constants.dart";
import "package:finanzbegleiter/domain/entities/id.dart";
import "package:finanzbegleiter/domain/entities/promoter_recommendations.dart";
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
            promoterRecommendations, mockLocalizations);

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
            promoterRecommendations, mockLocalizations);

        expect(result.length, equals(3)); // "Alle" + 2 promoters
        expect(result[1].value, equals("1"));
        expect((result[1].child as Text).data, equals("John Doe"));
        expect(result[2].value, equals("2"));
        expect((result[2].child as Text).data, equals("Jane Smith"));
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
            promoterRecommendations, mockLocalizations);

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
            promoterRecommendations, mockLocalizations);

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
            promoterRecommendations, mockLocalizations);

        expect(result.length, equals(3));
        expect((result[1].child as Text).data, equals("John"));
        expect((result[2].child as Text).data, equals("Doe"));
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
            isFavorite: false,
            notes: "Test",
            notesLastEdited: null,
            recommendation: null,
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec2"),
            recoID: "reco2",
            userID: "user1",
            priority: RecommendationPriority.medium,
            isFavorite: false,
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
            isFavorite: false,
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
  });
}