import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/feedback/application/admin_feedback/admin_feedback_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_item.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  late AdminFeedbackCubit adminFeedbackCubit;
  late MockFeedbackRepository mockFeedbackRepo;

  setUp(() {
    mockFeedbackRepo = MockFeedbackRepository();
    adminFeedbackCubit = AdminFeedbackCubit(mockFeedbackRepo);
  });

  test("init state should be AdminFeedbackInitial", () {
    expect(adminFeedbackCubit.state, AdminFeedbackInitial());
  });

  group("AdminFeedbackCubit_GetFeedbackItems", () {
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

    test("should call feedback repo when function is called", () async {
      // Given
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => right(testFeedbackItems));

      // When
      adminFeedbackCubit.getFeedbackItems();
      await untilCalled(mockFeedbackRepo.getFeedbackItems());

      // Then
      verify(mockFeedbackRepo.getFeedbackItems());
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should emit AdminFeedbackGetFeedbackLoadingState and then AdminFeedbackGetFeedbackSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackGetFeedbackSuccessState(feedbacks: testFeedbackItems)
      ];
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => right(testFeedbackItems));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.getFeedbackItems();
    });

    test(
        "should emit AdminFeedbackGetFeedbackLoadingState and then AdminFeedbackNoFeedbackFoundState when call was successful but no feedback found",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackNoFeedbackFoundState()
      ];
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.getFeedbackItems();
    });

    test(
        "should emit AdminFeedbackGetFeedbackLoadingState and then AdminFeedbackGetFeedbackFailureState when call has failed with PermissionDeniedFailure",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackGetFeedbackFailureState(failure: PermissionDeniedFailure())
      ];
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.getFeedbackItems();
    });

    test(
        "should emit AdminFeedbackGetFeedbackLoadingState and then AdminFeedbackGetFeedbackFailureState when call has failed with BackendFailure",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackGetFeedbackFailureState(failure: BackendFailure())
      ];
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.getFeedbackItems();
    });
  });

  group("AdminFeedbackCubit_DeleteFeedback", () {
    const testFeedbackId = "test-feedback-id";
    final testFeedbackItems = <FeedbackItem>[
      FeedbackItem(
        id: UniqueID.fromUniqueString("remaining-id"),
        title: "Remaining Feedback",
        description: "This feedback remains after deletion",
        type: FeedbackType.feedback,
      ),
    ];

    test("should call delete feedback repo and then getFeedbackItems when function is called", () async {
      // Given
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => right(unit));
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => right(testFeedbackItems));

      // When
      adminFeedbackCubit.deleteFeedback(testFeedbackId);
      await untilCalled(mockFeedbackRepo.deleteFeedback(testFeedbackId));
      await untilCalled(mockFeedbackRepo.getFeedbackItems());

      // Then
      verify(mockFeedbackRepo.deleteFeedback(testFeedbackId));
      verify(mockFeedbackRepo.getFeedbackItems());
      verifyNoMoreInteractions(mockFeedbackRepo);
    });

    test(
        "should emit LoadingState, then SuccessState with remaining items when delete was successful",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackGetFeedbackSuccessState(feedbacks: testFeedbackItems)
      ];
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => right(unit));
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => right(testFeedbackItems));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.deleteFeedback(testFeedbackId);
    });

    test(
        "should emit LoadingState, then NoFeedbackFoundState when delete was successful but no feedback items remain",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackNoFeedbackFoundState()
      ];
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => right(unit));
      when(mockFeedbackRepo.getFeedbackItems())
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.deleteFeedback(testFeedbackId);
    });

    test(
        "should emit LoadingState and then FailureState when delete has failed with PermissionDeniedFailure",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackGetFeedbackFailureState(failure: PermissionDeniedFailure())
      ];
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.deleteFeedback(testFeedbackId);
    });

    test(
        "should emit LoadingState and then FailureState when delete has failed with BackendFailure",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackGetFeedbackFailureState(failure: BackendFailure())
      ];
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.deleteFeedback(testFeedbackId);
    });

    test(
        "should emit LoadingState and then FailureState when delete has failed with UnavailableFailure",
        () async {
      // Given
      final expectedResult = [
        AdminFeedbackGetFeedbackLoadingState(),
        AdminFeedbackGetFeedbackFailureState(failure: UnavailableFailure())
      ];
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => left(UnavailableFailure()));

      // Then
      expectLater(adminFeedbackCubit.stream, emitsInOrder(expectedResult));
      adminFeedbackCubit.deleteFeedback(testFeedbackId);
    });

    test(
        "should not call getFeedbackItems when delete fails",
        () async {
      // Given
      when(mockFeedbackRepo.deleteFeedback(testFeedbackId))
          .thenAnswer((_) async => left(BackendFailure()));

      // When
      adminFeedbackCubit.deleteFeedback(testFeedbackId);
      await untilCalled(mockFeedbackRepo.deleteFeedback(testFeedbackId));

      // Then
      verify(mockFeedbackRepo.deleteFeedback(testFeedbackId));
      verifyNever(mockFeedbackRepo.getFeedbackItems());
      verifyNoMoreInteractions(mockFeedbackRepo);
    });
  });
}