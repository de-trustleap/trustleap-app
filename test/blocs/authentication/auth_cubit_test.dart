// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../repositories/auth_repository_test.mocks.dart';

@GenerateMocks([User])
void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    authCubit = AuthCubit(authRepo: mockAuthRepo);
  });

  test("init state should be AuthStateUnAuthenticated", () {
    expect(authCubit.state, AuthStateUnAuthenticated());
  });

  group("AuthCubit_ResetPassword", () {
    const testEmail = "tester@test.de";
    test("should call auth repo when function is called", () async {
      // Given
      when(mockAuthRepo.resetPassword(email: testEmail))
          .thenAnswer((_) async => right(()));
      // When
      authCubit.resetPassword(testEmail);
      await untilCalled(mockAuthRepo.resetPassword(email: testEmail));
      // Then
      verify(mockAuthRepo.resetPassword(email: testEmail));
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit AuthPasswordResetLoadingState and then AuthPasswordResetSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        AuthPasswordResetLoadingState(),
        AuthPasswordResetSuccessState()
      ];
      when(mockAuthRepo.resetPassword(email: testEmail))
          .thenAnswer((_) async => right(()));
      // Then
      expectLater(authCubit.stream, emitsInOrder(expectedResult));
      authCubit.resetPassword(testEmail);
    });

    test(
        "should emit AuthPasswordResetLoadingState and then AuthPasswordResetFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        AuthPasswordResetLoadingState(),
        AuthPasswordResetFailureState(failure: InvalidEmailFailure())
      ];
      when(mockAuthRepo.resetPassword(email: testEmail))
          .thenAnswer((_) async => left(InvalidEmailFailure()));
      // Then
      expectLater(authCubit.stream, emitsInOrder(expectedResult));
      authCubit.resetPassword(testEmail);
    });
  });
}
