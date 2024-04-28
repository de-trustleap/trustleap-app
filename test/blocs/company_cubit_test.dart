import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../repositories/company_repository_test.mocks.dart';

void main() {
  late CompanyCubit companyCubit;
  late MockCompanyRepository mockCompanyRepo;

  setUp(() {
    mockCompanyRepo = MockCompanyRepository();
    companyCubit = CompanyCubit(mockCompanyRepo);
  });

  test("init state should be CompanyInitial", () {
    expect(companyCubit.state, CompanyInitial());
  });

  group("CompanyCubit_updateCompany", () {
    const String companyID = "1";
    final testCompany = Company(
        id: UniqueID.fromUniqueString(companyID),
        name: "Test",
        industry: "Test");
    test("should call company repo if function is called", () async {
      // Given
      when(mockCompanyRepo.updateCompany(testCompany))
          .thenAnswer((_) async => right(unit));
      // When
      companyCubit.updateCompany(testCompany);
      await untilCalled(mockCompanyRepo.updateCompany(testCompany));
      // Then
      verify(mockCompanyRepo.updateCompany(testCompany));
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test(
        "should emit CompanyUpdateContactInformationLoadingState and then CompanyUpdateContactInformationSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        CompanyUpdateContactInformationLoadingState(),
        CompanyUpdateContactInformationSuccessState()
      ];
      when(mockCompanyRepo.updateCompany(testCompany))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.updateCompany(testCompany);
    });

    test(
        "should emit CompanyUpdateContactInformationLoadingState and then CompanyUpdateContactInformationFailureState when function is called and there was an error",
        () {
      // Given
      final expectedResult = [
        CompanyUpdateContactInformationLoadingState(),
        CompanyUpdateContactInformationFailureState(failure: BackendFailure())
      ];
      when(mockCompanyRepo.updateCompany(testCompany))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.updateCompany(testCompany);
    });
  });
}
