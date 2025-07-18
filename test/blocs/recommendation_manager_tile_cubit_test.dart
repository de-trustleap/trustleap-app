import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late RecommendationManagerTileCubit recoManagerTileCubit;
  late MockRecommendationRepository mockRecoRepo;
  late MockUserRepository mockUserRepo;

  final mockUser = CustomUser(
    id: UniqueID.fromUniqueString("1"),
    firstName: "Test",
    lastName: "User",
    email: "test@example.com",
    role: Role.promoter,
    favoriteRecommendationIDs: [],
  );

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
        notes: "Test",
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
      when(mockRecoRepo.setAppointmentState(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusLoadingState>(),
        isA<RecommendationSetStatusSuccessState>()
      ]));
      recoManagerTileCubit.setAppointmentState(userRecommendation);
    });

    test(
        "should emit RecommendationSetStatusLoadingState and then RecommendationSetStatusFailureState when call has failed",
        () async {
      // Given
      when(mockRecoRepo.setAppointmentState(userRecommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusLoadingState>(),
        isA<RecommendationSetStatusFailureState>()
      ]));
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
        notes: "Test",
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
      when(mockRecoRepo.finishRecommendation(userRecommendation, true))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusLoadingState>(),
        isA<RecommendationSetFinishedSuccessState>()
      ]));
      recoManagerTileCubit.setFinished(userRecommendation, true);
    });

    test(
        "should emit RecommendationSetStatusLoadingState and then RecommendationSetStatusFailureState when call has failed",
        () async {
      // Given
      when(mockRecoRepo.finishRecommendation(userRecommendation, true))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusLoadingState>(),
        isA<RecommendationSetStatusFailureState>()
      ]));
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
        notes: "Test",
        recommendation: recommendation);

    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockRecoRepo.setFavorite(userRecommendation, "1"))
          .thenAnswer((_) async => right(userRecommendation));
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      // When
      recoManagerTileCubit.setFavorite(userRecommendation, "1");
      await untilCalled(mockRecoRepo.setFavorite(userRecommendation, "1"));
      // Then
      verify(mockRecoRepo.setFavorite(userRecommendation, "1"));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationManagerTileFavoriteUpdatedState when call was successful",
        () async {
      // Given
      when(mockRecoRepo.setFavorite(userRecommendation, "1"))
          .thenAnswer((_) async => right(userRecommendation));
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationManagerTileFavoriteUpdatedState>()
      ]));
      recoManagerTileCubit.setFavorite(userRecommendation, "1");
    });

    test(
        "should emit RecommendationSetStatusFailureState when call was successful",
        () async {
      // Given
      when(mockRecoRepo.setFavorite(userRecommendation, "1"))
          .thenAnswer((_) async => left(BackendFailure()));
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusFailureState>()
      ]));
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
        notes: "Test",
        recommendation: recommendation);
    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.setPriority(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      recoManagerTileCubit.setPriority(userRecommendation);
      await untilCalled(mockRecoRepo.setPriority(userRecommendation, mockUser.id.value));
      // Then
      verify(mockRecoRepo.setPriority(userRecommendation, mockUser.id.value));
      verifyNoMoreInteractions(mockRecoRepo);
    });
    test(
        "should emit RecommendationSetStatusSuccessState when call was successful",
        () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.setPriority(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationManagerTileGetUserSuccessState>(),
        isA<RecommendationSetStatusSuccessState>()
      ]));
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      recoManagerTileCubit.setPriority(userRecommendation);
    });

    test(
        "should emit RecommendationSetStatusFailureState when call was successful",
        () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.setPriority(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationManagerTileGetUserSuccessState>(),
        isA<RecommendationSetStatusFailureState>()
      ]));
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
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
        notes: "Test",
        recommendation: recommendation);
    test("should call recommendation repo when function is called", () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.setNotes(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      recoManagerTileCubit.setNotes(userRecommendation);
      await untilCalled(mockRecoRepo.setNotes(userRecommendation, mockUser.id.value));
      // Then
      verify(mockRecoRepo.setNotes(userRecommendation, mockUser.id.value));
      verifyNoMoreInteractions(mockRecoRepo);
    });
    test(
        "should emit RecommendationSetStatusSuccessState when call was successful",
        () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.setNotes(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationManagerTileGetUserSuccessState>(),
        isA<RecommendationSetStatusSuccessState>()
      ]));
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      recoManagerTileCubit.setNotes(userRecommendation);
    });
    test(
        "should emit RecommendationSetStatusFailureState when call was successful",
        () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.setNotes(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationManagerTileGetUserSuccessState>(),
        isA<RecommendationSetStatusFailureState>()
      ]));
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      recoManagerTileCubit.setNotes(userRecommendation);
    });
  });
}
