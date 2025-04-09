import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';

void main() {
  late PromoterObserverCubit promoterObserverCubit;
  late MockPromoterRepository mockPromoterRepo;

  setUp(() {
    mockPromoterRepo = MockPromoterRepository();
    promoterObserverCubit = PromoterObserverCubit(mockPromoterRepo);
  });

  test("init state should be PromoterObserverInitial", () {
    expect(promoterObserverCubit.state, PromoterObserverInitial());
  });

  group("PromoterObserverCubit_ObserveAllPromoters", () {
    final testUser = CustomUser(id: UniqueID.fromUniqueString("1"));
    final promoters = [
      Promoter(id: UniqueID.fromUniqueString("1")),
      Promoter(id: UniqueID.fromUniqueString("2"))
    ];

    test("should call repo if function is called", () async {
      // Given
      when(mockPromoterRepo.observeAllPromoters()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [right(testUser)]));
      // When
      promoterObserverCubit.observeAllPromoters();
      await untilCalled(mockPromoterRepo.observeAllPromoters());
      // Then
      verify(mockPromoterRepo.observeAllPromoters());
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test(
        "should emit PromotersObserverLoading and then PromotersObserverSuccess when event is added",
        () {
      // Given
      final expectedResult = [
        PromotersObserverLoading(),
        PromotersObserverSuccess(promoters: promoters)
      ];
      when(mockPromoterRepo.observeAllPromoters()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [right(testUser)]));
      // Then
      expectLater(promoterObserverCubit.stream, emitsInOrder(expectedResult));
      promoterObserverCubit.observeAllPromoters();
    });

    test(
        "should emit PromotersObserverLoading and then PromotersObserverFailure when event is added and repo failed",
        () {
      // Given
      final expectedResult = [
        PromotersObserverLoading(),
        PromotersObserverFailure(failure: BackendFailure())
      ];
      when(mockPromoterRepo.observeAllPromoters()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [left(BackendFailure())]));
      // Then
      expectLater(promoterObserverCubit.stream, emitsInOrder(expectedResult));
      promoterObserverCubit.observeAllPromoters();
    });
  });

  group("PromoterObserverCubit_SortPromoters", () {
    final promoters = [
      Promoter(
          id: UniqueID.fromUniqueString("1"),
          registered: true,
          createdAt: DateTime(2024, 1, 1, 12, 0, 0)),
      Promoter(
          id: UniqueID.fromUniqueString("2"),
          registered: true,
          createdAt: DateTime(2024, 1, 2, 12, 0, 0),
          landingPages: [
            LandingPage(id: UniqueID.fromUniqueString("1"), isActive: true)
          ]),
      Promoter(
          id: UniqueID.fromUniqueString("3"),
          registered: true,
          createdAt: DateTime(2024, 1, 3, 12, 0, 0),
          landingPages: [
            LandingPage(id: UniqueID.fromUniqueString("2"), isActive: true)
          ]),
      Promoter(
          id: UniqueID.fromUniqueString("4"),
          registered: true,
          createdAt: DateTime(2024, 1, 4, 12, 0, 0),
          landingPages: [
            LandingPage(id: UniqueID.fromUniqueString("3"), isActive: false)
          ]),
      Promoter(
          id: UniqueID.fromUniqueString("5"),
          registered: false,
          expiresAt: DateTime(2024, 1, 4, 12, 0, 0),
          landingPages: [
            LandingPage(id: UniqueID.fromUniqueString("4"), isActive: false)
          ]),
      Promoter(
          id: UniqueID.fromUniqueString("6"),
          registered: false,
          expiresAt: DateTime(2024, 1, 5, 12, 0, 0),
          landingPages: [
            LandingPage(id: UniqueID.fromUniqueString("5"), isActive: true)
          ])
    ];

    test("should sort promoters correctly based on rules", () {
      // When
      final sortedPromoters =
          promoterObserverCubit.sortPromoters(promoters.toList());
      // Then
      expect(sortedPromoters.map((p) => p.id.value).toList(),
          equals(["4", "1", "3", "2", "5", "6"]));
    });
  });

  group("PromoterObserverCubit_SortPromoters", () {
    test("should return true when landingpages are null", () {
      // Given
      final promoter = Promoter(
          id: UniqueID.fromUniqueString("4"),
          registered: true,
          createdAt: DateTime(2024, 1, 4, 12, 0, 0));
      // WHen
      final result = promoterObserverCubit.showLandingPageWarning(promoter);
      // Then
      expect(result, true);
    });

    test("should return true when landingpages is empty", () {
      // Given
      final promoter = Promoter(
          id: UniqueID.fromUniqueString("4"),
          registered: true,
          createdAt: DateTime(2024, 1, 4, 12, 0, 0),
          landingPages: []);
      // WHen
      final result = promoterObserverCubit.showLandingPageWarning(promoter);
      // Then
      expect(result, true);
    });

    test("should return true when every landingpage is inactive", () {
      // Given
      final promoter = Promoter(
          id: UniqueID.fromUniqueString("4"),
          registered: true,
          createdAt: DateTime(2024, 1, 4, 12, 0, 0),
          landingPages: [
            LandingPage(id: UniqueID.fromUniqueString("1"), isActive: false)
          ]);
      // WHen
      final result = promoterObserverCubit.showLandingPageWarning(promoter);
      // Then
      expect(result, true);
    });

    test("should return true when every landingpage activation status is null",
        () {
      // Given
      final promoter = Promoter(
          id: UniqueID.fromUniqueString("4"),
          registered: true,
          createdAt: DateTime(2024, 1, 4, 12, 0, 0),
          landingPages: [
            LandingPage(id: UniqueID.fromUniqueString("1"), isActive: null)
          ]);
      // WHen
      final result = promoterObserverCubit.showLandingPageWarning(promoter);
      // Then
      expect(result, true);
    });

    test("should return false when a landingpage activation status is true",
        () {
      // Given
      final promoter = Promoter(
          id: UniqueID.fromUniqueString("4"),
          registered: true,
          createdAt: DateTime(2024, 1, 4, 12, 0, 0),
          landingPages: [
            LandingPage(id: UniqueID.fromUniqueString("1"), isActive: null),
            LandingPage(id: UniqueID.fromUniqueString("1"), isActive: true)
          ]);
      // WHen
      final result = promoterObserverCubit.showLandingPageWarning(promoter);
      // Then
      expect(result, false);
    });
  });
}
