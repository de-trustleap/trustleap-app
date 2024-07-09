import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/recommendation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Recommendation_CopyWith", () {
    test("set promoter with copyWith should set promoter for resulting object",
        () {
      // Given
      final recommendation = Recommendation(
          id: UniqueID.fromUniqueString("1"),
          name: "Tester Test",
          serviceProvider: "Test Provider",
          promoter: "Test Promoter",
          reason: "Test");

      final expectedResult = Recommendation(
          id: UniqueID.fromUniqueString("1"),
          name: "Tester Test",
          serviceProvider: "Test Provider",
          promoter: "Test Promoter New",
          reason: "Test");
      // When
      final result = recommendation.copyWith(promoter: "Test Promoter New");
      // Then
      expect(expectedResult, result);
    });
  });

  group("Recommendation_Props", () {
    test("check if value equality works", () {
      // Given
      final recommendation = Recommendation(
          id: UniqueID.fromUniqueString("1"),
          name: "Tester Test",
          serviceProvider: "Test Provider",
          promoter: "Test Promoter",
          reason: "Test");

      final recommendation2 = Recommendation(
          id: UniqueID.fromUniqueString("1"),
          name: "Tester Test",
          serviceProvider: "Test Provider",
          promoter: "Test Promoter",
          reason: "Test");
      // Then
      expect(recommendation, recommendation2);
    });
  });
}
