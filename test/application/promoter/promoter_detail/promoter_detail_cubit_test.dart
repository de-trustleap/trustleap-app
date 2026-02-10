import "package:dartz/dartz.dart";
import "package:finanzbegleiter/application/promoter/promoter_detail/promoter_detail_cubit.dart";
import "package:finanzbegleiter/constants.dart";
import "package:finanzbegleiter/core/failures/database_failures.dart";
import "package:finanzbegleiter/domain/entities/id.dart";
import "package:finanzbegleiter/domain/entities/landing_page.dart";
import "package:finanzbegleiter/domain/entities/promoter.dart";
import "package:finanzbegleiter/domain/entities/promoter_recommendations.dart";
import "package:finanzbegleiter/domain/entities/recommendation_item.dart";
import "package:finanzbegleiter/domain/entities/user.dart";
import "package:finanzbegleiter/domain/entities/user_recommendation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../mocks.mocks.dart";

void main() {
  late PromoterDetailCubit cubit;
  late MockPromoterRepository mockPromoterRepo;
  late MockRecommendationRepository mockRecommendationRepo;
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockPromoterRepo = MockPromoterRepository();
    mockRecommendationRepo = MockRecommendationRepository();
    mockLandingPageRepo = MockLandingPageRepository();
    cubit = PromoterDetailCubit(
      mockPromoterRepo,
      mockRecommendationRepo,
      mockLandingPageRepo,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final testPromoter = Promoter(
    id: UniqueID.fromUniqueString("promoter-1"),
    firstName: "Max",
    lastName: "Mustermann",
    email: "max@example.com",
    registered: true,
    landingPageIDs: ["lp-1", "lp-2"],
  );

  final testPromoterNoLandingPages = Promoter(
    id: UniqueID.fromUniqueString("promoter-2"),
    firstName: "Anna",
    lastName: "Schmidt",
    email: "anna@example.com",
    registered: true,
    landingPageIDs: [],
  );

  final testPromoterNullLandingPages = Promoter(
    id: UniqueID.fromUniqueString("promoter-3"),
    firstName: "Tom",
    lastName: "Müller",
    email: "tom@example.com",
    registered: false,
    landingPageIDs: null,
  );

  final testLandingPages = [
    LandingPage(
      id: UniqueID.fromUniqueString("lp-1"),
      name: "Altersvorsorge",
      isActive: true,
    ),
    LandingPage(
      id: UniqueID.fromUniqueString("lp-2"),
      name: "Berufsunfähigkeit",
      isActive: false,
    ),
  ];

  UserRecommendation createRecommendation({
    required String id,
    required StatusLevel statusLevel,
  }) {
    return UserRecommendation(
      id: UniqueID.fromUniqueString(id),
      recoID: id,
      userID: "user-1",
      priority: RecommendationPriority.medium,
      notes: null,
      recommendation: RecommendationItem(
        id: id,
        name: "Rec $id",
        reason: "Test",
        landingPageID: "lp-1",
        promotionTemplate: null,
        promoterName: "Test User",
        serviceProviderName: null,
        defaultLandingPageID: null,
        statusLevel: statusLevel,
        statusTimestamps: {0: DateTime.now()},
        userID: "user-1",
        promoterImageDownloadURL: null,
      ),
    );
  }

  test("initial state should be PromoterDetailInitial", () {
    expect(cubit.state, isA<PromoterDetailInitial>());
  });

  group("loadPromoterWithLandingPages", () {
    test("should call promoterRepo.getPromoter", () async {
      // Given
      when(mockPromoterRepo.getPromoter("promoter-1"))
          .thenAnswer((_) async => right(testPromoter));
      when(mockPromoterRepo.getLandingPages(["lp-1", "lp-2"]))
          .thenAnswer((_) async => right(testLandingPages));

      // When
      cubit.loadPromoterWithLandingPages("promoter-1");
      await untilCalled(mockPromoterRepo.getPromoter("promoter-1"));

      // Then
      verify(mockPromoterRepo.getPromoter("promoter-1")).called(1);
    });

    test(
        "should emit [Loading, Success] with landing pages when promoter has landingPageIDs",
        () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailSuccess(
          promoter: testPromoter,
          landingPages: testLandingPages,
        ),
      ];
      when(mockPromoterRepo.getPromoter("promoter-1"))
          .thenAnswer((_) async => right(testPromoter));
      when(mockPromoterRepo.getLandingPages(["lp-1", "lp-2"]))
          .thenAnswer((_) async => right(testLandingPages));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.loadPromoterWithLandingPages("promoter-1");
    });

    test(
        "should emit [Loading, Success] with empty list when promoter has no landingPageIDs",
        () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailSuccess(
          promoter: testPromoterNoLandingPages,
          landingPages: [],
        ),
      ];
      when(mockPromoterRepo.getPromoter("promoter-2"))
          .thenAnswer((_) async => right(testPromoterNoLandingPages));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.loadPromoterWithLandingPages("promoter-2");
    });

    test(
        "should emit [Loading, Success] with empty list when promoter has null landingPageIDs",
        () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailSuccess(
          promoter: testPromoterNullLandingPages,
          landingPages: [],
        ),
      ];
      when(mockPromoterRepo.getPromoter("promoter-3"))
          .thenAnswer((_) async => right(testPromoterNullLandingPages));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.loadPromoterWithLandingPages("promoter-3");
    });

    test("should emit [Loading, Failure] when getPromoter fails", () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailFailure(failure: NotFoundFailure()),
      ];
      when(mockPromoterRepo.getPromoter("promoter-1"))
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.loadPromoterWithLandingPages("promoter-1");
    });

    test(
        "should emit [Loading, Success] with empty landing pages when getLandingPages fails",
        () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailSuccess(
          promoter: testPromoter,
          landingPages: [],
        ),
      ];
      when(mockPromoterRepo.getPromoter("promoter-1"))
          .thenAnswer((_) async => right(testPromoter));
      when(mockPromoterRepo.getLandingPages(["lp-1", "lp-2"]))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.loadPromoterWithLandingPages("promoter-1");
    });

    test("should emit [Loading, Failure] when backend error occurs", () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailFailure(failure: BackendFailure()),
      ];
      when(mockPromoterRepo.getPromoter("promoter-1"))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.loadPromoterWithLandingPages("promoter-1");
    });
  });

  group("loadRecommendations", () {
    group("promoter role", () {
      final testRecommendations = [
        createRecommendation(
            id: "rec-1", statusLevel: StatusLevel.recommendationSend),
        createRecommendation(
            id: "rec-2", statusLevel: StatusLevel.successful),
      ];

      test("should call recommendationRepo.getRecommendationsWithArchived",
          () async {
        // Given
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => right(testRecommendations));
        when(mockLandingPageRepo.getAllLandingPages(["lp-1"]))
            .thenAnswer((_) async => right(testLandingPages));

        // When
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.promoter,
          landingPageIds: ["lp-1"],
        );
        await untilCalled(
            mockRecommendationRepo.getRecommendationsWithArchived("user-1"));

        // Then
        verify(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .called(1);
      });

      test(
          "should emit [RecommendationsLoading, RecommendationsSuccess] with landing pages",
          () {
        // Given
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsSuccess(
            recommendations: testRecommendations,
            allLandingPages: testLandingPages,
          ),
        ];
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => right(testRecommendations));
        when(mockLandingPageRepo.getAllLandingPages(["lp-1"]))
            .thenAnswer((_) async => right(testLandingPages));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.promoter,
          landingPageIds: ["lp-1"],
        );
      });

      test(
          "should emit [RecommendationsLoading, RecommendationsSuccess] with null landing pages when no IDs",
          () {
        // Given
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsSuccess(
            recommendations: testRecommendations,
            allLandingPages: null,
          ),
        ];
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => right(testRecommendations));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.promoter,
          landingPageIds: [],
        );
      });

      test(
          "should emit [RecommendationsLoading, RecommendationsSuccess] with null landing pages when IDs are null",
          () {
        // Given
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsSuccess(
            recommendations: testRecommendations,
            allLandingPages: null,
          ),
        ];
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => right(testRecommendations));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.promoter,
          landingPageIds: null,
        );
      });

      test(
          "should emit [RecommendationsLoading, RecommendationsSuccess] with null landing pages when loading fails",
          () {
        // Given
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsSuccess(
            recommendations: testRecommendations,
            allLandingPages: null,
          ),
        ];
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => right(testRecommendations));
        when(mockLandingPageRepo.getAllLandingPages(["lp-1"]))
            .thenAnswer((_) async => left(BackendFailure()));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.promoter,
          landingPageIds: ["lp-1"],
        );
      });

      test(
          "should emit [RecommendationsLoading, RecommendationsFailure] when getRecommendationsWithArchived fails",
          () {
        // Given
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsFailure(failure: BackendFailure()),
        ];
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => left(BackendFailure()));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.promoter,
          landingPageIds: ["lp-1"],
        );
      });
    });

    group("company role", () {
      final testUser = CustomUser(
        id: UniqueID.fromUniqueString("user-1"),
        firstName: "Max",
        lastName: "Mustermann",
        email: "max@example.com",
        landingPageIDs: ["lp-1"],
      );

      final testRecommendations = [
        createRecommendation(
            id: "rec-1", statusLevel: StatusLevel.recommendationSend),
        createRecommendation(
            id: "rec-2", statusLevel: StatusLevel.successful),
      ];

      final testPromoterRecommendations = [
        PromoterRecommendations(
          promoter: testUser,
          recommendations: testRecommendations,
        ),
      ];

      test(
          "should call recommendationRepo.getRecommendationsCompanyWithArchived",
          () async {
        // Given
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => right(testPromoterRecommendations));
        when(mockLandingPageRepo.getAllLandingPages(["lp-1"]))
            .thenAnswer((_) async => right(testLandingPages));

        // When
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.company,
        );
        await untilCalled(mockRecommendationRepo
            .getRecommendationsCompanyWithArchived("user-1"));

        // Then
        verify(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .called(1);
      });

      test(
          "should emit [RecommendationsLoading, RecommendationsSuccess] with promoterRecommendations",
          () {
        // Given
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsSuccess(
            recommendations: testRecommendations,
            promoterRecommendations: testPromoterRecommendations,
            allLandingPages: testLandingPages,
          ),
        ];
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => right(testPromoterRecommendations));
        when(mockLandingPageRepo.getAllLandingPages(["lp-1"]))
            .thenAnswer((_) async => right(testLandingPages));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.company,
        );
      });

      test(
          "should collect all recommendations from multiple promoters", () {
        // Given
        final testUser2 = CustomUser(
          id: UniqueID.fromUniqueString("user-2"),
          firstName: "Anna",
          lastName: "Schmidt",
          email: "anna@example.com",
          landingPageIDs: ["lp-2"],
        );
        final rec3 = createRecommendation(
            id: "rec-3", statusLevel: StatusLevel.linkClicked);
        final multiPromoterRecs = [
          PromoterRecommendations(
            promoter: testUser,
            recommendations: testRecommendations,
          ),
          PromoterRecommendations(
            promoter: testUser2,
            recommendations: [rec3],
          ),
        ];
        final allRecs = [...testRecommendations, rec3];
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsSuccess(
            recommendations: allRecs,
            promoterRecommendations: multiPromoterRecs,
            allLandingPages: testLandingPages,
          ),
        ];
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => right(multiPromoterRecs));
        when(mockLandingPageRepo.getAllLandingPages(any))
            .thenAnswer((_) async => right(testLandingPages));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.company,
        );
      });

      test(
          "should emit [RecommendationsLoading, RecommendationsFailure] when getRecommendationsCompanyWithArchived fails",
          () {
        // Given
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsFailure(failure: BackendFailure()),
        ];
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => left(BackendFailure()));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.company,
        );
      });

      test(
          "should emit success with null landing pages when no promoter has landingPageIDs",
          () {
        // Given
        final userNoLPs = CustomUser(
          id: UniqueID.fromUniqueString("user-no-lp"),
          firstName: "No",
          lastName: "LPs",
          email: "nolp@example.com",
          landingPageIDs: null,
        );
        final promoRecsNoLPs = [
          PromoterRecommendations(
            promoter: userNoLPs,
            recommendations: testRecommendations,
          ),
        ];
        final expectedResult = [
          PromoterDetailRecommendationsLoading(),
          PromoterDetailRecommendationsSuccess(
            recommendations: testRecommendations,
            promoterRecommendations: promoRecsNoLPs,
            allLandingPages: null,
          ),
        ];
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => right(promoRecsNoLPs));

        // Then
        expectLater(cubit.stream, emitsInOrder(expectedResult));
        cubit.loadRecommendations(
          userId: "user-1",
          role: Role.company,
        );
      });
    });
  });
}
