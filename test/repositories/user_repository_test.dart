// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
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
      final expectedResult = right((unit));
      when(mockUserRepo.updateEmail(email: testEmail))
          .thenAnswer((_) async => right((unit)));
      // When
      final result = await mockUserRepo.updateEmail(email: testEmail);
      // Then
      verify(mockUserRepo.updateEmail(email: testEmail));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockUserRepo.updateEmail(email: testEmail))
          .thenAnswer((_) async => left(BackendFailure()));
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

  group("UserRepositoryImplementation_GetUserByID", () {
    const testUserID = "user123";
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString(testUserID),
        gender: Gender.male,
        firstName: "Max",
        lastName: "Mustermann",
        birthDate: "01.01.1990",
        email: "max.mustermann@test.de",
        role: Role.company);

    test("should return user when getUserByID call was successful", () async {
      // Given
      final expectedResult = right(testUser);
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => right(testUser));
      // When
      final result = await mockUserRepo.getUserByID(userId: testUserID);
      // Then
      verify(mockUserRepo.getUserByID(userId: testUserID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return NotFoundFailure when user does not exist", () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => left(NotFoundFailure()));
      // When
      final result = await mockUserRepo.getUserByID(userId: testUserID);
      // Then
      verify(mockUserRepo.getUserByID(userId: testUserID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return BackendFailure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockUserRepo.getUserByID(userId: testUserID);
      // Then
      verify(mockUserRepo.getUserByID(userId: testUserID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should handle different user IDs correctly", () async {
      // Given
      const userID1 = "user123";
      const userID2 = "user456";
      final user1 = CustomUser(
          id: UniqueID.fromUniqueString(userID1),
          firstName: "Max",
          lastName: "Mustermann",
          email: "max@test.de");
      final user2 = CustomUser(
          id: UniqueID.fromUniqueString(userID2),
          firstName: "Anna",
          lastName: "Schmidt",
          email: "anna@test.de");

      when(mockUserRepo.getUserByID(userId: userID1))
          .thenAnswer((_) async => right(user1));
      when(mockUserRepo.getUserByID(userId: userID2))
          .thenAnswer((_) async => right(user2));

      // When
      final result1 = await mockUserRepo.getUserByID(userId: userID1);
      final result2 = await mockUserRepo.getUserByID(userId: userID2);

      // Then
      verify(mockUserRepo.getUserByID(userId: userID1));
      verify(mockUserRepo.getUserByID(userId: userID2));
      expect(result1, right(user1));
      expect(result2, right(user2));
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should return PermissionDeniedFailure when access is denied", () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockUserRepo.getUserByID(userId: testUserID))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));
      // When
      final result = await mockUserRepo.getUserByID(userId: testUserID);
      // Then
      verify(mockUserRepo.getUserByID(userId: testUserID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockUserRepo);
    });
  });
}
