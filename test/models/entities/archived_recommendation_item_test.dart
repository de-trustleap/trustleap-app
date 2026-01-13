import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ArchivedRecommendationItem_CopyWith", () {
    test("set reason with copyWith should set reason for resulting object", () {
      final date = DateTime.now();
      // Given
      final model = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date,
          landingPageID: "test-landing-page");
      final expectedResult = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          reason: "Test new",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date,
          landingPageID: "test-landing-page");
      // When
      final result = model.copyWith(reason: "Test new");
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedRecommendationItem_Props", () {
    test("check if value equality works", () {
      final date = DateTime.now();
      // Given
      final model = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date,
          landingPageID: "test-landing-page");
      final model2 = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date,
          landingPageID: "test-landing-page");
      // Then
      expect(model, model2);
    });
  });
}
