import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/landing_pages/application/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late LandingPageObserverCubit cubit;
  late MockLandingPageRepository mockLandingPageRepo;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
    cubit = LandingPageObserverCubit(mockLandingPageRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('LandingPageObserverCubit_InitialState', () {
    test('initial state should be LandingPageObserverInitial', () {
      expect(cubit.state, LandingPageObserverInitial());
    });
  });

  group('LandingPageObserverCubit_observeLandingPagesForUser', () {
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString("user123"),
      email: "test@example.com",
      firstName: "Test",
      lastName: "User",
      role: Role.company,
      landingPageIDs: ["page1", "page2"],
      defaultLandingPageID: "defaultPage",
    );

    final testLandingPages = [
      LandingPage(
        id: UniqueID.fromUniqueString("page1"),
        name: "Test Page 1",
      ),
      LandingPage(
        id: UniqueID.fromUniqueString("page2"),
        name: "Test Page 2",
      ),
      LandingPage(
        id: UniqueID.fromUniqueString("defaultPage"),
        name: "Default Page",
        isDefaultPage: true,
      ),
    ];

    test('should call repo when observeLandingPagesForUser is called', () async {
      // Given
      when(mockLandingPageRepo.observeLandingPagesByIds(any))
          .thenAnswer((_) => Stream.value(right(testLandingPages)));

      // When
      cubit.observeLandingPagesForUser(testUser);
      await untilCalled(mockLandingPageRepo.observeLandingPagesByIds(any));

      // Then
      verify(mockLandingPageRepo.observeLandingPagesByIds(any)).called(1);
    });

    test('should emit [LandingPageObserverLoading, LandingPageObserverSuccess] when observeLandingPagesForUser succeeds', () {
      // Given
      final expectedResult = [
        LandingPageObserverLoading(),
        LandingPageObserverSuccess(landingPages: testLandingPages, user: testUser),
      ];
      when(mockLandingPageRepo.observeLandingPagesByIds(any))
          .thenAnswer((_) => Stream.value(right(testLandingPages)));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.observeLandingPagesForUser(testUser);
    });

    test('should emit [LandingPageObserverLoading, LandingPageObserverFailure] when observeLandingPagesForUser fails', () {
      // Given
      final expectedResult = [
        LandingPageObserverLoading(),
        LandingPageObserverFailure(failure: BackendFailure()),
      ];
      when(mockLandingPageRepo.observeLandingPagesByIds(any))
          .thenAnswer((_) => Stream.value(left(BackendFailure())));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.observeLandingPagesForUser(testUser);
    });

    test('should emit empty success state when user has no landing pages', () {
      // Given
      final userWithoutPages = CustomUser(
        id: UniqueID.fromUniqueString("user456"),
        email: "empty@example.com",
        firstName: "Empty",
        lastName: "User",
        role: Role.company,
        landingPageIDs: [],
        defaultLandingPageID: null,
      );
      final expectedResult = [
        LandingPageObserverLoading(),
        LandingPageObserverSuccess(landingPages: const [], user: userWithoutPages),
      ];

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.observeLandingPagesForUser(userWithoutPages);
    });

    test('should include defaultLandingPageID in observed IDs if not already included', () async {
      // Given
      final userWithSeparateDefault = testUser.copyWith(
        landingPageIDs: ["page1"],
        defaultLandingPageID: "defaultPage",
      );
      when(mockLandingPageRepo.observeLandingPagesByIds(any))
          .thenAnswer((_) => Stream.value(right(testLandingPages)));

      // When
      cubit.observeLandingPagesForUser(userWithSeparateDefault);
      await untilCalled(mockLandingPageRepo.observeLandingPagesByIds(any));

      // Then
      final captured = verify(mockLandingPageRepo.observeLandingPagesByIds(captureAny)).captured;
      final observedIds = captured.first as List<String>;
      expect(observedIds, contains("page1"));
      expect(observedIds, contains("defaultPage"));
      expect(observedIds.length, equals(2));
    });

    test('should not restart observer if same user and same IDs', () async {
      // Given
      when(mockLandingPageRepo.observeLandingPagesByIds(any))
          .thenAnswer((_) => Stream.value(right(testLandingPages)));

      // When - call twice with same user
      cubit.observeLandingPagesForUser(testUser);
      await untilCalled(mockLandingPageRepo.observeLandingPagesByIds(any));
      
      cubit.observeLandingPagesForUser(testUser);
      await Future.delayed(Duration.zero); // Allow any potential calls

      // Then - should only be called once
      verify(mockLandingPageRepo.observeLandingPagesByIds(any)).called(1);
    });

    test('should restart observer if different user', () async {
      // Given
      final otherUser = testUser.copyWith(
        id: UniqueID.fromUniqueString("otherUser"),
      );
      when(mockLandingPageRepo.observeLandingPagesByIds(any))
          .thenAnswer((_) => Stream.value(right(testLandingPages)));

      // When
      cubit.observeLandingPagesForUser(testUser);
      await untilCalled(mockLandingPageRepo.observeLandingPagesByIds(any));
      
      cubit.observeLandingPagesForUser(otherUser);
      await untilCalled(mockLandingPageRepo.observeLandingPagesByIds(any));

      // Then
      verify(mockLandingPageRepo.observeLandingPagesByIds(any)).called(2);
    });

    test('should restart observer if same user but different IDs', () async {
      // Given
      final userWithDifferentPages = testUser.copyWith(
        landingPageIDs: ["page3", "page4"],
      );
      when(mockLandingPageRepo.observeLandingPagesByIds(any))
          .thenAnswer((_) => Stream.value(right(testLandingPages)));

      // When
      cubit.observeLandingPagesForUser(testUser);
      await untilCalled(mockLandingPageRepo.observeLandingPagesByIds(any));
      
      cubit.observeLandingPagesForUser(userWithDifferentPages);
      await untilCalled(mockLandingPageRepo.observeLandingPagesByIds(any));

      // Then
      verify(mockLandingPageRepo.observeLandingPagesByIds(any)).called(2);
    });
  });

  group('LandingPageObserverCubit_stopObserving', () {
    test('should stop observing when stopObserving is called', () {
      // When
      cubit.stopObserving();

      // Then - should not throw and should reset internal state
      expect(() => cubit.stopObserving(), returnsNormally);
    });
  });
}