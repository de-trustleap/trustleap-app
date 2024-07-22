// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
  });

  group("UserRepositoryImplementation_CreateUser", () {
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString("123"),
        gender: Gender.male,
        firstName: "Tester",
        lastName: "Test",
        birthDate: "23.12.23",
        email: "tester@test.de");
    test(
        "should return unit when user has been created and the call was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockUserRepo.createUser(user: testUser))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockUserRepo.createUser(user: testUser);
      // Then
      verify(mockUserRepo.createUser(user: testUser));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockUserRepo.createUser(user: testUser))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockUserRepo.createUser(user: testUser);
      // Then
      verify(mockUserRepo.createUser(user: testUser));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockUserRepo);
    });
  });

  group("UserRepositoryImplementation_UpdateUser", () {
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString("123"),
        gender: Gender.male,
        firstName: "Tester",
        lastName: "Test",
        birthDate: "23.12.23",
        email: "tester@test.de");
    test(
        "should return unit when user has been updated and the call was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockUserRepo.updateUser(user: testUser))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockUserRepo.updateUser(user: testUser);
      // Then
      verify(mockUserRepo.updateUser(user: testUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockUserRepo.updateUser(user: testUser))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));
      // When
      final result = await mockUserRepo.updateUser(user: testUser);
      // Then
      verify(mockUserRepo.updateUser(user: testUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });
  });

  group("UserRepositoryImplementation_UpdateEmail", () {
    const testEmail = "tester@test.de";
    test(
        "should return void when email has been updated and the call was successful",
        () async {
      // Given
      final expectedResult = right(());
      when(mockUserRepo.updateEmail(email: testEmail))
          .thenAnswer((_) async => right(()));
      // When
      final result = await mockUserRepo.updateEmail(email: testEmail);
      // Then
      verify(mockUserRepo.updateEmail(email: testEmail));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(InvalidEmailFailure());
      when(mockUserRepo.updateEmail(email: testEmail))
          .thenAnswer((_) async => left(InvalidEmailFailure()));
      // When
      final result = await mockUserRepo.updateEmail(email: testEmail);
      // Then
      verify(mockUserRepo.updateEmail(email: testEmail));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });
  });

  group("UserRepositoryImplementation_IsEmailVerified", () {
    test("should return true when email is verified", () async {
      // Given
      final expectedResult = true;
      when(mockUserRepo.isEmailVerified())
          .thenAnswer((realInvocation) async => true);
      // When
      final result = await mockUserRepo.isEmailVerified();
      // Then
      verify(mockUserRepo.isEmailVerified());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });
  });

  group("UserRepositoryImplementation_UpdatePassword", () {
    const testPassword = "12345678";
    test(
        "should return void when password has been updated and the call was successful",
        () async {
      // Given
      final expectedResult = right(());
      when(mockUserRepo.updatePassword(password: testPassword))
          .thenAnswer((_) async => right(()));
      // When
      final result = await mockUserRepo.updatePassword(password: testPassword);
      // Then
      verify(mockUserRepo.updatePassword(password: testPassword));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(WeakPasswordFailure());
      when(mockUserRepo.updatePassword(password: testPassword))
          .thenAnswer((_) async => left(WeakPasswordFailure()));
      // When
      final result = await mockUserRepo.updatePassword(password: testPassword);
      // Then
      verify(mockUserRepo.updatePassword(password: testPassword));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });
  });
}
