import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/profile/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../repositories/company_repository_test.mocks.dart';

void main() {
  late CompanyObserverCubit companyObserverCubit;
  late MockCompanyRepository mockCompanyRepo;

  setUp(() {
    mockCompanyRepo = MockCompanyRepository();
    companyObserverCubit = CompanyObserverCubit(mockCompanyRepo);
  });

  test("init state should be ProfileObserverInitial", () {
    expect(companyObserverCubit.state, CompanyObserverInitial());
  });

  group("CompanyObserverCubit_observeCompany", () {
    const String companyID = "1";
    final testCompany = Company(
        id: UniqueID.fromUniqueString(companyID),
        name: "Test",
        industry: "Test");

    test("should call repo if function is called", () async {
      // Given
      when(mockCompanyRepo.observeCompany(companyID)).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, Company>>.fromIterable(
              [right(testCompany)]));
      // When
      companyObserverCubit.observeCompany(companyID);
      await untilCalled(mockCompanyRepo.observeCompany(companyID));
      // Then
      verify(mockCompanyRepo.observeCompany(companyID));
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test(
        "should emit CompanyObserverLoading and then CompanyObserverSuccess when event is added",
        () {
      // Given
      final expectedResult = [
        CompanyObserverLoading(),
        CompanyObserverSuccess(company: testCompany)
      ];
      when(mockCompanyRepo.observeCompany(companyID)).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, Company>>.fromIterable(
              [right(testCompany)]));
      // Then
      expectLater(companyObserverCubit.stream, emitsInOrder(expectedResult));
      companyObserverCubit.observeCompany(companyID);
    });

    test(
        "should emit ProfileObserverLoading and then ProfileObserverFailure when event is added and repo failed",
        () {
      // Given
      final expectedResult = [
        CompanyObserverLoading(),
        CompanyObserverFailure(failure: BackendFailure())
      ];
      when(mockCompanyRepo.observeCompany(companyID)).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, Company>>.fromIterable(
              [left(BackendFailure())]));
      // Then
      expectLater(companyObserverCubit.stream, emitsInOrder(expectedResult));
      companyObserverCubit.observeCompany(companyID);
    });
  });
}
