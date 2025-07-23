// ignore_for_file: type=lint
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
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
}
