import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/landing_pages/application/landing_page_detail/landing_page_detail_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/legals/domain/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/legals/domain/legal_version.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late LandingPageDetailCubit detailCubit;
  late MockRecommendationRepository mockRecommendationRepo;
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockRecommendationRepo = MockRecommendationRepository();
    mockLandingPageRepo = MockLandingPageRepository();
    detailCubit =
        LandingPageDetailCubit(mockRecommendationRepo, mockLandingPageRepo);
  });

  test("init state should be LandingPageDetailInitial", () {
    expect(detailCubit.state, LandingPageDetailInitial());
  });

  group("LandingPageDetailCubit_LoadRecommendations_Company", () {
    const userId = "user-1";
    final promoterUser = CustomUser(
      id: UniqueID.fromUniqueString("p1"),
      landingPageIDs: ["lp1"],
    );
    final recommendation1 = UserRecommendation(
      id: UniqueID.fromUniqueString("rec-1"),
      recoID: "reco-1",
      userID: userId,
      priority: RecommendationPriority.medium,
      notes: null,
      recommendation: PersonalizedRecommendationItem(
        id: "item-1",
        name: "Test",
        reason: "Test Landing Page",
        landingPageID: "lp1",
        promotionTemplate: null,
        promoterName: null,
        serviceProviderName: null,
        defaultLandingPageID: null,
        statusLevel: StatusLevel.successful,
        statusTimestamps: null,
        userID: userId,
        promoterImageDownloadURL: null,
      ),
    );
    final promoterRecommendations = [
      PromoterRecommendations(
        promoter: promoterUser,
        recommendations: [recommendation1],
      ),
    ];
    final landingPages = [
      LandingPage(
        id: UniqueID.fromUniqueString("lp1"),
        name: "Test Landing Page",
        ownerID: UniqueID.fromUniqueString(userId),
      ),
    ];

    test(
        "should emit RecommendationsLoading and then RecommendationsSuccess when call was successful",
        () async {
      // Given
      when(mockRecommendationRepo
              .getRecommendationsCompanyWithArchived(userId))
          .thenAnswer((_) async => right(promoterRecommendations));
      when(mockLandingPageRepo.getAllLandingPages(["lp1"]))
          .thenAnswer((_) async => right(landingPages));
      final expectedResult = [
        LandingPageDetailRecommendationsLoading(),
        LandingPageDetailRecommendationsSuccess(
          recommendations: [recommendation1],
          promoterRecommendations: promoterRecommendations,
          allLandingPages: landingPages,
        ),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.loadRecommendations(
        userId: userId,
        role: Role.company,
      );
    });

    test(
        "should emit RecommendationsNotFound when NotFoundFailure is returned",
        () async {
      // Given
      when(mockRecommendationRepo
              .getRecommendationsCompanyWithArchived(userId))
          .thenAnswer((_) async => left(NotFoundFailure()));
      final expectedResult = [
        LandingPageDetailRecommendationsLoading(),
        LandingPageDetailRecommendationsNotFound(),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.loadRecommendations(
        userId: userId,
        role: Role.company,
      );
    });

    test(
        "should emit RecommendationsFailure when other failure is returned",
        () async {
      // Given
      when(mockRecommendationRepo
              .getRecommendationsCompanyWithArchived(userId))
          .thenAnswer((_) async => left(BackendFailure()));
      final expectedResult = [
        LandingPageDetailRecommendationsLoading(),
        LandingPageDetailRecommendationsFailure(failure: BackendFailure()),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.loadRecommendations(
        userId: userId,
        role: Role.company,
      );
    });

    test(
        "should emit RecommendationsSuccess with null allLandingPages when no landing page IDs exist",
        () async {
      // Given
      final promoterWithoutLandingPages = CustomUser(
        id: UniqueID.fromUniqueString("p2"),
      );
      final emptyPromoterRecs = [
        PromoterRecommendations(
          promoter: promoterWithoutLandingPages,
          recommendations: [],
        ),
      ];
      when(mockRecommendationRepo
              .getRecommendationsCompanyWithArchived(userId))
          .thenAnswer((_) async => right(emptyPromoterRecs));
      final expectedResult = [
        LandingPageDetailRecommendationsLoading(),
        LandingPageDetailRecommendationsSuccess(
          recommendations: [],
          promoterRecommendations: emptyPromoterRecs,
          allLandingPages: null,
        ),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.loadRecommendations(
        userId: userId,
        role: Role.company,
      );
    });
  });

  group("LandingPageDetailCubit_LoadRecommendations_Promoter", () {
    const userId = "user-1";
    final recommendations = <UserRecommendation>[
      UserRecommendation(
        id: UniqueID.fromUniqueString("rec-1"),
        recoID: "reco-1",
        userID: userId,
        priority: RecommendationPriority.medium,
        notes: null,
        recommendation: PersonalizedRecommendationItem(
          id: "item-1",
          name: "Test",
          reason: "Test Landing Page",
          landingPageID: "lp1",
          promotionTemplate: null,
          promoterName: null,
          serviceProviderName: null,
          defaultLandingPageID: null,
          statusLevel: StatusLevel.successful,
          statusTimestamps: null,
          userID: userId,
          promoterImageDownloadURL: null,
        ),
      ),
    ];
    final landingPageIds = ["lp1"];
    final landingPages = [
      LandingPage(
        id: UniqueID.fromUniqueString("lp1"),
        name: "Test Landing Page",
        ownerID: UniqueID.fromUniqueString(userId),
      ),
    ];

    test(
        "should emit RecommendationsLoading and then RecommendationsSuccess when call was successful",
        () async {
      // Given
      when(mockRecommendationRepo.getRecommendationsWithArchived(userId))
          .thenAnswer((_) async => right(recommendations));
      when(mockLandingPageRepo.getAllLandingPages(landingPageIds))
          .thenAnswer((_) async => right(landingPages));
      final expectedResult = [
        LandingPageDetailRecommendationsLoading(),
        LandingPageDetailRecommendationsSuccess(
          recommendations: recommendations,
          allLandingPages: landingPages,
        ),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.loadRecommendations(
        userId: userId,
        role: Role.promoter,
        landingPageIds: landingPageIds,
      );
    });

    test(
        "should emit RecommendationsNotFound when NotFoundFailure is returned",
        () async {
      // Given
      when(mockRecommendationRepo.getRecommendationsWithArchived(userId))
          .thenAnswer((_) async => left(NotFoundFailure()));
      final expectedResult = [
        LandingPageDetailRecommendationsLoading(),
        LandingPageDetailRecommendationsNotFound(),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.loadRecommendations(
        userId: userId,
        role: Role.promoter,
        landingPageIds: landingPageIds,
      );
    });

    test(
        "should emit RecommendationsFailure when other failure is returned",
        () async {
      // Given
      when(mockRecommendationRepo.getRecommendationsWithArchived(userId))
          .thenAnswer((_) async => left(BackendFailure()));
      final expectedResult = [
        LandingPageDetailRecommendationsLoading(),
        LandingPageDetailRecommendationsFailure(failure: BackendFailure()),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.loadRecommendations(
        userId: userId,
        role: Role.promoter,
        landingPageIds: landingPageIds,
      );
    });

    test(
        "should emit RecommendationsSuccess with null allLandingPages when no landing page IDs provided",
        () async {
      // Given
      when(mockRecommendationRepo.getRecommendationsWithArchived(userId))
          .thenAnswer((_) async => right(recommendations));
      final expectedResult = [
        LandingPageDetailRecommendationsLoading(),
        LandingPageDetailRecommendationsSuccess(
          recommendations: recommendations,
          allLandingPages: null,
        ),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.loadRecommendations(
        userId: userId,
        role: Role.promoter,
      );
    });
  });

  group("LandingPageDetailCubit_GetAssignedPromoters", () {
    final associatedUsersIDs = ["1", "2"];
    final unregisteredPromoters = [
      Promoter(id: UniqueID.fromUniqueString("1"), registered: false),
    ];
    final registeredPromoters = [
      Promoter(id: UniqueID.fromUniqueString("2"), registered: true),
    ];

    test("should call landingpage repo when function is called", () async {
      // Given
      when(mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(registeredPromoters));
      // When
      detailCubit.getAssignedPromoters(associatedUsersIDs);
      await untilCalled(
          mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs));
      await untilCalled(
          mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs));
      // Then
      verify(
          mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs));
      verify(
          mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit PromotersLoading and then PromotersSuccess when call was successful",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailPromotersLoading(),
        LandingPageDetailPromotersSuccess(
            promoters: unregisteredPromoters + registeredPromoters),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(registeredPromoters));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAssignedPromoters(associatedUsersIDs);
    });

    test(
        "should emit PromotersLoading and then PromotersFailure when getUnregisteredPromoters fails",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailPromotersLoading(),
        LandingPageDetailPromotersFailure(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAssignedPromoters(associatedUsersIDs);
    });

    test(
        "should emit PromotersLoading and then PromotersFailure when getRegisteredPromoters fails",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailPromotersLoading(),
        LandingPageDetailPromotersFailure(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(associatedUsersIDs))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAssignedPromoters(associatedUsersIDs);
    });

    test(
        "should emit PromotersLoading and then PromotersSuccess with empty list when associatedUsersIDs is null",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailPromotersLoading(),
        LandingPageDetailPromotersSuccess(promoters: []),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAssignedPromoters(null);
    });

    test(
        "should emit PromotersLoading and then PromotersSuccess with empty list when associatedUsersIDs is empty",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailPromotersLoading(),
        LandingPageDetailPromotersSuccess(promoters: []),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAssignedPromoters([]);
    });
  });

  group("LandingPageDetailCubit_GetAllPromotersForUser", () {
    final registeredIds = ["1", "2"];
    final unregisteredIds = ["3", "4"];
    final registeredPromoters = [
      Promoter(id: UniqueID.fromUniqueString("1"), registered: true),
      Promoter(id: UniqueID.fromUniqueString("2"), registered: true),
    ];
    final unregisteredPromoters = [
      Promoter(id: UniqueID.fromUniqueString("3"), registered: false),
      Promoter(id: UniqueID.fromUniqueString("4"), registered: false),
    ];
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString("user-1"),
      registeredPromoterIDs: registeredIds,
      unregisteredPromoterIDs: unregisteredIds,
    );

    test(
        "should emit AllPromotersLoading and then AllPromotersSuccess when call was successful",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailAllPromotersLoading(),
        LandingPageDetailAllPromotersSuccess(
            promoters: unregisteredPromoters + registeredPromoters),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(unregisteredIds))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(registeredIds))
          .thenAnswer((_) async => right(registeredPromoters));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAllPromotersForUser(testUser);
    });

    test(
        "should emit AllPromotersLoading and then AllPromotersFailure when getUnregisteredPromoters fails",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailAllPromotersLoading(),
        LandingPageDetailAllPromotersFailure(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(unregisteredIds))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAllPromotersForUser(testUser);
    });

    test(
        "should emit AllPromotersLoading and then AllPromotersFailure when getRegisteredPromoters fails",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailAllPromotersLoading(),
        LandingPageDetailAllPromotersFailure(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(unregisteredIds))
          .thenAnswer((_) async => right(unregisteredPromoters));
      when(mockLandingPageRepo.getRegisteredPromoters(registeredIds))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAllPromotersForUser(testUser);
    });

    test(
        "should emit AllPromotersLoading and then AllPromotersSuccess with empty list when user has no promoter IDs",
        () async {
      // Given
      final userWithNoPromoters = CustomUser(
        id: UniqueID.fromUniqueString("user-2"),
      );
      final expectedResult = [
        LandingPageDetailAllPromotersLoading(),
        LandingPageDetailAllPromotersSuccess(promoters: []),
      ];
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAllPromotersForUser(userWithNoPromoters);
    });

    test(
        "should emit success with only registered promoters when user has no unregistered promoter IDs",
        () async {
      // Given
      final userOnlyRegistered = CustomUser(
        id: UniqueID.fromUniqueString("user-3"),
        registeredPromoterIDs: registeredIds,
      );
      final expectedResult = [
        LandingPageDetailAllPromotersLoading(),
        LandingPageDetailAllPromotersSuccess(promoters: registeredPromoters),
      ];
      when(mockLandingPageRepo.getRegisteredPromoters(registeredIds))
          .thenAnswer((_) async => right(registeredPromoters));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAllPromotersForUser(userOnlyRegistered);
    });

    test(
        "should emit success with only unregistered promoters when user has no registered promoter IDs",
        () async {
      // Given
      final userOnlyUnregistered = CustomUser(
        id: UniqueID.fromUniqueString("user-4"),
        unregisteredPromoterIDs: unregisteredIds,
      );
      final expectedResult = [
        LandingPageDetailAllPromotersLoading(),
        LandingPageDetailAllPromotersSuccess(
            promoters: unregisteredPromoters),
      ];
      when(mockLandingPageRepo.getUnregisteredPromoters(unregisteredIds))
          .thenAnswer((_) async => right(unregisteredPromoters));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getAllPromotersForUser(userOnlyUnregistered);
    });
  });

  group("LandingPageDetailCubit_GetArchivedLandingPageLegals", () {
    const landingPageId = "1";
    final testArchivedLegals = ArchivedLandingPageLegals(
      id: landingPageId,
      privacyPolicyVersions: [
        LegalVersion(
          content: "Privacy v1",
          archivedAt: DateTime(2024, 1, 1),
          version: 1,
        ),
      ],
    );

    test("should call landingpage repo when function is called", () async {
      // Given
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => right(testArchivedLegals));
      // When
      detailCubit.getArchivedLandingPageLegals(landingPageId);
      await untilCalled(
          mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId));
      // Then
      verify(
          mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit ArchivedLegalsLoading and then ArchivedLegalsSuccess when call was successful",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailArchivedLegalsLoading(),
        LandingPageDetailArchivedLegalsSuccess(
            archivedLegals: testArchivedLegals),
      ];
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => right(testArchivedLegals));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getArchivedLandingPageLegals(landingPageId);
    });

    test(
        "should emit ArchivedLegalsLoading and then ArchivedLegalsFailure when call has failed",
        () async {
      // Given
      final expectedResult = [
        LandingPageDetailArchivedLegalsLoading(),
        LandingPageDetailArchivedLegalsFailure(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.getArchivedLandingPageLegals(landingPageId))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(detailCubit.stream, emitsInOrder(expectedResult));
      detailCubit.getArchivedLandingPageLegals(landingPageId);
    });
  });
}
