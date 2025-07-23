import 'package:finanzbegleiter/domain/entities/feedback.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Feedback_CopyWith", () {
    test("set title with copyWith should set title for resulting object", () {
      // Given
      final feedback = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Original Title",
        description: "Original Description",
      );
      final expectedResult = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "New Title",
        description: "Original Description",
      );
      // When
      final result = feedback.copyWith(title: "New Title");
      // Then
      expect(result, expectedResult);
    });

    test("set description with copyWith should set description for resulting object", () {
      // Given
      final feedback = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Original Description",
      );
      final expectedResult = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "New Description",
      );
      // When
      final result = feedback.copyWith(description: "New Description");
      // Then
      expect(result, expectedResult);
    });

    test("set downloadImageUrl with copyWith should set downloadImageUrl for resulting object", () {
      // Given
      final feedback = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Test Description",
      );
      final expectedResult = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Test Description",
        downloadImageUrls: ["https://example.com/image.jpg"],
      );
      // When
      final result = feedback.copyWith(downloadImageUrls: ["https://example.com/image.jpg"]);
      // Then
      expect(result, expectedResult);
    });

    test("set multiple fields with copyWith should set all fields for resulting object", () {
      // Given
      final feedback = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Original Title",
        description: "Original Description",
      );
      final expectedResult = Feedback(
        id: UniqueID.fromUniqueString("2"),
        title: "New Title",
        description: "New Description",
        downloadImageUrls: ["https://example.com/image.jpg"],
        thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"],
      );
      // When
      final result = feedback.copyWith(
        id: UniqueID.fromUniqueString("2"),
        title: "New Title",
        description: "New Description",
        downloadImageUrls: ["https://example.com/image.jpg"],
        thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"],
      );
      // Then
      expect(result, expectedResult);
    });

    test("set thumbnailDownloadURL with copyWith should set thumbnailDownloadURL for resulting object", () {
      // Given
      final feedback = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Test Description",
        downloadImageUrls: ["https://example.com/image.jpg"],
      );
      final expectedResult = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Test Description",
        downloadImageUrls: ["https://example.com/image.jpg"],
        thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"],
      );
      // When
      final result = feedback.copyWith(thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"]);
      // Then
      expect(result, expectedResult);
    });
  });

  group("Feedback_Props", () {
    test("check if value equality works", () {
      // Given
      final feedback1 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrls: ["https://example.com/image.jpg"],
        thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"],
      );

      final feedback2 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrls: ["https://example.com/image.jpg"],
        thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"],
      );
      // Then
      expect(feedback1, feedback2);
    });

    test("check if value equality works with null values", () {
      // Given
      final feedback1 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
      );

      final feedback2 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
      );
      // Then
      expect(feedback1, feedback2);
    });

    test("check if inequality works with different ids", () {
      // Given
      final feedback1 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
      );

      final feedback2 = Feedback(
        id: UniqueID.fromUniqueString("2"),
        title: "Test Feedback",
        description: "This is a test feedback description",
      );
      // Then
      expect(feedback1, isNot(equals(feedback2)));
    });

    test("check if inequality works with different titles", () {
      // Given
      final feedback1 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
      );

      final feedback2 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Different Feedback",
        description: "This is a test feedback description",
      );
      // Then
      expect(feedback1, isNot(equals(feedback2)));
    });

    test("check if inequality works with different descriptions", () {
      // Given
      final feedback1 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "Original description",
      );

      final feedback2 = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "Different description",
      );
      // Then
      expect(feedback1, isNot(equals(feedback2)));
    });
  });
}