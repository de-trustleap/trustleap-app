import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late RecommendationManagerTileCubit recoManagerTileCubit;
  late MockRecommendationRepository mockRecoRepo;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockRecoRepo = MockRecommendationRepository();
    mockUserRepo = MockUserRepository();
    recoManagerTileCubit = RecommendationManagerTileCubit(mockRecoRepo, mockUserRepo);
  });

  test("init state should be RecommendationsInitial", () {
    expect(recoManagerTileCubit.state, RecommendationManagerTileInitial());
  });

  group("RecommendationManagerTileCubit_setAppointmentState", () {
    final date = DateTime.now();
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: StatusLevel.contactFormSent,
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        notesLastEdited: null,
        recommendation: recommendation);

    test("should call user repo when function is called", () async {
      // Given
      when(mockRecoRepo.setAppointmentState(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      recoManagerTileCubit.setAppointmentState(userRecommendation);
      await untilCalled(mockRecoRepo.setAppointmentState(userRecommendation));
      // Then
      verify(mockRecoRepo.setAppointmentState(userRecommendation));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationSetStatusLoadingState and then RecommendationSetStatusSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusLoadingState(recommendation: userRecommendation),
        RecommendationSetStatusSuccessState(recommendation: userRecommendation)
      ];
      when(mockRecoRepo.setAppointmentState(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setAppointmentState(userRecommendation);
    });

    test(
        "should emit RecommendationSetStatusLoadingState and then RecommendationSetStatusFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusLoadingState(recommendation: userRecommendation),
        RecommendationSetStatusFailureState(
            failure: BackendFailure(), recommendation: userRecommendation)
      ];
      when(mockRecoRepo.setAppointmentState(userRecommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setAppointmentState(userRecommendation);
    });
  });

  group("RecommendationManagerTileCubit_setFinished", () {
    final date = DateTime.now();
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: StatusLevel.appointment,
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        notesLastEdited: null,
        recommendation: recommendation);

    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockRecoRepo.finishRecommendation(userRecommendation, true))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      recoManagerTileCubit.setFinished(userRecommendation, true);
      await untilCalled(
          mockRecoRepo.finishRecommendation(userRecommendation, true));
      // Then
      verify(mockRecoRepo.finishRecommendation(userRecommendation, true));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationSetStatusLoadingState and then RecommendationSetFinishedSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusLoadingState(recommendation: userRecommendation),
        RecommendationSetFinishedSuccessState(
            recommendation: userRecommendation)
      ];
      when(mockRecoRepo.finishRecommendation(userRecommendation, true))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setFinished(userRecommendation, true);
    });

    test(
        "should emit RecommendationSetStatusLoadingState and then RecommendationSetStatusFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusLoadingState(recommendation: userRecommendation),
        RecommendationSetStatusFailureState(
            failure: BackendFailure(), recommendation: userRecommendation)
      ];
      when(mockRecoRepo.finishRecommendation(userRecommendation, true))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setFinished(userRecommendation, true);
    });
  });

  group("RecommendationManagerTileCubit_setFavorite", () {
    final date = DateTime.now();
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: StatusLevel.contactFormSent,
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        notesLastEdited: null,
        recommendation: recommendation);

    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockRecoRepo.setFavorite(userRecommendation, "1"))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      recoManagerTileCubit.setFavorite(userRecommendation, "1");
      await untilCalled(mockRecoRepo.setFavorite(userRecommendation, "1"));
      // Then
      verify(mockRecoRepo.setFavorite(userRecommendation, "1"));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationSetStatusSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusSuccessState(
            recommendation: userRecommendation, settedFavorite: true)
      ];
      when(mockRecoRepo.setFavorite(userRecommendation, "1"))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setFavorite(userRecommendation, "1");
    });

    test(
        "should emit RecommendationSetStatusFailureState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusFailureState(
            failure: BackendFailure(), recommendation: userRecommendation)
      ];
      when(mockRecoRepo.setFavorite(userRecommendation, "1"))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setFavorite(userRecommendation, "1");
    });
  });

  group("RecommendationManagerTileCubit_setPriority", () {
    final date = DateTime.now();
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: StatusLevel.contactFormSent,
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        notesLastEdited: null,
        recommendation: recommendation);
    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockRecoRepo.setPriority(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      recoManagerTileCubit.setPriority(userRecommendation);
      await untilCalled(mockRecoRepo.setPriority(userRecommendation));
      // Then
      verify(mockRecoRepo.setPriority(userRecommendation));
      verifyNoMoreInteractions(mockRecoRepo);
    });
    test(
        "should emit RecommendationSetStatusSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusSuccessState(
            recommendation: userRecommendation, settedPriority: true)
      ];
      when(mockRecoRepo.setPriority(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setPriority(userRecommendation);
    });

    test(
        "should emit RecommendationSetStatusFailureState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusFailureState(
            failure: BackendFailure(), recommendation: userRecommendation)
      ];
      when(mockRecoRepo.setPriority(userRecommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setPriority(userRecommendation);
    });
  });

  group("RecommendationManagerTileCubit_setNotes", () {
    final date = DateTime.now();
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: StatusLevel.contactFormSent,
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        notesLastEdited: null,
        recommendation: recommendation);
    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockRecoRepo.setNotes(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      recoManagerTileCubit.setNotes(userRecommendation);
      await untilCalled(mockRecoRepo.setNotes(userRecommendation));
      // Then
      verify(mockRecoRepo.setNotes(userRecommendation));
      verifyNoMoreInteractions(mockRecoRepo);
    });
    test(
        "should emit RecommendationSetStatusSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusSuccessState(
            recommendation: userRecommendation, settedNotes: true)
      ];
      when(mockRecoRepo.setNotes(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setNotes(userRecommendation);
    });
    test(
        "should emit RecommendationSetStatusFailureState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusFailureState(
            failure: BackendFailure(), recommendation: userRecommendation)
      ];
      when(mockRecoRepo.setNotes(userRecommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setNotes(userRecommendation);
    });
  });
}
