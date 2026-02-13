import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/admin/application/company_request/company_request_observer/company_request_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/admin/domain/company_request.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late CompanyRequestObserverCubit companyRequestObserverCubit;
  late MockCompanyRepository mockCompanyRepo;

  setUp(() {
    mockCompanyRepo = MockCompanyRepository();
    companyRequestObserverCubit = CompanyRequestObserverCubit(mockCompanyRepo);
  });

  test("init state should be ProfileObserverInitial", () {
    expect(companyRequestObserverCubit.state, CompanyRequestObserverInitial());
  });

  group("CompanyRequestObserverCubit_observeAllPendingCompanyRequests", () {
    final CompanyRequest testCompanyRequest =
        CompanyRequest(id: UniqueID.fromUniqueString("1"));
    final CompanyRequest testCompanyRequest2 =
        CompanyRequest(id: UniqueID.fromUniqueString("2"));
    test("should call repo if function is called", () async {
      // Given
      when(mockCompanyRepo.observeCompanyRequests()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, List<CompanyRequest>>>.fromIterable([
            right([testCompanyRequest, testCompanyRequest2])
          ]));
      // When
      companyRequestObserverCubit.observeAllPendingCompanyRequests();
      await untilCalled(mockCompanyRepo.observeCompanyRequests());
      // Then
      verify(mockCompanyRepo.observeCompanyRequests());
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test(
        "should emit CompanyRequestObserverLoading and then CompanyRequestObserverSuccess when event is added",
        () {
      // Given
      final expectedResult = [
        CompanyRequestObserverLoading(),
        CompanyRequestObserverSuccess(
            requests: [testCompanyRequest, testCompanyRequest2])
      ];
      when(mockCompanyRepo.observeCompanyRequests()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, List<CompanyRequest>>>.fromIterable([
            right([testCompanyRequest, testCompanyRequest2])
          ]));
      // Then
      expectLater(
          companyRequestObserverCubit.stream, emitsInOrder(expectedResult));
      companyRequestObserverCubit.observeAllPendingCompanyRequests();
    });

    test(
        "should emit CompanyRequestObserverLoading and then CompanyRequestObserverFailure when event is added and call has failed",
        () {
      // Given
      final expectedResult = [
        CompanyRequestObserverLoading(),
        CompanyRequestObserverFailure(failure: BackendFailure())
      ];
      when(mockCompanyRepo.observeCompanyRequests()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, List<CompanyRequest>>>.fromIterable(
              [left(BackendFailure())]));
      // Then
      expectLater(
          companyRequestObserverCubit.stream, emitsInOrder(expectedResult));
      companyRequestObserverCubit.observeAllPendingCompanyRequests();
    });
  });

  group("CompanyRequestObserverCubit_getAllUsersForCompanyRequests", () {
    final ids = ["1", "2"];
    final testRequests = [
      CompanyRequest(
          id: UniqueID.fromUniqueString("1"),
          userID: UniqueID.fromUniqueString("1")),
      CompanyRequest(
          id: UniqueID.fromUniqueString("2"),
          userID: UniqueID.fromUniqueString("2"))
    ];
    final testUsers = [
      CustomUser(id: UniqueID.fromUniqueString("1")),
      CustomUser(id: UniqueID.fromUniqueString("2"))
    ];

    test("should call company repo if function is called", () async {
      // Given
      when(mockCompanyRepo.getAllUsersForPendingCompanyRequests(ids))
          .thenAnswer((_) async => right(testUsers));
      // When
      companyRequestObserverCubit.getAllUsersForCompanyRequests(testRequests);
      await untilCalled(
          mockCompanyRepo.getAllUsersForPendingCompanyRequests(ids));
      // Then
      verify(mockCompanyRepo.getAllUsersForPendingCompanyRequests(ids));
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test(
        "should emit CompanyRequestObserverLoading and then CompanyRequestObserverGetUsersSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        CompanyRequestObserverLoading(),
        CompanyRequestObserverGetUsersSuccessState(users: testUsers)
      ];
      when(mockCompanyRepo.getAllUsersForPendingCompanyRequests(ids))
          .thenAnswer((_) async => right(testUsers));
      // Then
      expectLater(
          companyRequestObserverCubit.stream, emitsInOrder(expectedResult));
      companyRequestObserverCubit.getAllUsersForCompanyRequests(testRequests);
    });

    test(
        "should emit CompanyRequestObserverLoading and then CompanyRequestObserverGetUsersFailureState when function is called",
        () async {
      // Given
      final expectedResult = [
        CompanyRequestObserverLoading(),
        CompanyRequestObserverGetUsersFailureState(failure: BackendFailure())
      ];
      when(mockCompanyRepo.getAllUsersForPendingCompanyRequests(ids))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(
          companyRequestObserverCubit.stream, emitsInOrder(expectedResult));
      companyRequestObserverCubit.getAllUsersForCompanyRequests(testRequests);
    });
  });
}
