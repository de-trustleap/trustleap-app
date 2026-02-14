import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/feedback/application/feedback_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_item.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  late FeedbackCubit feedbackCubit;
  late MockFeedbackRepository mockFeedbackRepo;

  setUp(() {
    mockFeedbackRepo = MockFeedbackRepository();
    feedbackCubit = FeedbackCubit(mockFeedbackRepo);
  });

  test("init state should be FeedbackInitial", () {
    expect(feedbackCubit.state, FeedbackInitial());
  });

  group("FeedbackCubit_SendFeedback", () {
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

    test("should call feedback repo when function is called", () async {
      // Given
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => right(unit));

      // When
      feedbackCubit.sendFeedback(testFeedback, testImages);
      await untilCalled(
          mockFeedbackRepo.sendFeedback(testFeedback, testImages));

      // Then
      verify(mockFeedbackRepo.sendFeedback(testFeedback, testImages));
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should emit SentFeedbackLoadingState and then SentFeedbackSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        SentFeedbackLoadingState(),
        SentFeedbackSuccessState()
      ];
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.sendFeedback(testFeedback, testImages);
    });

    test(
        "should emit SentFeedbackLoadingState and then SentFeedbackFailureState when call has failed with PermissionDeniedFailure",
        () async {
      // Given
      final expectedResult = [
        SentFeedbackLoadingState(),
        SentFeedbackFailureState(failure: PermissionDeniedFailure())
      ];
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.sendFeedback(testFeedback, testImages);
    });

    test(
        "should emit SentFeedbackLoadingState and then SentFeedbackFailureState when call has failed with BackendFailure",
        () async {
      // Given
      final expectedResult = [
        SentFeedbackLoadingState(),
        SentFeedbackFailureState(failure: BackendFailure())
      ];
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.sendFeedback(testFeedback, testImages);
    });

    test(
        "should emit SentFeedbackLoadingState and then SentFeedbackFailureState when call has failed with UnavailableFailure",
        () async {
      // Given
      final expectedResult = [
        SentFeedbackLoadingState(),
        SentFeedbackFailureState(failure: UnavailableFailure())
      ];
      when(mockFeedbackRepo.sendFeedback(testFeedback, testImages))
          .thenAnswer((_) async => left(UnavailableFailure()));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.sendFeedback(testFeedback, testImages);
    });

    test("should handle feedback without images correctly", () async {
      // Given
      final emptyImages = <Uint8List>[];
      final expectedResult = [
        SentFeedbackLoadingState(),
        SentFeedbackSuccessState()
      ];
      when(mockFeedbackRepo.sendFeedback(testFeedback, emptyImages))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.sendFeedback(testFeedback, emptyImages);
    });

    test("should handle multiple images correctly", () async {
      // Given
      final multipleImages = [
        Uint8List.fromList([1, 2, 3]),
        Uint8List.fromList([4, 5, 6]),
        Uint8List.fromList([7, 8, 9]),
      ];
      final expectedResult = [
        SentFeedbackLoadingState(),
        SentFeedbackSuccessState()
      ];
      when(mockFeedbackRepo.sendFeedback(testFeedback, multipleImages))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.sendFeedback(testFeedback, multipleImages);
    });
  });
}
