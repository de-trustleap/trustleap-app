import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/feedback/feedback_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/feedback_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  late FeedbackCubit feedbackCubit;
  late MockFeedbackRepository mockFeedbackRepo;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockFeedbackRepo = MockFeedbackRepository();
    mockUserRepo = MockUserRepository();
    feedbackCubit = FeedbackCubit(mockFeedbackRepo, mockUserRepo);
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

  group("FeedbackCubit_GetUser", () {
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString("test-user-id"),
      email: "test@example.com",
      firstName: "Test",
      lastName: "User",
      role: Role.promoter,
    );

    test("should call user repo when function is called", () async {
      // Given
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(testUser));

      // When
      feedbackCubit.getUser();
      await untilCalled(mockUserRepo.getUser());

      // Then
      verify(mockUserRepo.getUser());
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit FeedbackGetUserLoadingState and then FeedbackGetUserSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        FeedbackGetUserLoadingState(),
        FeedbackGetUserSuccessState(user: testUser)
      ];
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(testUser));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.getUser();
    });

    test(
        "should emit FeedbackGetUserLoadingState and then FeedbackGetUserFailureState when call has failed with PermissionDeniedFailure",
        () async {
      // Given
      final expectedResult = [
        FeedbackGetUserLoadingState(),
        FeedbackGetUserFailureState(failure: PermissionDeniedFailure())
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.getUser();
    });

    test(
        "should emit FeedbackGetUserLoadingState and then FeedbackGetUserFailureState when call has failed with BackendFailure",
        () async {
      // Given
      final expectedResult = [
        FeedbackGetUserLoadingState(),
        FeedbackGetUserFailureState(failure: BackendFailure())
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.getUser();
    });

    test(
        "should emit FeedbackGetUserLoadingState and then FeedbackGetUserFailureState when call has failed with UnavailableFailure",
        () async {
      // Given
      final expectedResult = [
        FeedbackGetUserLoadingState(),
        FeedbackGetUserFailureState(failure: UnavailableFailure())
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(UnavailableFailure()));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.getUser();
    });

    test(
        "should emit FeedbackGetUserLoadingState and then FeedbackGetUserFailureState when call has failed with NotFoundFailure",
        () async {
      // Given
      final expectedResult = [
        FeedbackGetUserLoadingState(),
        FeedbackGetUserFailureState(failure: NotFoundFailure())
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.getUser();
    });

    test("should handle user with minimal data correctly", () async {
      // Given
      final minimalUser = CustomUser(
        id: UniqueID.fromUniqueString("minimal-user-id"),
        role: Role.none,
      );
      final expectedResult = [
        FeedbackGetUserLoadingState(),
        FeedbackGetUserSuccessState(user: minimalUser)
      ];
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(minimalUser));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.getUser();
    });

    test("should handle user with complete data correctly", () async {
      // Given
      final completeUser = CustomUser(
        id: UniqueID.fromUniqueString("complete-user-id"),
        email: "complete@example.com",
        firstName: "Complete",
        lastName: "User",
        role: Role.company,
        gender: Gender.male,
        birthDate: "1990-01-01",
        address: "Test Street 123",
        postCode: "12345",
        place: "Test City",
      );
      final expectedResult = [
        FeedbackGetUserLoadingState(),
        FeedbackGetUserSuccessState(user: completeUser)
      ];
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(completeUser));

      // Then
      expectLater(feedbackCubit.stream, emitsInOrder(expectedResult));
      feedbackCubit.getUser();
    });
  });
}
