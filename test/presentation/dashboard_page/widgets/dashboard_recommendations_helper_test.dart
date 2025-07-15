import "package:finanzbegleiter/application/dashboard/overview/cubit/dashboard_recommendations_cubit.dart";
import "package:finanzbegleiter/constants.dart";
import "package:finanzbegleiter/domain/entities/id.dart";
import "package:finanzbegleiter/domain/entities/promoter_recommendations.dart";
import "package:finanzbegleiter/domain/entities/recommendation_item.dart";
import "package:finanzbegleiter/domain/entities/user.dart";
import "package:finanzbegleiter/domain/entities/user_recommendation.dart";
import "package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations_helper.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("DashboardRecommendationsHelper", () {
    group("getPromoterDisplayName", () {
      test("should return full name when both first and last name are provided", () {
        final result = DashboardRecommendationsHelper.getPromoterDisplayName("John", "Doe");
        expect(result, equals("John Doe"));
      });

      test("should return first name only when last name is null", () {
        final result = DashboardRecommendationsHelper.getPromoterDisplayName("John", null);
        expect(result, equals("John"));
      });

      test("should return last name only when first name is null", () {
        final result = DashboardRecommendationsHelper.getPromoterDisplayName(null, "Doe");
        expect(result, equals("Doe"));
      });

      test("should return fallback when both names are null", () {
        final result = DashboardRecommendationsHelper.getPromoterDisplayName(null, null);
        expect(result, equals("Unbekannter Promoter"));
      });

      test("should return fallback when both names are empty", () {
        final result = DashboardRecommendationsHelper.getPromoterDisplayName("", "");
        expect(result, equals("Unbekannter Promoter"));
      });

      test("should handle whitespace properly", () {
        final result = DashboardRecommendationsHelper.getPromoterDisplayName("  John  ", "  Doe  ");
        expect(result, equals("John     Doe"));
      });
    });

    group("getPromoterItems", () {
      test("should return list with \"Alle\" option first", () {
        final promoterRecommendations = <PromoterRecommendations>[];
        
        final result = DashboardRecommendationsHelper.getPromoterItems(promoterRecommendations);
        
        expect(result.length, equals(1));
        expect(result.first.value, isNull);
        expect((result.first.child as Text).data, equals("Alle"));
      });

      test("should create dropdown items for each promoter with full names", () {
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
        
        final result = DashboardRecommendationsHelper.getPromoterItems(promoterRecommendations);
        
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
        
        final result = DashboardRecommendationsHelper.getPromoterItems(promoterRecommendations);
        
        expect(result.length, equals(2));
        expect((result[1].child as Text).data, equals("Unbekannter Promoter"));
      });
    });

    group("getFilteredRecommendations", () {
      late CustomUser promoter1;
      late CustomUser promoter2;
      late List<UserRecommendation> recommendations1;
      late List<UserRecommendation> recommendations2;
      late List<UserRecommendation> allRecommendations;
      late DashboardRecommendationsGetRecosSuccessState state;

      setUp(() {
        promoter1 = CustomUser(
          id: UniqueID.fromUniqueString("promoter1"),
          firstName: "John",
          lastName: "Doe",
        );
        promoter2 = CustomUser(
          id: UniqueID.fromUniqueString("promoter2"),
          firstName: "Jane",
          lastName: "Smith",
        );

        recommendations1 = [
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec1"),
            userID: "user1",
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec2"),
            userID: "user1",
          ),
        ];

        recommendations2 = [
          UserRecommendation(
            id: UniqueID.fromUniqueString("rec3"),
            userID: "user1",
          ),
        ];

        allRecommendations = [...recommendations1, ...recommendations2];

        state = DashboardRecommendationsGetRecosSuccessState(
          recommendation: allRecommendations,
          promoterRecommendations: [
            PromoterRecommendations(promoter: promoter1, recommendations: recommendations1),
            PromoterRecommendations(promoter: promoter2, recommendations: recommendations2),
          ],
        );
      });

      test("should return all recommendations when selectedPromoterId is null", () {
        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: state,
          selectedPromoterId: null,
          userRole: Role.company,
        );

        expect(result, equals(allRecommendations));
      });

      test("should return all recommendations when userRole is not company", () {
        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: state,
          selectedPromoterId: "promoter1",
          userRole: Role.promoter,
        );

        expect(result, equals(allRecommendations));
      });

      test("should return specific promoter recommendations when promoter is selected", () {
        final result = DashboardRecommendationsHelper.getFilteredRecommendations(
          state: state,
          selectedPromoterId: "promoter1",
          userRole: Role.company,
        );

        expect(result, equals(recommendations1));
      });

      test("should return empty list when selected promoter is not found", () {
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