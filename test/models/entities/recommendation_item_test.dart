import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("RecommendationItem_CopyWith", () {
    test("set name with copyWith should set name for resulting object", () {
      // Given
      final recoItem = RecommendationItem(
          id: "1",
          name: "Test",
          reason: "Page1",
          landingPageID: "2",
          promotionTemplate: "Test",
          promoterName: "Tester",
          serviceProviderName: "Tester",
          defaultLandingPageID: "3");
      final expectedResult = RecommendationItem(
          id: "1",
          name: "Test Neu",
          reason: "Page1",
          landingPageID: "2",
          promotionTemplate: "Test",
          promoterName: "Tester",
          serviceProviderName: "Tester",
          defaultLandingPageID: "3");
      // When
      final result = recoItem.copyWith(name: "Test Neu");
      // Then
      expect(result, expectedResult);
    });
  });

  group("RecommendationItem_Props", () {
    test("check if value equality works", () {
      // Given
      final recoItem1 = RecommendationItem(
          id: "1",
          name: "Test",
          reason: "Page1",
          landingPageID: "2",
          promotionTemplate: "Test",
          promoterName: "Tester",
          serviceProviderName: "Tester",
          defaultLandingPageID: "3");
      final recoItem2 = RecommendationItem(
          id: "1",
          name: "Test",
          reason: "Page1",
          landingPageID: "2",
          promotionTemplate: "Test",
          promoterName: "Tester",
          serviceProviderName: "Tester",
          defaultLandingPageID: "3");
      // Then
      expect(recoItem2, recoItem1);
    });
  });
}
