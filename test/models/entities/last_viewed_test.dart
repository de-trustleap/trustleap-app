import 'package:finanzbegleiter/domain/entities/last_viewed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LastViewed_CopyWith", () {
    test("set userID with copyWith should set userID for resulting object", () {
      // Given
      final lastViewed = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final expectedResult = LastViewed(
        userID: "user456",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastViewed.copyWith(userID: "user456");
      // Then
      expect(result, expectedResult);
    });

    test("set viewedAt with copyWith should set viewedAt for resulting object", () {
      // Given
      final originalDate = DateTime(2023, 12, 25, 10, 30, 0);
      final newDate = DateTime(2023, 12, 26, 11, 45, 0);
      final lastViewed = LastViewed(
        userID: "user123",
        viewedAt: originalDate,
      );
      final expectedResult = LastViewed(
        userID: "user123",
        viewedAt: newDate,
      );
      // When
      final result = lastViewed.copyWith(viewedAt: newDate);
      // Then
      expect(result, expectedResult);
    });

    test("set both fields with copyWith should set all fields for resulting object", () {
      // Given
      final originalDate = DateTime(2023, 12, 25, 10, 30, 0);
      final newDate = DateTime(2023, 12, 26, 11, 45, 0);
      final lastViewed = LastViewed(
        userID: "user123",
        viewedAt: originalDate,
      );
      final expectedResult = LastViewed(
        userID: "user456",
        viewedAt: newDate,
      );
      // When
      final result = lastViewed.copyWith(
        userID: "user456",
        viewedAt: newDate,
      );
      // Then
      expect(result, expectedResult);
    });

    test("copyWith with no parameters should return identical object", () {
      // Given
      final lastViewed = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastViewed.copyWith();
      // Then
      expect(result, lastViewed);
    });
  });

  group("LastViewed_Props", () {
    test("check if value equality works with same values", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastViewed1 = LastViewed(
        userID: "user123",
        viewedAt: date,
      );
      final lastViewed2 = LastViewed(
        userID: "user123",
        viewedAt: date,
      );
      // Then
      expect(lastViewed1, lastViewed2);
    });

    test("check if value equality fails with different userID", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastViewed1 = LastViewed(
        userID: "user123",
        viewedAt: date,
      );
      final lastViewed2 = LastViewed(
        userID: "user456",
        viewedAt: date,
      );
      // Then
      expect(lastViewed1, isNot(lastViewed2));
    });

    test("check if value equality fails with different viewedAt", () {
      // Given
      final lastViewed1 = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final lastViewed2 = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 26, 11, 45, 0),
      );
      // Then
      expect(lastViewed1, isNot(lastViewed2));
    });

    test("check hashCode consistency", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastViewed1 = LastViewed(
        userID: "user123",
        viewedAt: date,
      );
      final lastViewed2 = LastViewed(
        userID: "user123",
        viewedAt: date,
      );
      // Then
      expect(lastViewed1.hashCode, lastViewed2.hashCode);
    });

    test("check toString contains all properties", () {
      // Given
      final lastViewed = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastViewed.toString();
      // Then
      expect(result, contains("LastViewed"));
      expect(result, contains("user123"));
    });

    test("check different hashCodes for different objects", () {
      // Given
      final lastViewed1 = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final lastViewed2 = LastViewed(
        userID: "user456",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // Then
      expect(lastViewed1.hashCode, isNot(lastViewed2.hashCode));
    });
  });

  group("LastViewed_Constructor", () {
    test("should create LastViewed with all required parameters", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      // When
      final lastViewed = LastViewed(
        userID: "user123",
        viewedAt: date,
      );
      // Then
      expect(lastViewed.userID, "user123");
      expect(lastViewed.viewedAt, date);
    });

    test("should handle different user IDs", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      // When
      final userViewed1 = LastViewed(
        userID: "user123",
        viewedAt: date,
      );
      final userViewed2 = LastViewed(
        userID: "user456",
        viewedAt: date,
      );
      // Then
      expect(userViewed1.userID, "user123");
      expect(userViewed2.userID, "user456");
    });
  });
}