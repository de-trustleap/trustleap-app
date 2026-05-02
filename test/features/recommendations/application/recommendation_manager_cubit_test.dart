import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late RecommendationManagerCubit cubit;
  late MockRecommendationObserverRepository mockObserverRepo;

  final userID = "user-1";

  final recommendation = PersonalizedRecommendationItem(
    id: "item-1",
    name: "Test",
    reason: "Test",
    landingPageID: "lp-1",
    promotionTemplate: null,
    promoterName: "Test Promoter",
    serviceProviderName: "Test Service",
    defaultLandingPageID: "lp-1",
    userID: userID,
    statusLevel: StatusLevel.recommendationSend,
    statusTimestamps: null,
    promoterImageDownloadURL: null,
    compensation: null,
  );

  final userReco = UserRecommendation(
    id: UniqueID.fromUniqueString("reco-1"),
    recoID: "item-1",
    userID: userID,
    priority: RecommendationPriority.medium,
    notes: null,
    recommendation: recommendation,
  );

  setUp(() {
    mockObserverRepo = MockRecommendationObserverRepository();
    cubit = RecommendationManagerCubit(mockObserverRepo);
  });

  tearDown(() {
    cubit.close();
  });

  test("init state should be RecommendationManagerInitial", () {
    expect(cubit.state, RecommendationManagerInitial());
  });

  group("observeRecommendationsForUser — promoter role", () {
    late CustomUser promoterUser;

    setUp(() {
      promoterUser = CustomUser(
        id: UniqueID.fromUniqueString(userID),
        role: Role.promoter,
        recommendationIDs: ["reco-1"],
      );
    });

    test("emits Loading then Success when stream emits list", () async {
      final controller =
          StreamController<Either<DatabaseFailure, List<UserRecommendation>>>();
      when(mockObserverRepo.observeRecommendations(["reco-1"]))
          .thenAnswer((_) => controller.stream);

      final expectedStates = [
        RecommendationManagerLoadingState(),
        RecommendationGetRecosSuccessState(recoItems: [userReco]),
      ];
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.observeRecommendationsForUser(promoterUser);
      controller.add(right([userReco]));

      await Future.delayed(Duration.zero);
      await controller.close();
    });

    test("emits Loading then NoRecos when stream emits empty list", () async {
      final controller =
          StreamController<Either<DatabaseFailure, List<UserRecommendation>>>();
      when(mockObserverRepo.observeRecommendations(["reco-1"]))
          .thenAnswer((_) => controller.stream);

      final expectedStates = [
        RecommendationManagerLoadingState(),
        RecommendationGetRecosNoRecosState(),
      ];
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.observeRecommendationsForUser(promoterUser);
      controller.add(right([]));

      await Future.delayed(Duration.zero);
      await controller.close();
    });

    test("emits Loading then Failure when stream emits error", () async {
      final controller =
          StreamController<Either<DatabaseFailure, List<UserRecommendation>>>();
      when(mockObserverRepo.observeRecommendations(["reco-1"]))
          .thenAnswer((_) => controller.stream);

      final expectedStates = [
        RecommendationManagerLoadingState(),
        RecommendationGetRecosFailureState(failure: BackendFailure()),
      ];
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.observeRecommendationsForUser(promoterUser);
      controller.add(left(BackendFailure()));

      await Future.delayed(Duration.zero);
      await controller.close();
    });

    test("emits NoRecos immediately when user has no recommendationIDs",
        () async {
      final emptyUser = CustomUser(
        id: UniqueID.fromUniqueString(userID),
        role: Role.promoter,
        recommendationIDs: [],
      );

      final expectedStates = [
        RecommendationManagerLoadingState(),
        RecommendationGetRecosNoRecosState(),
      ];
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.observeRecommendationsForUser(emptyUser);
      verifyNever(mockObserverRepo.observeRecommendations(any));
    });

    test("does not restart subscription when called again with same user+IDs",
        () async {
      final controller =
          StreamController<Either<DatabaseFailure, List<UserRecommendation>>>(
              sync: true);
      when(mockObserverRepo.observeRecommendations(["reco-1"]))
          .thenAnswer((_) => controller.stream);

      await cubit.observeRecommendationsForUser(promoterUser);
      await cubit.observeRecommendationsForUser(promoterUser);

      verify(mockObserverRepo.observeRecommendations(["reco-1"])).called(1);
      await controller.close();
    });
  });

  group("observeRecommendationsForUser — company role", () {
    late CustomUser companyUser;

    setUp(() {
      companyUser = CustomUser(
        id: UniqueID.fromUniqueString("company-1"),
        role: Role.company,
        recommendationIDs: ["own-reco-1"],
        registeredPromoterIDs: ["promoter-1"],
      );
    });

    test("aggregates IDs via observerRepo before subscribing", () async {
      final aggregatedIDs = ["own-reco-1", "promoter-reco-1"];
      when(mockObserverRepo.aggregateCompanyUserRecoIDs(companyUser))
          .thenAnswer((_) async => right(aggregatedIDs));

      final controller =
          StreamController<Either<DatabaseFailure, List<UserRecommendation>>>();
      when(mockObserverRepo.observeRecommendations(any))
          .thenAnswer((_) => controller.stream);

      await cubit.observeRecommendationsForUser(companyUser);

      verify(mockObserverRepo.aggregateCompanyUserRecoIDs(companyUser))
          .called(1);
      verify(mockObserverRepo.observeRecommendations(any)).called(1);
      await controller.close();
    });

    test("emits Failure when aggregation fails", () async {
      when(mockObserverRepo.aggregateCompanyUserRecoIDs(companyUser))
          .thenAnswer((_) async => left(BackendFailure()));

      expectLater(cubit.stream,
          emits(RecommendationGetRecosFailureState(failure: BackendFailure())));

      await cubit.observeRecommendationsForUser(companyUser);
    });
  });

}
