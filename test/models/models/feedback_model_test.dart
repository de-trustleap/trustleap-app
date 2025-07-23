import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/domain/entities/feedback.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/infrastructure/models/feedback_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("FeedbackModel_CopyWith", () {
    test("set downloadImageUrl with copyWith should set downloadImageUrl for resulting object", () {
      // Given
      const feedback = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "Test Description",
      );
      const expectedResult = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "Test Description",
        downloadImageUrl: "https://example.com/image.jpg",
      );
      // When
      final result = feedback.copyWith(downloadImageUrl: "https://example.com/image.jpg");
      // Then
      expect(result, expectedResult);
    });

    test("set thumbnailDownloadURL with copyWith should set thumbnailDownloadURL for resulting object", () {
      // Given
      const feedback = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "Test Description",
      );
      const expectedResult = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "Test Description",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
      );
      // When
      final result = feedback.copyWith(thumbnailDownloadURL: "https://example.com/thumbnail.jpg");
      // Then
      expect(result, expectedResult);
    });
  });

  group("FeedbackModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      const model = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrl: "https://example.com/image.jpg",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
      );

      final expectedResult = {
        "id": "1",
        "title": "Test Feedback",
        "description": "This is a test feedback description",
        "downloadImageUrl": "https://example.com/image.jpg",
        "thumbnailDownloadURL": "https://example.com/thumbnail.jpg",
        "userAgent": null,
        "createdAt": null,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with null values is successfully converted to a map", () {
      // Given
      const model = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "This is a test feedback description",
      );

      final expectedResult = {
        "id": "1",
        "title": "Test Feedback",
        "description": "This is a test feedback description",
        "downloadImageUrl": null,
        "thumbnailDownloadURL": null,
        "userAgent": null,
        "createdAt": null,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("FeedbackModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "title": "Test Feedback",
        "description": "This is a test feedback description",
        "downloadImageUrl": "https://example.com/image.jpg",
        "thumbnailDownloadURL": "https://example.com/thumbnail.jpg",
      };
      const expectedResult = FeedbackModel(
        id: "",
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrl: "https://example.com/image.jpg",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
      );
      // When
      final result = FeedbackModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });

    test("check if map with null values is successfully converted to model", () {
      // Given
      final map = {
        "title": "Test Feedback",
        "description": "This is a test feedback description",
      };
      const expectedResult = FeedbackModel(
        id: "",
        title: "Test Feedback",
        description: "This is a test feedback description",
      );
      // When
      final result = FeedbackModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("FeedbackModel_ToDomain", () {
    test("check if conversion from FeedbackModel to Feedback works", () {
      // Given
      final testDate = DateTime.now();
      final testTimestamp = Timestamp.fromDate(testDate);
      
      final model = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrl: "https://example.com/image.jpg",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
        userAgent: "test-agent",
        createdAt: testTimestamp,
      );

      final expectedResult = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrl: "https://example.com/image.jpg",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
        userAgent: "test-agent",
        createdAt: testDate,
      );

      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });

    test("check if conversion from FeedbackModel with null values to Feedback works", () {
      // Given
      final testDate = DateTime.now();
      final testTimestamp = Timestamp.fromDate(testDate);
      
      final model = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "This is a test feedback description",
        createdAt: testTimestamp,
      );

      final expectedResult = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        createdAt: testDate,
      );

      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("FeedbackModel_FromDomain", () {
    test("check if conversion from Feedback to FeedbackModel works", () {
      // Given
      final testDate = DateTime.now();
      final feedback = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrl: "https://example.com/image.jpg",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
        userAgent: "test-agent",
        createdAt: testDate,
      );
      
      // When
      final result = FeedbackModel.fromDomain(feedback);
      
      // Then - Check individual fields since FieldValue.serverTimestamp() can't be compared directly
      expect(result.id, "1");
      expect(result.title, "Test Feedback");
      expect(result.description, "This is a test feedback description");
      expect(result.downloadImageUrl, "https://example.com/image.jpg");
      expect(result.thumbnailDownloadURL, "https://example.com/thumbnail.jpg");
      expect(result.userAgent, "test-agent");
      expect(result.createdAt, isA<FieldValue>());
    });

    test("check if conversion from Feedback with null values to FeedbackModel works", () {
      // Given
      final feedback = Feedback(
        id: UniqueID.fromUniqueString("1"),
        title: "Test Feedback",
        description: "This is a test feedback description",
      );
      
      // When
      final result = FeedbackModel.fromDomain(feedback);
      
      // Then - Check individual fields since FieldValue.serverTimestamp() can't be compared directly
      expect(result.id, "1");
      expect(result.title, "Test Feedback");
      expect(result.description, "This is a test feedback description");
      expect(result.downloadImageUrl, null);
      expect(result.thumbnailDownloadURL, null);
      expect(result.userAgent, null);
      expect(result.createdAt, isA<FieldValue>());
    });
  });

  group("FeedbackModel_FromFirestore", () {
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "title": "Test Feedback",
        "description": "This is a test feedback description",
        "downloadImageUrl": "https://example.com/image.jpg",
        "thumbnailDownloadURL": "https://example.com/thumbnail.jpg",
      };
      const expectedResult = FeedbackModel(
        id: "feedback-id-123",
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrl: "https://example.com/image.jpg",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
      );
      // When
      final result = FeedbackModel.fromFirestore(map, "feedback-id-123");
      // Then
      expect(expectedResult, result);
    });
  });

  group("FeedbackModel_Props", () {
    test("check if value equality works", () {
      // Given
      const feedback1 = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrl: "https://example.com/image.jpg",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
        userAgent: "test-agent",
      );
      const feedback2 = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "This is a test feedback description",
        downloadImageUrl: "https://example.com/image.jpg",
        thumbnailDownloadURL: "https://example.com/thumbnail.jpg",
        userAgent: "test-agent",
      );
      // Then
      expect(feedback1, feedback2);
    });

    test("check if inequality works with different titles", () {
      // Given
      const feedback1 = FeedbackModel(
        id: "1",
        title: "Test Feedback",
        description: "This is a test feedback description",
      );
      const feedback2 = FeedbackModel(
        id: "1",
        title: "Different Feedback",
        description: "This is a test feedback description",
      );
      // Then
      expect(feedback1, isNot(equals(feedback2)));
    });
  });
}