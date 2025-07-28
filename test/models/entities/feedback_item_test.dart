import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Feedback_CopyWith", () {
    test("set title with copyWith should set title for resulting object", () {
      // Given
      final feedback = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Original Title",
        description: "Original Description",
        type: FeedbackType.feedback,
      );
      final expectedResult = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "New Title",
        description: "Original Description",
        type: FeedbackType.feedback,
      );
      // When
      final result = feedback.copyWith(title: "New Title");
      // Then
      expect(result, expectedResult);
    });

    test(
        "set description with copyWith should set description for resulting object",
        () {
      // Given
      final feedback = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Original Description",
        type: FeedbackType.feedback,
      );
      final expectedResult = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "New Description",
        type: FeedbackType.feedback,
      );
      // When
      final result = feedback.copyWith(description: "New Description");
      // Then
      expect(result, expectedResult);
    });

    test(
        "set downloadImageUrl with copyWith should set downloadImageUrl for resulting object",
        () {
      // Given
      final feedback = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Test Description",
        type: FeedbackType.feedback,
      );
      final expectedResult = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Test Description",
        type: FeedbackType.feedback,
        downloadImageUrls: ["https://example.com/image.jpg"],
      );
      // When
      final result = feedback
          .copyWith(downloadImageUrls: ["https://example.com/image.jpg"]);
      // Then
      expect(result, expectedResult);
    });

    test(
        "set multiple fields with copyWith should set all fields for resulting object",
        () {
      // Given
      final feedback = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Original Title",
        description: "Original Description",
        type: FeedbackType.feedback,
      );
      final expectedResult = FeedbackItem(
        id: UniqueID.fromUniqueString("2"),
        title: "New Title",
        description: "New Description",
        type: FeedbackType.feedback,
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

    test(
        "set thumbnailDownloadURL with copyWith should set thumbnailDownloadURL for resulting object",
        () {
      // Given
      final feedback = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Test Description",
        type: FeedbackType.feedback,
        downloadImageUrls: ["https://example.com/image.jpg"],
      );
      final expectedResult = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Title",
        description: "Test Description",
        type: FeedbackType.feedback,
        downloadImageUrls: ["https://example.com/image.jpg"],
        thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"],
      );
      // When
      final result = feedback.copyWith(
          thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"]);
      // Then
      expect(result, expectedResult);
    });
  });

  group("Feedback_Props", () {
    test("check if value equality works", () {
      // Given
      final feedback1 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        type: FeedbackType.feedback,
        downloadImageUrls: ["https://example.com/image.jpg"],
        thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"],
      );

      final feedback2 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        type: FeedbackType.feedback,
        downloadImageUrls: ["https://example.com/image.jpg"],
        thumbnailDownloadURLs: ["https://example.com/thumbnail.jpg"],
      );
      // Then
      expect(feedback1, feedback2);
    });

    test("check if value equality works with null values", () {
      // Given
      final feedback1 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        type: FeedbackType.feedback,
      );

      final feedback2 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        type: FeedbackType.feedback,
      );
      // Then
      expect(feedback1, feedback2);
    });

    test("check if inequality works with different ids", () {
      // Given
      final feedback1 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        type: FeedbackType.feedback,
      );

      final feedback2 = FeedbackItem(
        id: UniqueID.fromUniqueString("2"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        type: FeedbackType.feedback,
      );
      // Then
      expect(feedback1, isNot(equals(feedback2)));
    });

    test("check if inequality works with different titles", () {
      // Given
      final feedback1 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        type: FeedbackType.feedback,
      );

      final feedback2 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Different Feedback",
        description: "This is a test feedback description",
        type: FeedbackType.feedback,
      );
      // Then
      expect(feedback1, isNot(equals(feedback2)));
    });

    test("check if inequality works with different descriptions", () {
      // Given
      final feedback1 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "Original description",
        type: FeedbackType.feedback,
      );

      final feedback2 = FeedbackItem(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "Different description",
        type: FeedbackType.feedback,
      );
      // Then
      expect(feedback1, isNot(equals(feedback2)));
    });
  });
}
