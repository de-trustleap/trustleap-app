import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/last_viewed.dart';
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

  group("RecommendationManagerTileCubit_markAsViewed", () {
    const recommendationID = "recommendation123";
    
    test("should call recommendation repo when current user is available", () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.markAsViewed(any, any))
          .thenReturn(null);
      
      // Set up user first
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      
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
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.markAsViewed(any, any))
          .thenReturn(null);
      
      // Set up user first
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      
      // Then
      expectLater(recoManagerTileCubit.stream, emits(
        isA<RecommendationManagerTileViewedState>()
          .having((state) => state.recommendationID, 'recommendationID', recommendationID)
          .having((state) => state.lastViewed.userID, 'lastViewed.userID', mockUser.id.value)
      ));
      
      // When
      recoManagerTileCubit.markAsViewed(recommendationID);
    });

    test("should fetch user if currentUser is null", () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.markAsViewed(any, any))
          .thenReturn(null);
      
      // When - call markAsViewed without setting user first
      recoManagerTileCubit.markAsViewed(recommendationID);
      await untilCalled(mockUserRepo.getUser());
      
      // Then
      verify(mockUserRepo.getUser());
      verify(mockRecoRepo.markAsViewed(
        recommendationID,
        argThat(isA<LastViewed>().having((lv) => lv.userID, 'userID', mockUser.id.value))
      ));
    });

    test("should not call repo when user fetch fails", () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(BackendFailure()));
      
      // When
      recoManagerTileCubit.markAsViewed(recommendationID);
      await untilCalled(mockUserRepo.getUser());
      
      // Then
      verify(mockUserRepo.getUser());
      verifyNever(mockRecoRepo.markAsViewed(any, any));
    });

    test("should not call repo when currentUser is null after user fetch fails", () async {
      // Given - user fetch returns failure
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(BackendFailure()));
      
      // When
      recoManagerTileCubit.markAsViewed(recommendationID);
      await untilCalled(mockUserRepo.getUser());
      
      // Then - should not call repo
      verifyNever(mockRecoRepo.markAsViewed(any, any));
    });

    test("should use correct timestamp in LastViewed", () async {
      // Given
      final beforeCall = DateTime.now();
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(mockUser));
      when(mockRecoRepo.markAsViewed(any, any))
          .thenReturn(null);
      
      // Set up user first
      recoManagerTileCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      
      // When
      recoManagerTileCubit.markAsViewed(recommendationID);
      final afterCall = DateTime.now();
      
      // Then
      verify(mockRecoRepo.markAsViewed(
        recommendationID,
        argThat(isA<LastViewed>()
          .having((lv) => lv.userID, 'userID', mockUser.id.value)
          .having((lv) => lv.viewedAt.isAfter(beforeCall.subtract(Duration(seconds: 1))) && 
                         lv.viewedAt.isBefore(afterCall.add(Duration(seconds: 1))), 
                 'viewedAt within time range', true))
      ));
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
      verifyNoMoreInteractions(mockUserRepo);
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
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return empty string when user is not found", () async {
      // Given
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => left(NotFoundFailure()));
      
      // When
      final result = await recoManagerTileCubit.getUserDisplayName(testUserID);
      
      // Then
      expect(result, "");
      verify(mockUserRepo.getUserByID(userId: testUserID));
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should handle user with only firstName", () async {
      // Given
      final userWithOnlyFirstName = CustomUser(
        id: UniqueID.fromUniqueString(testUserID),
        firstName: "Anna",
        lastName: null,
        email: "anna@test.de",
      );
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => right(userWithOnlyFirstName));
      
      // When
      final result = await recoManagerTileCubit.getUserDisplayName(testUserID);
      
      // Then
      expect(result, "Anna");
      verify(mockUserRepo.getUserByID(userId: testUserID));
    });

    test("should handle user with only lastName", () async {
      // Given
      final userWithOnlyLastName = CustomUser(
        id: UniqueID.fromUniqueString(testUserID),
        firstName: null,
        lastName: "Schmidt",
        email: "schmidt@test.de",
      );
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => right(userWithOnlyLastName));
      
      // When
      final result = await recoManagerTileCubit.getUserDisplayName(testUserID);
      
      // Then
      expect(result, "Schmidt");
      verify(mockUserRepo.getUserByID(userId: testUserID));
    });

    test("should return empty string when user has no firstName and no lastName", () async {
      // Given
      final userWithNoNames = CustomUser(
        id: UniqueID.fromUniqueString(testUserID),
        firstName: null,
        lastName: null,
        email: "noname@test.de",
      );
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => right(userWithNoNames));
      
      // When
      final result = await recoManagerTileCubit.getUserDisplayName(testUserID);
      
      // Then
      expect(result, "");
      verify(mockUserRepo.getUserByID(userId: testUserID));
    });

    test("should handle user with empty firstName and lastName", () async {
      // Given
      final userWithEmptyNames = CustomUser(
        id: UniqueID.fromUniqueString(testUserID),
        firstName: "",
        lastName: "",
        email: "empty@test.de",
      );
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => right(userWithEmptyNames));
      
      // When
      final result = await recoManagerTileCubit.getUserDisplayName(testUserID);
      
      // Then
      expect(result, "");
      verify(mockUserRepo.getUserByID(userId: testUserID));
    });

    test("should handle permission denied failure", () async {
      // Given
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));
      
      // When
      final result = await recoManagerTileCubit.getUserDisplayName(testUserID);
      
      // Then
      expect(result, "");
      verify(mockUserRepo.getUserByID(userId: testUserID));
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should work with different user IDs", () async {
      // Given
      const userID1 = "user1";
      const userID2 = "user2";
      final user1 = CustomUser(
        id: UniqueID.fromUniqueString(userID1),
        firstName: "John",
        lastName: "Doe",
        email: "john@test.de",
      );
      final user2 = CustomUser(
        id: UniqueID.fromUniqueString(userID2),
        firstName: "Jane",
        lastName: "Smith",
        email: "jane@test.de",
      );
      
      when(mockUserRepo.getUserByID(userId: userID1))
          .thenAnswer((_) async => right(user1));
      when(mockUserRepo.getUserByID(userId: userID2))
          .thenAnswer((_) async => right(user2));
      
      // When
      final result1 = await recoManagerTileCubit.getUserDisplayName(userID1);
      final result2 = await recoManagerTileCubit.getUserDisplayName(userID2);
      
      // Then
      expect(result1, "John Doe");
      expect(result2, "Jane Smith");
      verify(mockUserRepo.getUserByID(userId: userID1));
      verify(mockUserRepo.getUserByID(userId: userID2));
    });
  });
}
