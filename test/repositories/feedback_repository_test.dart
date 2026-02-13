// ignore_for_file: type=lint
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_item.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  late MockFeedbackRepository mockFeedbackRepo;

  setUp(() {
    mockFeedbackRepo = MockFeedbackRepository();
  });

  group("FeedbackRepositoryImplementation_SendFeedback", () {
    final testFeedback = FeedbackItem(
      id: UniqueID.fromUniqueString("test-id"),
      title: "Test Feedback",
      description: "This is a test feedback description",
      type: FeedbackType.feedback,
    );

    final testImages = [
      Uint8List.fromList([1, 2, 3, 4]),
      Uint8List.fromList([5, 6, 7, 8]),
    ];

    test("should return unit when feedback has been sent successfully",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => right(unit));

      // When
      final result =
          await mockFeedbackRepo.sendFeedback(testFeedback, testImages);

      // Then
      verify(mockFeedbackRepo.sendFeedback(testFeedback, testImages));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should return unit when feedback has been sent without images",
        () async {
      // Given
      final emptyImages = <Uint8List>[];
      final expectedResult = right(unit);
      when(mockFeedbackRepo.sendFeedback(testFeedback, emptyImages))
          .thenAnswer((_) async => right(unit));

      // When
      final result =
          await mockFeedbackRepo.sendFeedback(testFeedback, emptyImages);

      // Then
      verify(mockFeedbackRepo.sendFeedback(testFeedback, emptyImages));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should return PermissionDeniedFailure when call has failed with permission denied",
        () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // When
      final result =
          await mockFeedbackRepo.sendFeedback(testFeedback, testImages);

      // Then
      verify(mockFeedbackRepo.sendFeedback(testFeedback, testImages));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should return BackendFailure when call has failed with backend error",
        () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => left(BackendFailure()));

      // When
      final result =
          await mockFeedbackRepo.sendFeedback(testFeedback, testImages);

      // Then
      verify(mockFeedbackRepo.sendFeedback(testFeedback, testImages));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should return UnavailableFailure when call has failed with service unavailable error",
        () async {
      // Given
      final expectedResult = left(UnavailableFailure());
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => left(UnavailableFailure()));

      // When
      final result =
          await mockFeedbackRepo.sendFeedback(testFeedback, testImages);

      // Then
      verify(mockFeedbackRepo.sendFeedback(testFeedback, testImages));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should handle multiple images correctly", () async {
      // Given
      final multipleImages = [
        Uint8List.fromList([1, 2, 3]),
        Uint8List.fromList([4, 5, 6]),
        Uint8List.fromList([7, 8, 9]),
      ];
      final expectedResult = right(unit);
      when(mockFeedbackRepo.sendFeedback(testFeedback, multipleImages))
          .thenAnswer((_) async => right(unit));

      // When
      final result =
          await mockFeedbackRepo.sendFeedback(testFeedback, multipleImages);

      // Then
      verify(mockFeedbackRepo.sendFeedback(testFeedback, multipleImages));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });
  });

  group("FeedbackRepositoryImplementation_GetFeedbackItems", () {
    final testFeedbackItems = <FeedbackItem>[
      FeedbackItem(
        id: UniqueID.fromUniqueString("test-id-1"),
        title: "Test Feedback 1",
        description: "This is test feedback 1",
        type: FeedbackType.feedback,
      ),
      FeedbackItem(
        id: UniqueID.fromUniqueString("test-id-2"),
        title: "Test Feedback 2", 
        description: "This is test feedback 2",
        type: FeedbackType.bug,
      ),
    ];

    test("should return list of feedback items when call was successful",
        () async {
      // Given
      final expectedResult = right(testFeedbackItems);
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => right(testFeedbackItems));

      // When
      final result = await mockFeedbackRepo.getFeedbackItems();

      // Then
      verify(mockFeedbackRepo.getFeedbackItems());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should return empty list when no feedback items exist", () async {
      // Given
      final emptyList = <FeedbackItem>[];
      final expectedResult = right(emptyList);
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => right(emptyList));

      // When
      final result = await mockFeedbackRepo.getFeedbackItems();

      // Then
      verify(mockFeedbackRepo.getFeedbackItems());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should return NotFoundFailure when collection is empty", () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => left(NotFoundFailure()));

      // When
      final result = await mockFeedbackRepo.getFeedbackItems();

      // Then
      verify(mockFeedbackRepo.getFeedbackItems());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should return PermissionDeniedFailure when call has failed with permission denied",
        () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // When
      final result = await mockFeedbackRepo.getFeedbackItems();

      // Then
      verify(mockFeedbackRepo.getFeedbackItems());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should return BackendFailure when call has failed with backend error",
        () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => left(BackendFailure()));

      // When
      final result = await mockFeedbackRepo.getFeedbackItems();

      // Then
      verify(mockFeedbackRepo.getFeedbackItems());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should return UnavailableFailure when call has failed with service unavailable error",
        () async {
      // Given
      final expectedResult = left(UnavailableFailure());
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => left(UnavailableFailure()));

      // When
      final result = await mockFeedbackRepo.getFeedbackItems();

      // Then
      verify(mockFeedbackRepo.getFeedbackItems());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });
  });

  group("FeedbackRepositoryImplementation_DeleteFeedback", () {
    const testFeedbackId = "test-feedback-id";

    test("should return unit when feedback has been deleted successfully",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockFeedbackRepo.deleteFeedback(testFeedbackId);

      // Then
      verify(mockFeedbackRepo.deleteFeedback(testFeedbackId));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should handle empty feedback ID correctly", () async {
      // Given
      const emptyId = "";
      final expectedResult = right(unit);
      when(mockFeedbackRepo.deleteFeedback(emptyId))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockFeedbackRepo.deleteFeedback(emptyId);

      // Then
      verify(mockFeedbackRepo.deleteFeedback(emptyId));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should return PermissionDeniedFailure when call has failed with permission denied",
        () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // When
      final result = await mockFeedbackRepo.deleteFeedback(testFeedbackId);

      // Then
      verify(mockFeedbackRepo.deleteFeedback(testFeedbackId));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should return BackendFailure when call has failed with backend error",
        () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => left(BackendFailure()));

      // When
      final result = await mockFeedbackRepo.deleteFeedback(testFeedbackId);

      // Then
      verify(mockFeedbackRepo.deleteFeedback(testFeedbackId));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should return UnavailableFailure when call has failed with service unavailable error",
        () async {
      // Given
      final expectedResult = left(UnavailableFailure());
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => left(UnavailableFailure()));

      // When
      final result = await mockFeedbackRepo.deleteFeedback(testFeedbackId);

      // Then
      verify(mockFeedbackRepo.deleteFeedback(testFeedbackId));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should return NotFoundFailure when feedback item does not exist",
        () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => left(NotFoundFailure()));

      // When
      final result = await mockFeedbackRepo.deleteFeedback(testFeedbackId);

      // Then
      verify(mockFeedbackRepo.deleteFeedback(testFeedbackId));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test("should handle special characters in feedback ID correctly", () async {
      // Given
      const specialId = "test-id-with-special-chars-äöü-123!@#";
      final expectedResult = right(unit);
      when(mockFeedbackRepo.deleteFeedback(specialId))
          .thenAnswer((_) async => right(unit));

      // When
      final result = await mockFeedbackRepo.deleteFeedback(specialId);

      // Then
      verify(mockFeedbackRepo.deleteFeedback(specialId));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockFeedbackRepo);
    });
  });
}
