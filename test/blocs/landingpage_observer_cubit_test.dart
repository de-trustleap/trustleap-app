import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late LandingPageObserverCubit landingPageObserverCubit;
  late MockLandingPageRepository mockLandingPageRepo;
 

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
    landingPageObserverCubit = LandingPageObserverCubit(mockLandingPageRepo);
  });

  test("init state should be ProfileObserverInitial", () {
    expect(landingPageObserverCubit.state, LandingPageObserverInitial());
  });

  group("CompanyObserverCubit_observeCompany", () {
    const userId = "1";
    const landingpageId1 = "1";
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString(userId)
        );
    final List<LandingPage> landingPages = [
    LandingPage(
      id: UniqueID.fromUniqueString(landingpageId1)
    )
  ];
    test("should call repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.observeAllLandingPages()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [right(testUser)]));
      // When
      landingPageObserverCubit.observeAllLandingPages();
      await untilCalled(mockLandingPageRepo.observeAllLandingPages());
      // Then
      verify(mockLandingPageRepo.observeAllLandingPages());
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit CompanyObserverLoading and then CompanyObserverSuccess when event is added",
        () {
      // Given
      final expectedResult = [
        LandingPageObserverLoading(),
        LandingPageObserverSuccess(landingPages: landingPages)
      ];
      when(mockLandingPageRepo.observeAllLandingPages()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [right(testUser)]));
      // Then
      expectLater(landingPageObserverCubit.stream, emitsInOrder(expectedResult));
      landingPageObserverCubit.observeAllLandingPages();
    });

    test(
        "should emit ProfileObserverLoading and then ProfileObserverFailure when event is added and repo failed",
        () {
      // Given
      final expectedResult = [
        LandingPageObserverLoading(),
        LandingPageObserverFailure(failure: BackendFailure())
      ];
      when(mockLandingPageRepo.observeAllLandingPages()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [left(BackendFailure())]));
      // Then
      expectLater(landingPageObserverCubit.stream, emitsInOrder(expectedResult));
      landingPageObserverCubit.observeAllLandingPages();
    });
  });
}