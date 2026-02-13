import 'package:finanzbegleiter/features/landing_pages/domain/last_viewed.dart';
import 'package:finanzbegleiter/features/landing_pages/infrastructure/last_viewed_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LastViewedModel_CopyWith", () {
    test("set userID with copyWith should set userID for resulting object", () {
      // Given
      final lastViewedModel = LastViewedModel(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final expectedResult = LastViewedModel(
        userID: "user456",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastViewedModel.copyWith(userID: "user456");
      // Then
      expect(result, expectedResult);
    });

    test("set viewedAt with copyWith should set viewedAt for resulting object", () {
      // Given
      final originalDate = DateTime(2023, 12, 25, 10, 30, 0);
      final newDate = DateTime(2023, 12, 26, 11, 45, 0);
      final lastViewedModel = LastViewedModel(
        userID: "user123",
        viewedAt: originalDate,
      );
      final expectedResult = LastViewedModel(
        userID: "user123",
        viewedAt: newDate,
      );
      // When
      final result = lastViewedModel.copyWith(viewedAt: newDate);
      // Then
      expect(result, expectedResult);
    });

    test("set both fields with copyWith should set all fields for resulting object", () {
      // Given
      final originalDate = DateTime(2023, 12, 25, 10, 30, 0);
      final newDate = DateTime(2023, 12, 26, 11, 45, 0);
      final lastViewedModel = LastViewedModel(
        userID: "user123",
        viewedAt: originalDate,
      );
      final expectedResult = LastViewedModel(
        userID: "user456",
        viewedAt: newDate,
      );
      // When
      final result = lastViewedModel.copyWith(
        userID: "user456",
        viewedAt: newDate,
      );
      // Then
      expect(result, expectedResult);
    });
  });

  group("LastViewedModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = LastViewedModel(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );

      final expectedResult = {
        "userID": "user123",
        "viewedAt": "2023-12-25T10:30:00.000",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("LastViewedModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "userID": "user123",
        "viewedAt": "2023-12-25T10:30:00.000",
      };
      final expectedResult = LastViewedModel(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = LastViewedModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("LastViewedModel_ToDomain", () {
    test("check if conversion from LastViewedModel to LastViewed works", () {
      // Given
      final model = LastViewedModel(
        userID: "user456",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );

      final expectedResult = LastViewed(
        userID: "user456",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );

      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("LastViewedModel_FromDomain", () {
    test("check if conversion from LastViewed to LastViewedModel works", () {
      // Given
      final lastViewed = LastViewed(
        userID: "user789",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final expectedResult = LastViewedModel(
        userID: "user789",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = LastViewedModel.fromDomain(lastViewed);
      // Then
      expect(result, expectedResult);
    });
  });

  group("LastViewedModel_Props", () {
    test("check if value equality works", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastViewedModel1 = LastViewedModel(
        userID: "user123",
        viewedAt: date,
      );
      final lastViewedModel2 = LastViewedModel(
        userID: "user123",
        viewedAt: date,
      );
      // Then
      expect(lastViewedModel1, lastViewedModel2);
    });

    test("check if value equality fails with different values", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastViewedModel1 = LastViewedModel(
        userID: "user123",
        viewedAt: date,
      );
      final lastViewedModel2 = LastViewedModel(
        userID: "user456",
        viewedAt: date,
      );
      // Then
      expect(lastViewedModel1, isNot(lastViewedModel2));
    });
  });
}