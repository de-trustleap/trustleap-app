import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late DashboardRecommendationsCubit cubit;
  late MockRecommendationRepository mockRecommendationRepo;

  setUp(() {
    mockRecommendationRepo = MockRecommendationRepository();
    cubit = DashboardRecommendationsCubit(mockRecommendationRepo);
  });

  group("DashboardRecommendationsCubit_InitialState", () {
    test("init state should be DashboardRecommendationsInitial", () {
      expect(cubit.state, DashboardRecommendationsInitial());
    });
  });

  group("DashboardRecommendationsCubit_GetRecommendationsCompany", () {
    final userID = "1";
    final date = DateTime.now();
    
    final testPromoter = CustomUser(
        id: UniqueID.fromUniqueString("2"),
        email: "test@example.com",
        firstName: "Test",
        lastName: "User",
        role: Role.promoter,
        place: "Test City",
        recommendationIDs: ["1"],
        createdAt: date);

    final testRecommendation = RecommendationItem(
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

    final testUserRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        notesLastEdited: null,
        recommendation: testRecommendation);

    final testPromoterRecommendations = [
      PromoterRecommendations(
          promoter: testPromoter,
          recommendations: [testUserRecommendation])
    ];

    test("should call repo if getRecommendationsCompany is called", () async {
      // Given
      when(mockRecommendationRepo.getRecommendationsCompany(userID))
          .thenAnswer((_) async => right(testPromoterRecommendations));

      // When
      cubit.getRecommendationsCompany(userID);
      await untilCalled(mockRecommendationRepo.getRecommendationsCompany(userID));

      // Then
      verify(mockRecommendationRepo.getRecommendationsCompany(userID));
      verifyNoMoreInteractions(mockRecommendationRepo);
    });

    test("should emit LoadingState and then SuccessState when getRecommendationsCompany is called", () {
      // Given
      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosSuccessState(
          recommendation: [testUserRecommendation],
          promoterRecommendations: testPromoterRecommendations,
        )
      ];
      when(mockRecommendationRepo.getRecommendationsCompany(userID))
          .thenAnswer((_) async => right(testPromoterRecommendations));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRecommendationsCompany(userID);
    });

    test("should emit LoadingState and then FailureState when getRecommendationsCompany fails", () {
      // Given
      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosFailureState(failure: BackendFailure())
      ];
      when(mockRecommendationRepo.getRecommendationsCompany(userID))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRecommendationsCompany(userID);
    });

    test("should emit LoadingState and then NotFoundFailureState when getRecommendationsCompany returns NotFoundFailure", () {
      // Given
      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosNotFoundFailureState()
      ];
      when(mockRecommendationRepo.getRecommendationsCompany(userID))
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRecommendationsCompany(userID);
    });
  });

  group("DashboardRecommendationsCubit_GetRecommendationsPromoter", () {
    final userID = "1";
    final date = DateTime.now();
    
    final testRecommendation = RecommendationItem(
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

    final testUserRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,
        isFavorite: false,
        notes: "Test",
        notesLastEdited: null,
        recommendation: testRecommendation);

    final testRecommendations = [testUserRecommendation];

    test("should call repo if getRecommendationsPromoter is called", () async {
      // Given
      when(mockRecommendationRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(testRecommendations));

      // When
      cubit.getRecommendationsPromoter(userID);
      await untilCalled(mockRecommendationRepo.getRecommendations(userID));

      // Then
      verify(mockRecommendationRepo.getRecommendations(userID));
      verifyNoMoreInteractions(mockRecommendationRepo);
    });

    test("should emit LoadingState and then SuccessState when getRecommendationsPromoter is called", () {
      // Given
      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosSuccessState(
          recommendation: testRecommendations,
        )
      ];
      when(mockRecommendationRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(testRecommendations));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRecommendationsPromoter(userID);
    });

    test("should emit LoadingState and then FailureState when getRecommendationsPromoter fails", () {
      // Given
      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosFailureState(failure: BackendFailure())
      ];
      when(mockRecommendationRepo.getRecommendations(userID))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRecommendationsPromoter(userID);
    });

    test("should emit LoadingState and then NotFoundFailureState when getRecommendationsPromoter returns NotFoundFailure", () {
      // Given
      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosNotFoundFailureState()
      ];
      when(mockRecommendationRepo.getRecommendations(userID))
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRecommendationsPromoter(userID);
    });
  });
}