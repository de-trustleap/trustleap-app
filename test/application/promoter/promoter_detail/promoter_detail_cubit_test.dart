import "package:dartz/dartz.dart";
import "package:finanzbegleiter/features/promoter/application/promoter_detail/promoter_detail_cubit.dart";
import "package:finanzbegleiter/constants.dart";
import "package:finanzbegleiter/core/failures/database_failures.dart";
import "package:finanzbegleiter/core/id.dart";
import "package:finanzbegleiter/features/landing_pages/domain/landing_page.dart";
import "package:finanzbegleiter/features/promoter/domain/promoter.dart";
import "package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart";
import "package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart";
import "package:finanzbegleiter/features/auth/domain/user.dart";
import "package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../mocks.mocks.dart";

void main() {
  late PromoterDetailCubit cubit;
  late MockPromoterRepository mockPromoterRepo;
  late MockRecommendationRepository mockRecommendationRepo;

  setUp(() {
    mockPromoterRepo = MockPromoterRepository();
    mockRecommendationRepo = MockRecommendationRepository();
    cubit = PromoterDetailCubit(
      mockPromoterRepo,
      mockRecommendationRepo,
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

  /// Helper: loads a promoter into the cubit so it reaches PromoterDetailLoaded
  Future<void> loadPromoterIntoState({
    Promoter? promoter,
    List<LandingPage>? landingPages,
  }) async {
    final p = promoter ?? testPromoter;
    final lps = landingPages ?? testLandingPages;
    when(mockPromoterRepo.getPromoter(p.id.value))
        .thenAnswer((_) async => right(p));
    if (p.landingPageIDs != null && p.landingPageIDs!.isNotEmpty) {
      when(mockPromoterRepo.getLandingPages(p.landingPageIDs!))
          .thenAnswer((_) async => right(lps));
    }
    final future = expectLater(
      cubit.stream,
      emitsInOrder([
        PromoterDetailLoading(),
        PromoterDetailLoaded(promoter: p, landingPages: lps),
      ]),
    );
    cubit.loadPromoterWithLandingPages(p.id.value);
    await future;
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
        "should emit [Loading, Loaded] with landing pages when promoter has landingPageIDs",
        () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailLoaded(
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
        "should emit [Loading, Loaded] with empty list when promoter has no landingPageIDs",
        () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailLoaded(
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
        "should emit [Loading, Loaded] with empty list when promoter has null landingPageIDs",
        () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailLoaded(
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
        "should emit [Loading, Loaded] with empty landing pages when getLandingPages fails",
        () {
      // Given
      final expectedResult = [
        PromoterDetailLoading(),
        PromoterDetailLoaded(
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
    test("should do nothing when state is not PromoterDetailLoaded", () {
      // Given - initial state
      when(mockRecommendationRepo.getRecommendationsWithArchived(any))
          .thenAnswer((_) async => right([]));

      // When
      cubit.loadRecommendations(userId: "user-1", role: Role.promoter);

      // Then
      verifyNever(
          mockRecommendationRepo.getRecommendationsWithArchived(any));
    });

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
        await loadPromoterIntoState();
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => right(testRecommendations));

        // When
        cubit.loadRecommendations(userId: "user-1", role: Role.promoter);
        await untilCalled(
            mockRecommendationRepo.getRecommendationsWithArchived("user-1"));

        // Then
        verify(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .called(1);
      });

      test(
          "should emit [Loaded(loading), Loaded(recommendations)] on success",
          () async {
        // Given
        await loadPromoterIntoState();
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => right(testRecommendations));

        // Then
        expectLater(
          cubit.stream,
          emitsInOrder([
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              isRecommendationsLoading: true,
            ),
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              recommendations: testRecommendations,
            ),
          ]),
        );
        cubit.loadRecommendations(userId: "user-1", role: Role.promoter);
      });

      test(
          "should emit [Loaded(loading), Loaded(failure)] when getRecommendationsWithArchived fails",
          () async {
        // Given
        await loadPromoterIntoState();
        when(mockRecommendationRepo.getRecommendationsWithArchived("user-1"))
            .thenAnswer((_) async => left(BackendFailure()));

        // Then
        expectLater(
          cubit.stream,
          emitsInOrder([
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              isRecommendationsLoading: true,
            ),
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              recommendationsFailure: BackendFailure(),
            ),
          ]),
        );
        cubit.loadRecommendations(userId: "user-1", role: Role.promoter);
      });
    });

    group("company role", () {
      final testPromoterAsUser = CustomUser(
        id: UniqueID.fromUniqueString("promoter-1"),
        firstName: "Max",
        lastName: "Mustermann",
        email: "max@example.com",
        landingPageIDs: ["lp-1", "lp-2"],
      );

      final testRecommendations = [
        createRecommendation(
            id: "rec-1", statusLevel: StatusLevel.recommendationSend),
        createRecommendation(
            id: "rec-2", statusLevel: StatusLevel.successful),
      ];

      final testPromoterRecommendations = [
        PromoterRecommendations(
          promoter: testPromoterAsUser,
          recommendations: testRecommendations,
        ),
      ];

      test(
          "should call recommendationRepo.getRecommendationsCompanyWithArchived",
          () async {
        // Given
        await loadPromoterIntoState();
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => right(testPromoterRecommendations));

        // When
        cubit.loadRecommendations(userId: "user-1", role: Role.company);
        await untilCalled(mockRecommendationRepo
            .getRecommendationsCompanyWithArchived("user-1"));

        // Then
        verify(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .called(1);
      });

      test(
          "should emit [Loaded(loading), Loaded(filtered recommendations)] on success",
          () async {
        // Given
        await loadPromoterIntoState();
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => right(testPromoterRecommendations));

        // Then
        expectLater(
          cubit.stream,
          emitsInOrder([
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              isRecommendationsLoading: true,
            ),
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              recommendations: testRecommendations,
              promoterRecommendations: testPromoterRecommendations,
            ),
          ]),
        );
        cubit.loadRecommendations(userId: "user-1", role: Role.company);
      });

      test(
          "should filter recommendations to matching promoter only", () async {
        // Given
        await loadPromoterIntoState();
        final otherUser = CustomUser(
          id: UniqueID.fromUniqueString("other-promoter"),
          firstName: "Anna",
          lastName: "Schmidt",
          email: "anna@example.com",
          landingPageIDs: ["lp-2"],
        );
        final otherRec = createRecommendation(
            id: "rec-3", statusLevel: StatusLevel.linkClicked);
        final multiPromoterRecs = [
          PromoterRecommendations(
            promoter: testPromoterAsUser,
            recommendations: testRecommendations,
          ),
          PromoterRecommendations(
            promoter: otherUser,
            recommendations: [otherRec],
          ),
        ];
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => right(multiPromoterRecs));

        // Then — recommendations should only contain testPromoter's recs
        expectLater(
          cubit.stream,
          emitsInOrder([
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              isRecommendationsLoading: true,
            ),
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              recommendations: testRecommendations,
              promoterRecommendations: multiPromoterRecs,
            ),
          ]),
        );
        cubit.loadRecommendations(userId: "user-1", role: Role.company);
      });

      test(
          "should emit empty recommendations when no matching promoter found",
          () async {
        // Given
        await loadPromoterIntoState();
        final otherUser = CustomUser(
          id: UniqueID.fromUniqueString("other-promoter"),
          firstName: "Anna",
          lastName: "Schmidt",
          email: "anna@example.com",
        );
        final nonMatchingRecs = [
          PromoterRecommendations(
            promoter: otherUser,
            recommendations: testRecommendations,
          ),
        ];
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => right(nonMatchingRecs));

        // Then
        expectLater(
          cubit.stream,
          emitsInOrder([
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              isRecommendationsLoading: true,
            ),
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              recommendations: [],
              promoterRecommendations: nonMatchingRecs,
            ),
          ]),
        );
        cubit.loadRecommendations(userId: "user-1", role: Role.company);
      });

      test(
          "should emit [Loaded(loading), Loaded(failure)] when getRecommendationsCompanyWithArchived fails",
          () async {
        // Given
        await loadPromoterIntoState();
        when(mockRecommendationRepo
                .getRecommendationsCompanyWithArchived("user-1"))
            .thenAnswer((_) async => left(BackendFailure()));

        // Then
        expectLater(
          cubit.stream,
          emitsInOrder([
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              isRecommendationsLoading: true,
            ),
            PromoterDetailLoaded(
              promoter: testPromoter,
              landingPages: testLandingPages,
              recommendationsFailure: BackendFailure(),
            ),
          ]),
        );
        cubit.loadRecommendations(userId: "user-1", role: Role.company);
      });
    });
  });
}
