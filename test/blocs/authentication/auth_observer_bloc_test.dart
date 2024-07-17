import 'package:finanzbegleiter/application/authentication/auth_observer/auth_observer_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../repositories/auth_repository_test.mocks.dart';
import 'auth_cubit_test.mocks.dart';

void main() {
  late AuthObserverBloc authObserverBloc;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    authObserverBloc = AuthObserverBloc(authRepo: mockAuthRepo);
  });

  test("init state should be AuthObserverStateUnAuthenticated", () {
    expect(authObserverBloc.state, AuthObserverStateUnAuthenticated());
  });

  group("AuthObserverBloc_AuthObserverStartedEvent", () {
    final testUser = MockUser();
    test("should call auth repo if event is added", () async {
      // Given
      when(mockAuthRepo.observeAuthState())
          .thenAnswer((_) => Stream<User?>.fromIterable([testUser]));
      when(testUser.getIdToken(true)).thenAnswer((_) async => "mockToken");
      // When
      authObserverBloc.add(AuthObserverStartedEvent());
      await untilCalled(mockAuthRepo.observeAuthState());
      // Then
      verify(mockAuthRepo.observeAuthState());
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit AuthObserverStateUnAuthenticated when event is added and there is no user",
        () {
      // Given
      final expectedResult = [
        AuthObserverStateUnAuthenticated(),
      ];
      when(mockAuthRepo.observeAuthState())
          .thenAnswer((_) => Stream<User?>.fromIterable([null]));
      // Then
      expectLater(authObserverBloc.stream, emitsInOrder(expectedResult));
      authObserverBloc.add(AuthObserverStartedEvent());
    });
  });
}
