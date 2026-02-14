import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/auth/application/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks/mock_user_credential.dart';
import '../../../mocks.mocks.dart';

void main() {
  late SignInCubit signInCubit;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    signInCubit = SignInCubit(authRepo: mockAuthRepo);
  });

  test("init state should be SignInInitial", () {
    expect(signInCubit.state, SignInInitial());
  });

  group("SignInCubit_CheckForValidRegistrationCode", () {
    const testEmail = "tester@test.de";
    const testCode = "1234";
    test("should call auth repo if event is added", () async {
      // Given
      when(mockAuthRepo.isRegistrationCodeValid(
              email: testEmail, code: testCode))
          .thenAnswer((_) async => right(true));
      // When
      signInCubit.checkForValidRegistrationCode(testEmail, testCode);
      await untilCalled(mockAuthRepo.isRegistrationCodeValid(
          email: testEmail, code: testCode));
      // Then
      verify(mockAuthRepo.isRegistrationCodeValid(
          email: testEmail, code: testCode));
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit SignInLoadingState and then SignInCheckCodeSuccessState when function is called and code is valid",
        () async {
      // Given
      final expectedResult = [
        SignInLoadingState(),
        SignInCheckCodeSuccessState()
      ];
      when(mockAuthRepo.isRegistrationCodeValid(
              email: testEmail, code: testCode))
          .thenAnswer((_) async => right(true));
      // Then
      expectLater(signInCubit.stream, emitsInOrder(expectedResult));
      signInCubit.checkForValidRegistrationCode(testEmail, testCode);
    });

    test(
        "should emit SignInLoadingState and then SignInCheckCodeNotValidFailureState when function is called and code is not valid",
        () async {
      // Given
      final expectedResult = [
        SignInLoadingState(),
        SignInCheckCodeNotValidFailureState()
      ];
      when(mockAuthRepo.isRegistrationCodeValid(
              email: testEmail, code: testCode))
          .thenAnswer((_) async => right(false));
      // Then
      expectLater(signInCubit.stream, emitsInOrder(expectedResult));
      signInCubit.checkForValidRegistrationCode(testEmail, testCode);
    });

    test(
        "should emit SignInLoadingState and then SignInCheckCodeNotValidFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        SignInLoadingState(),
        SignInCheckCodeFailureState(failure: BackendFailure())
      ];
      when(mockAuthRepo.isRegistrationCodeValid(
              email: testEmail, code: testCode))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(signInCubit.stream, emitsInOrder(expectedResult));
      signInCubit.checkForValidRegistrationCode(testEmail, testCode);
    });
  });

  group("SignInCubit_LoginWithEmailAndPassword", () {
    const testEmail = "tester@test.de";
    const testPassword = "12345678";
    final mockUserCredential = MockUserCredential();
    test("should call auth repo if event is added", () async {
      // Given
      when(mockAuthRepo.loginWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // When
      signInCubit.loginWithEmailAndPassword(testEmail, testPassword);
      await untilCalled(mockAuthRepo.loginWithEmailAndPassword(
          email: testEmail, password: testPassword));
      // Then
      verify(mockAuthRepo.loginWithEmailAndPassword(
          email: testEmail, password: testPassword));
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
        "should emit SignInLoadingState and then SignInSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        SignInLoadingState(),
        SignInSuccessState(creds: mockUserCredential)
      ];
      when(mockAuthRepo.loginWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => right(mockUserCredential));
      // Then
      expectLater(signInCubit.stream, emitsInOrder(expectedResult));
      signInCubit.loginWithEmailAndPassword(testEmail, testPassword);
    });

    test(
        "should emit SignInLoadingState and then SignInFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        SignInLoadingState(),
        SignInFailureState(failure: WeakPasswordFailure())
      ];
      when(mockAuthRepo.loginWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => left(WeakPasswordFailure()));
      // Then
      expectLater(signInCubit.stream, emitsInOrder(expectedResult));
      signInCubit.loginWithEmailAndPassword(testEmail, testPassword);
    });
  });

  group("SignInCubit_RegisterAndCreateUser", () {
    const email = "test@e.de";
    const password = "xxxxxx";
    final user = CustomUser(id: UniqueID.fromUniqueString("1"));
    test("should call auth repo if event is added", () async {
      // Given
      when(mockAuthRepo.registerAndCreateUser(
              email: email,
              password: password,
              user: user,
              privacyPolicyAccepted: true,
              termsAndConditionsAccepted: true))
          .thenAnswer((_) async => right(unit));
      // When
      signInCubit.registerAndCreateUser(email, password, user, true, true);
      await untilCalled(mockAuthRepo.registerAndCreateUser(
          email: email,
          password: password,
          user: user,
          privacyPolicyAccepted: true,
          termsAndConditionsAccepted: true));
      // Then
      verify(mockAuthRepo.registerAndCreateUser(
          email: email,
          password: password,
          user: user,
          privacyPolicyAccepted: true,
          termsAndConditionsAccepted: true));
      verifyNoMoreInteractions(mockAuthRepo);
    });
    test(
        "should emit SignInLoadingState and then RegisterSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [SignInLoadingState(), RegisterSuccessState()];
      when(mockAuthRepo.registerAndCreateUser(
              email: email,
              password: password,
              user: user,
              privacyPolicyAccepted: true,
              termsAndConditionsAccepted: true))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(signInCubit.stream, emitsInOrder(expectedResult));
      signInCubit.registerAndCreateUser(email, password, user, true, true);
    });
    test(
        "should emit SignInLoadingState and then RegisterFailureState when function is called",
        () async {
      // Given
      final expectedResult = [
        SignInLoadingState(),
        RegisterFailureState(failure: BackendFailure())
      ];
      when(mockAuthRepo.registerAndCreateUser(
              email: email,
              password: password,
              user: user,
              privacyPolicyAccepted: true,
              termsAndConditionsAccepted: true))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(signInCubit.stream, emitsInOrder(expectedResult));
      signInCubit.registerAndCreateUser(email, password, user, true, true);
    });
  });
}
