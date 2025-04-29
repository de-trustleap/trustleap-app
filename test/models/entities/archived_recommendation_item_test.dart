import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ArchivedRecommendationItem_CopyWith", () {
    test("set name with copyWith should set name for resulting object", () {
      final date = DateTime.now();
      // Given
      final model = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      final expectedResult = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          name: "Test new",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      // When
      final result = model.copyWith(name: "Test new");
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
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      final model2 = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      // Then
      expect(model, model2);
    });
  });
}
