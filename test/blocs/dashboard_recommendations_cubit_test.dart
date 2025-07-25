import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
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
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockRecommendationRepo = MockRecommendationRepository();
    mockLandingPageRepo = MockLandingPageRepository();
    cubit = DashboardRecommendationsCubit(mockRecommendationRepo, mockLandingPageRepo);
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
        landingPageIDs: ["lp1", "lp2"],
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

        notes: "Test",
        recommendation: testRecommendation);

    final testPromoterRecommendations = [
      PromoterRecommendations(
          promoter: testPromoter,
          recommendations: [testUserRecommendation])
    ];

    final testLandingPages = [
      LandingPage(
        id: UniqueID.fromUniqueString("lp1"),
        name: "Landing Page 1",
      ),
      LandingPage(
        id: UniqueID.fromUniqueString("lp2"),
        name: "Landing Page 2",
      ),
    ];

    test("should call repo if getRecommendationsCompany is called", () async {
      // Given
      when(mockRecommendationRepo.getRecommendationsCompany(userID))
          .thenAnswer((_) async => right(testPromoterRecommendations));
      when(mockLandingPageRepo.getAllLandingPages(["lp1", "lp2"]))
          .thenAnswer((_) async => right(testLandingPages));

      // When
      cubit.getRecommendationsCompany(userID);
      await untilCalled(mockRecommendationRepo.getRecommendationsCompany(userID));

      // Then
      verify(mockRecommendationRepo.getRecommendationsCompany(userID));
      verify(mockLandingPageRepo.getAllLandingPages(["lp1", "lp2"]));
      verifyNoMoreInteractions(mockRecommendationRepo);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should emit LoadingState and then SuccessState when getRecommendationsCompany is called", () {
      // Given
      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosSuccessState(
          recommendation: [testUserRecommendation],
          promoterRecommendations: testPromoterRecommendations,
          allLandingPages: testLandingPages,
          filteredLandingPages: testLandingPages,
        )
      ];
      when(mockRecommendationRepo.getRecommendationsCompany(userID))
          .thenAnswer((_) async => right(testPromoterRecommendations));
      when(mockLandingPageRepo.getAllLandingPages(["lp1", "lp2"]))
          .thenAnswer((_) async => right(testLandingPages));

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

        notes: "Test",
        recommendation: testRecommendation);

    final testRecommendations = [testUserRecommendation];
    final landingPageIDs = ["lp1", "lp2"];
    final testPromoterLandingPages = [
      LandingPage(
        id: UniqueID.fromUniqueString("lp1"),
        name: "Promoter Landing Page 1",
      ),
      LandingPage(
        id: UniqueID.fromUniqueString("lp2"),
        name: "Promoter Landing Page 2",
      ),
    ];

    test("should call repo if getRecommendationsPromoter is called", () async {
      // Given
      when(mockRecommendationRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(testRecommendations));
      when(mockLandingPageRepo.getAllLandingPages(landingPageIDs))
          .thenAnswer((_) async => right(testPromoterLandingPages));

      // When
      cubit.getRecommendationsPromoter(userID, landingPageIDs);
      await untilCalled(mockRecommendationRepo.getRecommendations(userID));

      // Then
      verify(mockRecommendationRepo.getRecommendations(userID));
      verify(mockLandingPageRepo.getAllLandingPages(landingPageIDs));
      verifyNoMoreInteractions(mockRecommendationRepo);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test("should emit LoadingState and then SuccessState when getRecommendationsPromoter is called", () {
      // Given
      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosSuccessState(
          recommendation: testRecommendations,
          allLandingPages: testPromoterLandingPages,
          filteredLandingPages: testPromoterLandingPages,
        )
      ];
      when(mockRecommendationRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(testRecommendations));
      when(mockLandingPageRepo.getAllLandingPages(landingPageIDs))
          .thenAnswer((_) async => right(testPromoterLandingPages));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRecommendationsPromoter(userID, landingPageIDs);
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
      cubit.getRecommendationsPromoter(userID, landingPageIDs);
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
      cubit.getRecommendationsPromoter(userID, landingPageIDs);
    });
  });

  group("DashboardRecommendationsCubit_FilterLandingPagesForPromoter", () {
    final date = DateTime.now();
    
    final promoter1 = CustomUser(
      id: UniqueID.fromUniqueString("promoter1"),
      email: "promoter1@example.com",
      firstName: "John",
      lastName: "Doe",
      role: Role.promoter,
      landingPageIDs: ["lp1", "lp2"],
      createdAt: date,
    );

    final promoter2 = CustomUser(
      id: UniqueID.fromUniqueString("promoter2"),
      email: "promoter2@example.com",
      firstName: "Jane",
      lastName: "Smith",
      role: Role.promoter,
      landingPageIDs: ["lp3"],
      createdAt: date,
    );

    final testUserRecommendation = UserRecommendation(
      id: UniqueID.fromUniqueString("1"),
      recoID: "1",
      userID: "1",
      priority: RecommendationPriority.medium,
      notes: "Test",
      recommendation: null,
    );

    final promoterRecommendations = [
      PromoterRecommendations(promoter: promoter1, recommendations: [testUserRecommendation]),
      PromoterRecommendations(promoter: promoter2, recommendations: [testUserRecommendation]),
    ];

    final allLandingPages = [
      LandingPage(
        id: UniqueID.fromUniqueString("lp1"),
        name: "Landing Page 1",
      ),
      LandingPage(
        id: UniqueID.fromUniqueString("lp2"),
        name: "Landing Page 2", 
      ),
      LandingPage(
        id: UniqueID.fromUniqueString("lp3"),
        name: "Landing Page 3",
      ),
    ];

    test("should filter landing pages for selected promoter", () {
      // Given
      final initialState = DashboardRecommendationsGetRecosSuccessState(
        recommendation: [testUserRecommendation],
        promoterRecommendations: promoterRecommendations,
        allLandingPages: allLandingPages,
        filteredLandingPages: allLandingPages,
      );
      cubit.emit(initialState);

      // When
      cubit.filterLandingPagesForPromoter("promoter1");

      // Then
      final state = cubit.state as DashboardRecommendationsGetRecosSuccessState;
      expect(state.filteredLandingPages?.length, equals(2));
      expect(state.filteredLandingPages?.map((lp) => lp.id.value), containsAll(["lp1", "lp2"]));
      expect(state.allLandingPages, equals(allLandingPages)); // allLandingPages should remain unchanged
    });

    test("should show all landing pages when no promoter selected", () {
      // Given
      final initialState = DashboardRecommendationsGetRecosSuccessState(
        recommendation: [testUserRecommendation],
        promoterRecommendations: promoterRecommendations,
        allLandingPages: allLandingPages,
        filteredLandingPages: [allLandingPages.first], // Start with filtered list
      );
      cubit.emit(initialState);

      // When
      cubit.filterLandingPagesForPromoter(null);

      // Then
      final state = cubit.state as DashboardRecommendationsGetRecosSuccessState;
      expect(state.filteredLandingPages, equals(allLandingPages));
    });

    test("should return empty list when promoter has no landing pages", () {
      // Given
      final promoterWithoutLandingPages = CustomUser(
        id: UniqueID.fromUniqueString("promoter3"),
        email: "promoter3@example.com",
        firstName: "Bob",
        lastName: "Wilson",
        role: Role.promoter,
        landingPageIDs: null, // No landing pages
        createdAt: date,
      );

      final promoterRecommendationsWithEmptyPromoter = [
        PromoterRecommendations(promoter: promoter1, recommendations: [testUserRecommendation]),
        PromoterRecommendations(promoter: promoterWithoutLandingPages, recommendations: [testUserRecommendation]),
      ];

      final initialState = DashboardRecommendationsGetRecosSuccessState(
        recommendation: [testUserRecommendation],
        promoterRecommendations: promoterRecommendationsWithEmptyPromoter,
        allLandingPages: allLandingPages,
        filteredLandingPages: allLandingPages,
      );
      cubit.emit(initialState);

      // When
      cubit.filterLandingPagesForPromoter("promoter3");

      // Then
      final state = cubit.state as DashboardRecommendationsGetRecosSuccessState;
      expect(state.filteredLandingPages, isEmpty);
    });

    test("should handle state when not success state", () {
      // Given
      cubit.emit(DashboardRecommendationsGetRecosLoadingState());

      // When
      cubit.filterLandingPagesForPromoter("promoter1");

      // Then
      expect(cubit.state, isA<DashboardRecommendationsGetRecosLoadingState>());
    });
  });

  group("DashboardRecommendationsCubit_LandingPageHandling", () {
    final userID = "1";
    final landingPageIDs = ["lp1", "lp2"];

    test("should handle empty landing page list for promoter", () {
      // Given
      final testRecommendations = [
        UserRecommendation(
          id: UniqueID.fromUniqueString("1"),
          recoID: "1",
          userID: "1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: null,
        )
      ];

      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosSuccessState(
          recommendation: testRecommendations,
          allLandingPages: null,
          filteredLandingPages: null,
        )
      ];

      when(mockRecommendationRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(testRecommendations));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      
      // When
      cubit.getRecommendationsPromoter(userID, []); // Empty landing page list
    });

    test("should handle landing page repository failure", () {
      // Given
      final testRecommendations = [
        UserRecommendation(
          id: UniqueID.fromUniqueString("1"),
          recoID: "1",
          userID: "1",
          priority: RecommendationPriority.medium,
          notes: "Test",
          recommendation: null,
        )
      ];

      final expectedResult = [
        DashboardRecommendationsGetRecosLoadingState(),
        DashboardRecommendationsGetRecosSuccessState(
          recommendation: testRecommendations,
          allLandingPages: null,
          filteredLandingPages: null,
        )
      ];

      when(mockRecommendationRepo.getRecommendations(userID))
          .thenAnswer((_) async => right(testRecommendations));
      when(mockLandingPageRepo.getAllLandingPages(landingPageIDs))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));

      // When
      cubit.getRecommendationsPromoter(userID, landingPageIDs);
    });
  });
}