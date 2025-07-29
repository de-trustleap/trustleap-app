import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/last_viewed.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/constants.dart';
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
        statusTimestamps: null,
        promoterImageDownloadURL: null);

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
        statusTimestamps: null,
        promoterImageDownloadURL: null);
    final recommendations = [
      UserRecommendation(
          id: UniqueID.fromUniqueString("1"),
          recoID: "1",
          userID: userID,
          priority: RecommendationPriority.medium,
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
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
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
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
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
          landingPageID: "test-landing-page",
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
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        notes: "Test",
        recommendation: recommendation);
    test("should return item when call was successful", () async {
      // Given
      final expectedResult = right(userRecommendation);
      when(mockRecoRepo.setFavorite(userRecommendation, "1"))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      final result = await mockRecoRepo.setFavorite(userRecommendation, "1");
      // Then
      verify(mockRecoRepo.setFavorite(userRecommendation, "1"));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.setFavorite(userRecommendation, "1"))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.setFavorite(userRecommendation, "1");
      // Then
      verify(mockRecoRepo.setFavorite(userRecommendation, "1"));
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
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        notes: "Test",
        recommendation: recommendation);
    test("should return item when call was successful", () async {
      // Given
      final expectedResult = right(userRecommendation);
      when(mockRecoRepo.setPriority(userRecommendation, "user123"))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      final result = await mockRecoRepo.setPriority(userRecommendation, "user123");
      // Then
      verify(mockRecoRepo.setPriority(userRecommendation, "user123"));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.setPriority(userRecommendation, "user123"))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.setPriority(userRecommendation, "user123");
      // Then
      verify(mockRecoRepo.setPriority(userRecommendation, "user123"));
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
        statusTimestamps: {0: date, 1: date, 2: date},
        promoterImageDownloadURL: null);
    final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        notes: "Test",
        recommendation: recommendation);
    test("should return item when call was successful", () async {
      // Given
      final expectedResult = right(userRecommendation);
      when(mockRecoRepo.setNotes(userRecommendation, "user123"))
          .thenAnswer((_) async => right(userRecommendation));
      // When
      final result = await mockRecoRepo.setNotes(userRecommendation, "user123");
      // Then
      verify(mockRecoRepo.setNotes(userRecommendation, "user123"));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.setNotes(userRecommendation, "user123"))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.setNotes(userRecommendation, "user123");
      // Then
      verify(mockRecoRepo.setNotes(userRecommendation, "user123"));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_getRecommendationsCompany", () {
    final userID = "1";
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
    final promoterRecommendations = [
      PromoterRecommendations(
          promoter: CustomUser(
              id: UniqueID.fromUniqueString("2"),
              email: "test@example.com",
              firstName: "Test",
              lastName: "User",
              role: Role.promoter,
              place: "Test City",
              recommendationIDs: ["1"],
              createdAt: date),
          recommendations: [userRecommendation])
    ];

    test("should return promoter recommendations when call was successful", () async {
      // Given
      final expectedResult = right(promoterRecommendations);
      when(mockRecoRepo.getRecommendationsCompany(userID))
          .thenAnswer((_) async => right(promoterRecommendations));
      // When
      final result = await mockRecoRepo.getRecommendationsCompany(userID);
      // Then
      verify(mockRecoRepo.getRecommendationsCompany(userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRecoRepo.getRecommendationsCompany(userID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRecoRepo.getRecommendationsCompany(userID);
      // Then
      verify(mockRecoRepo.getRecommendationsCompany(userID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });

  group("RecommendationRepositoryImplementation_markAsViewed", () {
    final recommendationID = "recommendation123";
    final lastViewed = LastViewed(
      userID: "user123",
      viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
    );

    test("should call markAsViewed with correct parameters", () async {
      // Given
      when(mockRecoRepo.markAsViewed(recommendationID, lastViewed))
          .thenReturn(null);
      
      // When
      mockRecoRepo.markAsViewed(recommendationID, lastViewed);
      
      // Then
      verify(mockRecoRepo.markAsViewed(recommendationID, lastViewed)).called(1);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should handle multiple markAsViewed calls for same recommendation", () async {
      // Given
      final lastViewed1 = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final lastViewed2 = LastViewed(
        userID: "user456",
        viewedAt: DateTime(2023, 12, 25, 11, 0, 0),
      );
      
      when(mockRecoRepo.markAsViewed(recommendationID, lastViewed1))
          .thenReturn(null);
      when(mockRecoRepo.markAsViewed(recommendationID, lastViewed2))
          .thenReturn(null);
      
      // When
      mockRecoRepo.markAsViewed(recommendationID, lastViewed1);
      mockRecoRepo.markAsViewed(recommendationID, lastViewed2);
      
      // Then
      verify(mockRecoRepo.markAsViewed(recommendationID, lastViewed1)).called(1);
      verify(mockRecoRepo.markAsViewed(recommendationID, lastViewed2)).called(1);
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test("should handle markAsViewed with different recommendation IDs", () async {
      // Given
      final recommendationID1 = "recommendation123";
      final recommendationID2 = "recommendation456";
      final lastViewed1 = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      
      when(mockRecoRepo.markAsViewed(recommendationID1, lastViewed1))
          .thenReturn(null);
      when(mockRecoRepo.markAsViewed(recommendationID2, lastViewed1))
          .thenReturn(null);
      
      // When
      mockRecoRepo.markAsViewed(recommendationID1, lastViewed1);
      mockRecoRepo.markAsViewed(recommendationID2, lastViewed1);
      
      // Then
      verify(mockRecoRepo.markAsViewed(recommendationID1, lastViewed1)).called(1);
      verify(mockRecoRepo.markAsViewed(recommendationID2, lastViewed1)).called(1);
      verifyNoMoreInteractions(mockRecoRepo);
    });
  });
}
