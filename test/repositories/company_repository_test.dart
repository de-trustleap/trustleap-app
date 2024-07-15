import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'company_repository_test.mocks.dart';

@GenerateMocks([CompanyRepository])
void main() {
  late MockCompanyRepository mockCompanyRepo;

  setUp(() {
    mockCompanyRepo = MockCompanyRepository();
  });

  group("CompanyRepositoryImplementation_UpdateCompany", () {
    final testCompany = Company(id: UniqueID.fromUniqueString("1"));
    test(
        "should return unit when company has been updated and call was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockCompanyRepo.updateCompany(testCompany))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockCompanyRepo.updateCompany(testCompany);
      // Then
      verify(mockCompanyRepo.updateCompany(testCompany));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockCompanyRepo.updateCompany(testCompany))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockCompanyRepo.updateCompany(testCompany);
      // Then
      verify(mockCompanyRepo.updateCompany(testCompany));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockCompanyRepo);
    });
  });

  group("CompanyRepositoryImplementation_GetCompany", () {
    final testCompany = Company(id: UniqueID.fromUniqueString("1"));
    const companyID = "1";
    test("should return company when and call was successful", () async {
      // Given
      final expectedResult = right(testCompany);
      when(mockCompanyRepo.getCompany(companyID))
          .thenAnswer((_) async => right(testCompany));
      // When
      final result = await mockCompanyRepo.getCompany(companyID);
      // Then
      verify(mockCompanyRepo.getCompany(companyID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test("should return failure when and call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockCompanyRepo.getCompany(companyID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockCompanyRepo.getCompany(companyID);
      // Then
      verify(mockCompanyRepo.getCompany(companyID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockCompanyRepo);
    });
  });
}
