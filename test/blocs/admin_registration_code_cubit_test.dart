import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/admin_registration_code/admin_registration_code_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late AdminRegistrationCodeCubit adminRegistrationCodeCubit;
  late MockAdminRegistrationCodeRepository adminRegistrationCodeRepo;

  setUp(() {
    adminRegistrationCodeRepo = MockAdminRegistrationCodeRepository();
    adminRegistrationCodeCubit =
        AdminRegistrationCodeCubit(adminRegistrationCodeRepo);
  });

  test("init state should be LandingPageInitial", () {
    expect(adminRegistrationCodeCubit.state, AdminRegistrationCodeInitial());
  });

  group("AdminRegistrationCodeCubit_SendAdminRegistrationCode", () {
    final email = "test@test.de";
    final code = "xxx";
    final firstName = "Test";

    test("should call landingpage repo if function is called", () async {
      // Given
      when(adminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
              email: email, code: code, firstName: firstName))
          .thenAnswer((_) async => right(unit));
      // When
      adminRegistrationCodeCubit.sendAdminRegistrationCode(
          email, code, firstName);
      await untilCalled(adminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
          email: email, code: code, firstName: firstName));
      // Then
      verify(adminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
          email: email, code: code, firstName: firstName));
      verifyNoMoreInteractions(adminRegistrationCodeRepo);
    });

    test(
        "should emit AdminRegistrationCodeSendLoading and then AdminRegistrationCodeSendSuccessful when function is called",
        () async {
      // Given
      final expectedResult = [
        AdminRegistrationCodeSendLoading(),
        AdminRegistrationCodeSendSuccessful()
      ];
      // When
      when(adminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
              email: email, code: code, firstName: firstName))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(
          adminRegistrationCodeCubit.stream, emitsInOrder(expectedResult));
      adminRegistrationCodeCubit.sendAdminRegistrationCode(
          email, code, firstName);
    });

    test(
        "should emit AdminRegistrationCodeSendLoading and then AdminRegistrationCodeSendFailure when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        AdminRegistrationCodeSendLoading(),
        AdminRegistrationCodeSendFailure(failure: BackendFailure())
      ];
      // When
      when(adminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
              email: email, code: code, firstName: firstName))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(
          adminRegistrationCodeCubit.stream, emitsInOrder(expectedResult));
      adminRegistrationCodeCubit.sendAdminRegistrationCode(
          email, code, firstName);
    });
  });
}
