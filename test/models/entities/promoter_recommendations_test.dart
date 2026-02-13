import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("PromoterRecommendations_CopyWith", () {
    final date = DateTime.now();
    final promoter = CustomUser(
        id: UniqueID.fromUniqueString("1"),
        email: "test@example.com",
        firstName: "Test",
        lastName: "User",
        role: Role.promoter,
        place: "Test City",
        recommendationIDs: ["1"],
        createdAt: date);

    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: StatusLevel.contactFormSent,
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);

    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        notes: "Test",
        recommendation: recommendation);

    final recommendations = [userRecommendation];

    test("should return new instance with updated promoter", () {
      // Given
      final promoterRecommendations = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);

      final newPromoter = promoter.copyWith(firstName: "Updated");
      final expectedResult = PromoterRecommendations(
          promoter: newPromoter, recommendations: recommendations);

      // When
      final result = promoterRecommendations.copyWith(promoter: newPromoter);

      // Then
      expect(result, expectedResult);
    });

    test("should return new instance with updated recommendations", () {
      // Given
      final promoterRecommendations = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);

      final newRecommendations = <UserRecommendation>[];
      final expectedResult = PromoterRecommendations(
          promoter: promoter, recommendations: newRecommendations);

      // When
      final result =
          promoterRecommendations.copyWith(recommendations: newRecommendations);

      // Then
      expect(result, expectedResult);
    });

    test("should return new instance with updated promoter and recommendations",
        () {
      // Given
      final promoterRecommendations = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);

      final newPromoter = promoter.copyWith(firstName: "Updated");
      final newRecommendations = <UserRecommendation>[];
      final expectedResult = PromoterRecommendations(
          promoter: newPromoter, recommendations: newRecommendations);

      // When
      final result = promoterRecommendations.copyWith(
          promoter: newPromoter, recommendations: newRecommendations);

      // Then
      expect(result, expectedResult);
    });

    test("should return same instance when no parameters provided", () {
      // Given
      final promoterRecommendations = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);

      // When
      final result = promoterRecommendations.copyWith();

      // Then
      expect(result, promoterRecommendations);
    });
  });

  group("PromoterRecommendations_Props", () {
    final date = DateTime.now();
    final promoter = CustomUser(
        id: UniqueID.fromUniqueString("1"),
        email: "test@example.com",
        firstName: "Test",
        lastName: "User",
        role: Role.promoter,
        place: "Test City",
        recommendationIDs: ["1"],
        createdAt: date);

    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: StatusLevel.contactFormSent,
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);

    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        notes: "Test",
        recommendation: recommendation);

    final recommendations = [userRecommendation];

    test("check if value equality works", () {
      // Given
      final promoterRecommendations1 = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);
      final promoterRecommendations2 = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);

      // Then
      expect(promoterRecommendations1, promoterRecommendations2);
    });

    test("check if value equality fails with different promoter", () {
      // Given
      final promoterRecommendations1 = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);
      final differentPromoter = promoter.copyWith(firstName: "Different");
      final promoterRecommendations2 = PromoterRecommendations(
          promoter: differentPromoter, recommendations: recommendations);

      // Then
      expect(promoterRecommendations1, isNot(promoterRecommendations2));
    });

    test("check if value equality fails with different recommendations", () {
      // Given
      final promoterRecommendations1 = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);
      final differentRecommendations = <UserRecommendation>[];
      final promoterRecommendations2 = PromoterRecommendations(
          promoter: promoter, recommendations: differentRecommendations);

      // Then
      expect(promoterRecommendations1, isNot(promoterRecommendations2));
    });

    test("check if hashCode is consistent", () {
      // Given
      final promoterRecommendations1 = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);
      final promoterRecommendations2 = PromoterRecommendations(
          promoter: promoter, recommendations: recommendations);

      // Then
      expect(promoterRecommendations1.hashCode, promoterRecommendations2.hashCode);
    });
  });
}