import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/profile/profile_observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late ProfileObserverBloc profileObserverBloc;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
    profileObserverBloc = ProfileObserverBloc(userRepo: mockUserRepo);
  });

  test("init state should be ProfileObserverInitial", () {
    expect(profileObserverBloc.state, ProfileObserverInitial());
  });

  group("ProfileObserverBloc_ProfileObserveAllEvent", () {
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString("1"),
        firstName: "Max",
        lastName: "Mustermann",
        email: "max.mustermann@test.de",
        address: "Teststreet 5",
        registeredPromoterIDs: const ["1"]);
    test("should call repo if event is added", () async {
      // Given
      when(mockUserRepo.observeUser()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [right(testUser)]));
      // When
      profileObserverBloc.add(ProfileObserveUserEvent());
      await untilCalled(mockUserRepo.observeUser());
      // Then
      verify(mockUserRepo.observeUser());
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit ProfileObserverLoading and then ProfileObserverSuccess when event is added",
        () {
      // Given
      final expectedResult = [
        ProfileUserObserverLoading(),
        ProfileUserObserverSuccess(user: testUser)
      ];
      when(mockUserRepo.observeUser()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [right(testUser)]));
      // Then
      expectLater(profileObserverBloc.stream, emitsInOrder(expectedResult));
      profileObserverBloc.add(ProfileObserveUserEvent());
    });

    test(
        "should emit ProfileObserverLoading and then ProfileObserverFailure when event is added and repo failed",
        () {
      // Given
      final expectedResult = [
        ProfileUserObserverLoading(),
        ProfileUserObserverFailure(failure: BackendFailure())
      ];
      when(mockUserRepo.observeUser()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, CustomUser>>.fromIterable(
              [left(BackendFailure())]));
      // Then
      expectLater(profileObserverBloc.stream, emitsInOrder(expectedResult));
      profileObserverBloc.add(ProfileObserveUserEvent());
    });
  });
}
