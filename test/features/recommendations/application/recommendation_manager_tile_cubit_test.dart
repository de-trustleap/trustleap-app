import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/last_viewed.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

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
    recoManagerTileCubit.setCurrentUser(mockUser);
  });

  test("init state should be RecommendationsInitial", () {
    expect(recoManagerTileCubit.state, RecommendationManagerTileInitial());
  });

  group("RecommendationManagerTileCubit_setAppointmentState", () {
    final date = DateTime.now();
    final recommendation = PersonalizedRecommendationItem(
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
    final recommendation = PersonalizedRecommendationItem(
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
    final recommendation = PersonalizedRecommendationItem(
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
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusFailureState>()
      ]));
      recoManagerTileCubit.setFavorite(userRecommendation, "1");
    });
  });

  group("RecommendationManagerTileCubit_setPriority", () {
    final date = DateTime.now();
    final recommendation = PersonalizedRecommendationItem(
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
      when(mockRecoRepo.setPriority(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => right(userRecommendation));
      // When
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
      when(mockRecoRepo.setPriority(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusSuccessState>()
      ]));
      recoManagerTileCubit.setPriority(userRecommendation);
    });

    test(
        "should emit RecommendationSetStatusFailureState when call was successful",
        () async {
      // Given
      when(mockRecoRepo.setPriority(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusFailureState>()
      ]));
      recoManagerTileCubit.setPriority(userRecommendation);
    });
  });

  group("RecommendationManagerTileCubit_setNotes", () {
    final date = DateTime.now();
    final recommendation = PersonalizedRecommendationItem(
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
      when(mockRecoRepo.setNotes(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => right(userRecommendation));
      // When
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
      when(mockRecoRepo.setNotes(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => right(userRecommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusSuccessState>()
      ]));
      recoManagerTileCubit.setNotes(userRecommendation);
    });
    test(
        "should emit RecommendationSetStatusFailureState when call was successful",
        () async {
      // Given
      when(mockRecoRepo.setNotes(userRecommendation, mockUser.id.value))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder([
        isA<RecommendationSetStatusFailureState>()
      ]));
      recoManagerTileCubit.setNotes(userRecommendation);
    });
  });

  group("RecommendationManagerTileCubit_markAsViewed", () {
    const recommendationID = "recommendation123";
    
    test("should call recommendation repo when current user is available", () async {
      // Given
      when(mockRecoRepo.markAsViewed(any, any))
          .thenReturn(null);
      
      // When
      recoManagerTileCubit.markAsViewed(recommendationID);
      
      // Then
      verify(mockRecoRepo.markAsViewed(
        recommendationID, 
        argThat(isA<LastViewed>().having((lv) => lv.userID, 'userID', mockUser.id.value))
      ));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should emit RecommendationManagerTileViewedState when call is successful", () async {
      // Given
      when(mockRecoRepo.markAsViewed(any, any))
          .thenReturn(null);
      
      // Then
      expectLater(recoManagerTileCubit.stream, emits(
        isA<RecommendationManagerTileViewedState>()
          .having((state) => state.recommendationID, 'recommendationID', recommendationID)
          .having((state) => state.lastViewed.userID, 'lastViewed.userID', mockUser.id.value)
      ));
      
      // When
      recoManagerTileCubit.markAsViewed(recommendationID);
    });
  });

  group("RecommendationManagerTileCubit_getUserDisplayName", () {
    const testUserID = "user123";
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString(testUserID),
      firstName: "Max",
      lastName: "Mustermann",
      email: "max@test.de",
      role: Role.company,
    );

    test("should return formatted display name when user is found", () async {
      // Given
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => right(testUser));
      
      // When
      final result = await recoManagerTileCubit.getUserDisplayName(testUserID);
      
      // Then
      expect(result, "Max Mustermann");
      verify(mockUserRepo.getUserByID(userId: testUserID));
    });

    test("should return empty string when user repository fails", () async {
      // Given
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => left(BackendFailure()));
      
      // When
      final result = await recoManagerTileCubit.getUserDisplayName(testUserID);
      
      // Then
      expect(result, "");
      verify(mockUserRepo.getUserByID(userId: testUserID));
    });
  });

}
