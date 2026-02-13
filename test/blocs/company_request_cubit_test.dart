import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/admin/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/admin/domain/company_request.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late CompanyRequestCubit companyRequestCubit;
  late MockCompanyRepository mockCompanyRepo;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockCompanyRepo = MockCompanyRepository();
    mockUserRepo = MockUserRepository();
    companyRequestCubit = CompanyRequestCubit(mockCompanyRepo, mockUserRepo);
  });

  test("init state should be CompanyRequestInitial", () {
    expect(companyRequestCubit.state, CompanyRequestInitial());
  });

  group("CompanyCubit_getPendingCompanyRequest", () {
    const requestID = "1";
    final testCompanyRequest =
        CompanyRequest(id: UniqueID.fromUniqueString(requestID));
    test("should call company repo if function is called", () async {
      // Given
      when(mockCompanyRepo.getPendingCompanyRequest(requestID))
          .thenAnswer((_) async => right(testCompanyRequest));
      // When
      companyRequestCubit.getPendingCompanyRequest(requestID);
      await untilCalled(mockCompanyRepo.getPendingCompanyRequest(requestID));
      // Then
      verify(mockCompanyRepo.getPendingCompanyRequest(requestID));
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test(
        "should emit PendingCompanyRequestLoadingState and then PendingCompanyRequestSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        CompanyRequestLoadingState(),
        PendingCompanyRequestSuccessState(request: testCompanyRequest)
      ];
      when(mockCompanyRepo.getPendingCompanyRequest(requestID))
          .thenAnswer((_) async => right(testCompanyRequest));
      // Then
      expectLater(companyRequestCubit.stream, emitsInOrder(expectedResult));
      companyRequestCubit.getPendingCompanyRequest(requestID);
    });

    test(
        "should emit PendingCompanyRequestLoadingState and then PendingCompanyRequestFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        CompanyRequestLoadingState(),
        PendingCompanyRequestFailureState(failure: BackendFailure())
      ];
      when(mockCompanyRepo.getPendingCompanyRequest(requestID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(companyRequestCubit.stream, emitsInOrder(expectedResult));
      companyRequestCubit.getPendingCompanyRequest(requestID);
    });
  });
}
