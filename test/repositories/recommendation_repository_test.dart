import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockRecommendationRepository mockRecoRepo;

  setUp(() {
    mockRecoRepo = MockRecommendationRepository();
  });

  group("RecommendationRepositoryImplementation_SaveRecommendation", () {
    final userID = "1";
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Page1",
        landingPageID: "2",
        promotionTemplate: "Test",
        promoterName: "Tester",
        serviceProviderName: "Tester",
        defaultLandingPageID: "3",
        userID: "1",
        statusLevel: StatusLevel.recommendationSend,
        statusTimestamps: null);

    test("should return unit when saving of recommendation was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockRecoRepo.saveRecommendation(recommendation, userID))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockRecoRepo.saveRecommendation(recommendation, userID);
      // Then
      verify(mockRecoRepo.saveRecommendation(recommendation, userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.saveRecommendation(recommendation, userID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockRecoRepo.saveRecommendation(recommendation, userID);
      // Then
      verify(mockRecoRepo.saveRecommendation(recommendation, userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_GetRecommendations", () {
    final userID = "1";
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
        statusLevel: StatusLevel.recommendationSend,
        statusTimestamps: null);
    final recommendations = [
      UserRecommendation(
          id: UniqueID.fromUniqueString("1"),
          recoID: "1",
          userID: userID,
          priority: RecommendationPriority.medium,
          isFavorite: false,
          notes: "Test",
          recommendation: recommendation)
    ];
    test("should return recommendations when call was successful", () async {
      // Given
      final expectedResult = right(recommendations);
      when(mockRecoRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(recommendations));
      // When
      final result = await mockRecoRepo.getRecommendations(userID);
      // Then
      verify(mockRecoRepo.getRecommendations(userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.getRecommendations(userID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.getRecommendations(userID);
      // Then
      verify(mockRecoRepo.getRecommendations(userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_DeleteRecommendation", () {
    final recoID = "1";
    final userID = "1";
    final userRecoID = "1";
    test("should return unit when call was successful", () async {
      // Given
      final expectedResult = right(unit);
      when(mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID);
      // Then
      verify(mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID);
      // Then
      verify(mockRecoRepo.deleteRecommendation(recoID, userID, userRecoID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_SetAppointmentState", () {
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
        statusTimestamps: {0: date, 1: date, 2: date});
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        recommendation: recommendation);

    test("should return item when call was successful", () async {
      // Given
      final expectedResult = right(userRecommendation);
      when(mockRecoRepo.setAppointmentState(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      final result = await mockRecoRepo.setAppointmentState(userRecommendation);
      // Then
      verify(mockRecoRepo.setAppointmentState(userRecommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.setAppointmentState(userRecommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.setAppointmentState(userRecommendation);
      // Then
      verify(mockRecoRepo.setAppointmentState(userRecommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_finishRecommendation", () {
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
        statusTimestamps: {0: date, 1: date, 2: date});
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        recommendation: recommendation);

    test("should return item when call was successful", () async {
      // Given
      final expectedResult = right(userRecommendation);
      when(mockRecoRepo.finishRecommendation(userRecommendation, true))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      final result =
          await mockRecoRepo.finishRecommendation(userRecommendation, true);
      // Then
      verify(mockRecoRepo.finishRecommendation(userRecommendation, true));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.finishRecommendation(userRecommendation, true))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockRecoRepo.finishRecommendation(userRecommendation, true);
      // Then
      verify(mockRecoRepo.finishRecommendation(userRecommendation, true));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_getArchivedRecommendations",
      () {
    final userID = "1";
    final date = DateTime.now();
    final recommendations = [
      ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: userID,
          createdAt: null,
          finishedTimeStamp: date,
          expiresAt: null)
    ];

    test("should return items when call was successful", () async {
      // Given
      final expectedResult = right(recommendations);
      when(mockRecoRepo.getArchivedRecommendations(userID))
          .thenAnswer((_) async => right(recommendations));
      // When
      final result = await mockRecoRepo.getArchivedRecommendations(userID);
      // Then
      verify(mockRecoRepo.getArchivedRecommendations(userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.getArchivedRecommendations(userID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.getArchivedRecommendations(userID);
      // Then
      verify(mockRecoRepo.getArchivedRecommendations(userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_setFavorite", () {
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
        statusTimestamps: {0: date, 1: date, 2: date});
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        recommendation: recommendation);
    test("should return item when call was successful", () async {
      // Given
      final expectedResult = right(userRecommendation);
      when(mockRecoRepo.setFavorite(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      final result = await mockRecoRepo.setFavorite(userRecommendation);
      // Then
      verify(mockRecoRepo.setFavorite(userRecommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.setFavorite(userRecommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.setFavorite(userRecommendation);
      // Then
      verify(mockRecoRepo.setFavorite(userRecommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_setPriority", () {
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
        statusTimestamps: {0: date, 1: date, 2: date});
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        recommendation: recommendation);
    test("should return item when call was successful", () async {
      // Given
      final expectedResult = right(userRecommendation);
      when(mockRecoRepo.setPriority(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      final result = await mockRecoRepo.setPriority(userRecommendation);
      // Then
      verify(mockRecoRepo.setPriority(userRecommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.setPriority(userRecommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.setPriority(userRecommendation);
      // Then
      verify(mockRecoRepo.setPriority(userRecommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_setNotes", () {
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
        statusTimestamps: {0: date, 1: date, 2: date});
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        recommendation: recommendation);
    test("should return item when call was successful", () async {
      // Given
      final expectedResult = right(userRecommendation);
      when(mockRecoRepo.setNotes(userRecommendation))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      final result = await mockRecoRepo.setNotes(userRecommendation);
      // Then
      verify(mockRecoRepo.setNotes(userRecommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.setNotes(userRecommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.setNotes(userRecommendation);
      // Then
      verify(mockRecoRepo.setNotes(userRecommendation));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });
}
