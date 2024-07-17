// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../repositories/auth_repository_test.mocks.dart';
import '../repositories/mock_user_credential.dart';
import '../repositories/user_repository_test.mocks.dart';
import 'authentication/auth_cubit_test.mocks.dart';

void main() {
  late ProfileCubit profileCubit;
  late MockUserRepository mockUserRepo;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
    mockAuthRepo = MockAuthRepository();
    profileCubit = ProfileCubit(userRepo: mockUserRepo, authRepo: mockAuthRepo);
  });

  test("init state should be ProfileInitial", () {
    expect(profileCubit.state, ProfileInitial());
  });

  group("ProfileCubit_UpdateProfile", () {
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString("1"),
        firstName: "Max",
        lastName: "Mustermann",
        email: "max.mustermann@test.de",
        address: "Teststreet 5",
        registeredPromoterIDs: const ["1"]);
    test("should call user repo if function is called", () async {
      // Given
      when(mockUserRepo.updateUser(user: testUser))
          .thenAnswer((_) async => right(unit));
      // When
      profileCubit.updateProfile(testUser);
      await untilCalled(mockUserRepo.updateUser(user: testUser));
      // Then
      verify(mockUserRepo.updateUser(user: testUser));
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit ProfileUpdateContactInformationLoadingState and then ProfileUpdateContactInformationSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfileUpdateContactInformationLoadingState(),
        ProfileUpdateContactInformationSuccessState()
      ];
      when(mockUserRepo.updateUser(user: testUser))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.updateProfile(testUser);
    });

    test(
        "should emit ProfileUpdateContactInformationLoadingState and then ProfileUpdateContactInformationFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        ProfileUpdateContactInformationLoadingState(),
        ProfileUpdateContactInformationFailureState(failure: BackendFailure())
      ];
      when(mockUserRepo.updateUser(user: testUser))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.updateProfile(testUser);
    });
  });

  group("ProfileCubit_ReauthenticateWithPasswordForEmailUpdate", () {
    const testPassword = "12345678";
    final mockUserCredential = MockUserCredential();
    test("should call auth repo if function is called", () async {
      // Given
      when(mockAuthRepo.reauthenticateWithPassword(password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // When
      profileCubit.reauthenticateWithPasswordForEmailUpdate(testPassword);
      await untilCalled(
          mockAuthRepo.reauthenticateWithPassword(password: testPassword));
      // Then
      verify(mockAuthRepo.reauthenticateWithPassword(password: testPassword));
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit ProfileEmailLoadingState and then ProfileReauthenticateForEmailUpdateSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfileEmailLoadingState(),
        ProfileReauthenticateForEmailUpdateSuccessState()
      ];
      when(mockAuthRepo.reauthenticateWithPassword(password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.reauthenticateWithPasswordForEmailUpdate(testPassword);
    });

    test(
        "should emit ProfileEmailLoadingState and then ProfileEmailUpdateFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        ProfileEmailLoadingState(),
        ProfileEmailUpdateFailureState(failure: WrongPasswordFailure())
      ];
      when(mockAuthRepo.reauthenticateWithPassword(password: testPassword))
          .thenAnswer((_) async => left(WrongPasswordFailure()));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.reauthenticateWithPasswordForEmailUpdate(testPassword);
    });
  });

  group("ProfileCubit_ReauthenticateWithPasswordForPasswordUpdate", () {
    const testPassword = "12345678";
    final mockUserCredential = MockUserCredential();
    test("should call auth repo if function is called", () async {
      // Given
      when(mockAuthRepo.reauthenticateWithPassword(password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // When
      profileCubit.reauthenticateWithPasswordForPasswordUpdate(testPassword);
      await untilCalled(
          mockAuthRepo.reauthenticateWithPassword(password: testPassword));
      // Then
      verify(mockAuthRepo.reauthenticateWithPassword(password: testPassword));
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit ProfilePasswordUpdateLoadingState and then ProfileReauthenticateForPasswordUpdateSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfilePasswordUpdateLoadingState(),
        ProfileReauthenticateForPasswordUpdateSuccessState()
      ];
      when(mockAuthRepo.reauthenticateWithPassword(password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.reauthenticateWithPasswordForPasswordUpdate(testPassword);
    });

    test(
        "should emit ProfilePasswordUpdateLoadingState and then ProfilePasswordUpdateFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        ProfilePasswordUpdateLoadingState(),
        ProfilePasswordUpdateFailureState(failure: WrongPasswordFailure())
      ];
      when(mockAuthRepo.reauthenticateWithPassword(password: testPassword))
          .thenAnswer((_) async => left(WrongPasswordFailure()));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.reauthenticateWithPasswordForPasswordUpdate(testPassword);
    });
  });

  group("ProfileCubit_UpdateEmail", () {
    const testEmail = "test@tester.de";
    test("should call user repo when function is called", () async {
      // Given
      when(mockUserRepo.updateEmail(email: testEmail))
          .thenAnswer((_) async => right(()));
      // When
      profileCubit.updateEmail(testEmail);
      await untilCalled(mockUserRepo.updateEmail(email: testEmail));
      // Then
      verify(mockUserRepo.updateEmail(email: testEmail));
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit ProfileEmailLoadingState and then ProfileEmailUpdateSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfileEmailLoadingState(),
        ProfileEmailUpdateSuccessState()
      ];
      when(mockUserRepo.updateEmail(email: testEmail))
          .thenAnswer((_) async => right(()));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.updateEmail(testEmail);
    });

    test(
        "should emit ProfileEmailLoadingState and then ProfileEmailUpdateFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        ProfileEmailLoadingState(),
        ProfileEmailUpdateFailureState(failure: EmailAlreadyInUseFailure())
      ];
      when(mockUserRepo.updateEmail(email: testEmail))
          .thenAnswer((_) async => left(EmailAlreadyInUseFailure()));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.updateEmail(testEmail);
    });
  });

  group("ProfileCubit_VerifyEmail", () {
    test("should call user repo when function is called", () async {
      // Given
      when(mockUserRepo.isEmailVerified()).thenAnswer((_) async => true);
      // When
      profileCubit.verifyEmail();
      await untilCalled(mockUserRepo.isEmailVerified());
      // Then
      verify(mockUserRepo.isEmailVerified());
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should emit ProfileEmailVerifySuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfileEmailVerifySuccessState(isEmailVerified: true),
      ];
      when(mockUserRepo.isEmailVerified()).thenAnswer((_) async => true);
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.verifyEmail();
    });
  });

  group("ProfileCubit_UpdatePassword", () {
    const testPassword = "12345678";
    test("should call user repo when function is called", () async {
      // Given
      when(mockUserRepo.updatePassword(password: testPassword))
          .thenAnswer((_) async => right(()));
      // When
      profileCubit.updatePassword(testPassword);
      await untilCalled(mockUserRepo.updatePassword(password: testPassword));
      // Then
      verify(mockUserRepo.updatePassword(password: testPassword));
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit ProfilePasswordUpdateLoadingState and then ProfilePasswordUpdateSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfilePasswordUpdateLoadingState(),
        ProfilePasswordUpdateSuccessState()
      ];
      when(mockUserRepo.updatePassword(password: testPassword))
          .thenAnswer((_) async => right(()));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.updatePassword(testPassword);
    });

    test(
        "should emit ProfilePasswordUpdateLoadingState and then ProfilePasswordUpdateFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        ProfilePasswordUpdateLoadingState(),
        ProfilePasswordUpdateFailureState(failure: WeakPasswordFailure())
      ];
      when(mockUserRepo.updatePassword(password: testPassword))
          .thenAnswer((_) async => left(WeakPasswordFailure()));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.updatePassword(testPassword);
    });
  });

  group("ProfileCubit_ResendEmailVerification", () {
    test("should call user auth when function is called", () async {
      // Given
      when(mockAuthRepo.resendEmailVerification()).thenAnswer((_) async => ());
      // When
      profileCubit.resendEmailVerification();
      await untilCalled(mockAuthRepo.resendEmailVerification());
      // Then
      verify(mockAuthRepo.resendEmailVerification());
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit ProfileResendEmailVerificationLoadingState and then ProfileResendEmailVerificationSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfileResendEmailVerificationLoadingState(),
        ProfileResendEmailVerificationSuccessState()
      ];
      when(mockAuthRepo.resendEmailVerification()).thenAnswer((_) async => ());
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.resendEmailVerification();
    });
  });

  group("ProfileCubit_GetCurrentUser", () {
    final testUser = MockUser();
    test("should call auth repo when function is called", () async {
      // Given
      when(mockAuthRepo.getCurrentUser()).thenAnswer((_) => testUser);
      // When
      profileCubit.getCurrentUser();
      await untilCalled(mockAuthRepo.getCurrentUser());
      // Then
      verify(mockAuthRepo.getCurrentUser());
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit ProfileGetCurrentUserSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfileGetCurrentUserSuccessState(user: testUser)
      ];
      when(mockAuthRepo.getCurrentUser()).thenAnswer((_) => testUser);
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.getCurrentUser();
    });
  });

  group("ProfileCubit_DeleteAccount", () {
    test("should call auth repo when function is called", () async {
      // Given
      when(mockAuthRepo.deleteAccount()).thenAnswer((_) async => right(unit));
      // When
      profileCubit.deleteAccount();
      await untilCalled(mockAuthRepo.deleteAccount());
      // Then
      verify(mockAuthRepo.deleteAccount());
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit ProfileAccountDeletionSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfileAccountDeletionLoadingState(),
        ProfileAccountDeletionSuccessState()
      ];
      when(mockAuthRepo.deleteAccount()).thenAnswer((_) async => right(unit));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.deleteAccount();
    });

    test(
        "should emit ProfileAccountDeletionFailureState when function is called",
        () async {
      // Given
      final expectedResult = [
        ProfileAccountDeletionLoadingState(),
        ProfileAccountDeletionFailureState(failure: TooManyRequestsFailure())
      ];
      when(mockAuthRepo.deleteAccount())
          .thenAnswer((_) async => left(TooManyRequestsFailure()));
      // Then
      expectLater(profileCubit.stream, emitsInOrder(expectedResult));
      profileCubit.deleteAccount();
    });
  });
}
