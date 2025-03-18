import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';

void main() {
  late MockAdminRegistrationCodeRepository mockAdminRegistrationCodeRepo;

  setUp(() {
    mockAdminRegistrationCodeRepo = MockAdminRegistrationCodeRepository();
  });

  group(
      "AdminRegistrationCodeRepositoryImplementation_SendRegistrationCodeFromAdmin",
      () {
    final email = "test@test.de";
    final code = "xxx";
    final firstName = "Test";

    test("should return unit when call was successful", () async {
      // Given
      final expectedResult = right(unit);
      when(mockAdminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
              email: email, code: code, firstName: firstName))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockAdminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
              email: email, code: code, firstName: firstName);
      // Then
      verify(mockAdminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
          email: email, code: code, firstName: firstName));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockAdminRegistrationCodeRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockAdminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
              email: email, code: code, firstName: firstName))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockAdminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
              email: email, code: code, firstName: firstName);
      // Then
      verify(mockAdminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
          email: email, code: code, firstName: firstName));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockAdminRegistrationCodeRepo);
    });
  });
}
