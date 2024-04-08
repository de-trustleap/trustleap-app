// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';
import 'mock_user_credential.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
  });

  group("AuthRepositoryImplementation_LoginWithEmailAndPassword", () {
    const testEmail = "test@tester.de";
    const testPassword = "12345678";
    final mockUserCredential = MockUserCredential();
    test("should return user credential when login was successful", () async {
      // Given
      final expectedResult = right(mockUserCredential);
      when(mockAuthRepo.loginWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // When
      final result = await mockAuthRepo.loginWithEmailAndPassword(
          email: testEmail, password: testPassword);
      // Then
      verify(mockAuthRepo.loginWithEmailAndPassword(
          email: testEmail, password: testPassword));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(WrongPasswordFailure());
      when(mockAuthRepo.loginWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => left(WrongPasswordFailure()));
      // When
      final result = await mockAuthRepo.loginWithEmailAndPassword(
          email: testEmail, password: testPassword);
      // Then
      verify(mockAuthRepo.loginWithEmailAndPassword(
          email: testEmail, password: testPassword));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });

  group("AuthRepositoryImplementation_RegisterWithEmailAndPassword", () {
    const testEmail = "test@tester.de";
    const testPassword = "12345678";
    final mockUserCredential = MockUserCredential();
    test("should return user credentials when registration was successful",
        () async {
      // Given
      final expectedResult = right(mockUserCredential);
      when(mockAuthRepo.registerWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // When
      final result = await mockAuthRepo.registerWithEmailAndPassword(
          email: testEmail, password: testPassword);
      // Then
      verify(mockAuthRepo.registerWithEmailAndPassword(
          email: testEmail, password: testPassword));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(WeakPasswordFailure());
      when(mockAuthRepo.registerWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => left(WeakPasswordFailure()));
      // When
      final result = await mockAuthRepo.registerWithEmailAndPassword(
          email: testEmail, password: testPassword);
      // Then
      verify(mockAuthRepo.registerWithEmailAndPassword(
          email: testEmail, password: testPassword));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });

  group("AuthRepositoryImplementation_ReauthenticateWithEmailAndPassword", () {
    const testPassword = "12345678";
    final mockUserCredential = MockUserCredential();
    test("should return user credentials when reauthentication was successful",
        () async {
      // Given
      final expectedResult = right(mockUserCredential);
      when(mockAuthRepo.reauthenticateWithPassword(password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // When
      final result =
          await mockAuthRepo.reauthenticateWithPassword(password: testPassword);
      // Then
      verify(mockAuthRepo.reauthenticateWithPassword(password: testPassword));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(WrongPasswordFailure());
      when(mockAuthRepo.reauthenticateWithPassword(password: testPassword))
          .thenAnswer((_) async => left(WrongPasswordFailure()));
      // When
      final result =
          await mockAuthRepo.reauthenticateWithPassword(password: testPassword);
      // Then
      verify(mockAuthRepo.reauthenticateWithPassword(password: testPassword));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });

  group("AuthRepositoryImplementation_ResetPassword", () {
    const testEmail = "test@tester.de";
    test("should return void when password reset was successful", () async {
      // Given
      final expectedResult = right(());
      when(mockAuthRepo.resetPassword(email: testEmail))
          .thenAnswer((_) async => right(()));
      // When
      final result = await mockAuthRepo.resetPassword(email: testEmail);
      // Then
      verify(mockAuthRepo.resetPassword(email: testEmail));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(TooManyRequestsFailure());
      when(mockAuthRepo.resetPassword(email: testEmail))
          .thenAnswer((_) async => left(TooManyRequestsFailure()));
      // When
      final result = await mockAuthRepo.resetPassword(email: testEmail);
      // Then
      verify(mockAuthRepo.resetPassword(email: testEmail));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });

  group("AuthRepositoryImplementation_IsRegistrationCodeValid", () {
    const testEmail = "test@tester.de";
    const testCode = "1234";
    test("should return bool if call was successful", () async {
      // Given
      final expectedResult = right(true);
      when(mockAuthRepo.isRegistrationCodeValid(
              email: testEmail, code: testCode))
          .thenAnswer((_) async => right(true));
      // When
      final result = await mockAuthRepo.isRegistrationCodeValid(
          email: testEmail, code: testCode);
      // Then
      verify(mockAuthRepo.isRegistrationCodeValid(
          email: testEmail, code: testCode));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockAuthRepo.isRegistrationCodeValid(
              email: testEmail, code: testCode))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockAuthRepo.isRegistrationCodeValid(
          email: testEmail, code: testCode);
      // Then
      verify(mockAuthRepo.isRegistrationCodeValid(
          email: testEmail, code: testCode));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });

  group("AuthRepositoryImplementation_deleteAccount", () {
    test("should return unit when call was successful", () async {
      // Given
      final expectedResult = right(unit);
      when(mockAuthRepo.deleteAccount())
          .thenAnswer((realInvocation) async => right(unit));
      // When
      final result = await mockAuthRepo.deleteAccount();
      // Then
      verify(mockAuthRepo.deleteAccount());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(TooManyRequestsFailure());
      when(mockAuthRepo.deleteAccount())
          .thenAnswer((realInvocation) async => left(TooManyRequestsFailure()));
      // When
      final result = await mockAuthRepo.deleteAccount();
      // Then
      verify(mockAuthRepo.deleteAccount());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });
}
