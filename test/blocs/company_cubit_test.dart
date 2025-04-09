import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late CompanyCubit companyCubit;
  late MockCompanyRepository mockCompanyRepo;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockCompanyRepo = MockCompanyRepository();
    mockAuthRepo = MockAuthRepository();
    companyCubit = CompanyCubit(mockCompanyRepo, mockAuthRepo);
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
      when(mockCompanyRepo.updateCompany(testCompany, true))
          .thenAnswer((_) async => right(unit));
      // When
      companyCubit.updateCompany(testCompany, true);
      await untilCalled(mockCompanyRepo.updateCompany(testCompany, true));
      // Then
      verify(mockCompanyRepo.updateCompany(testCompany, true));
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
      when(mockCompanyRepo.updateCompany(testCompany, true))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.updateCompany(testCompany, true);
    });

    test(
        "should emit CompanyUpdateContactInformationLoadingState and then CompanyUpdateContactInformationFailureState when function is called and there was an error",
        () {
      // Given
      final expectedResult = [
        CompanyUpdateContactInformationLoadingState(),
        CompanyUpdateContactInformationFailureState(failure: BackendFailure())
      ];
      when(mockCompanyRepo.updateCompany(testCompany, true))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.updateCompany(testCompany, true);
    });
  });

  group("CompanyCubit_getCompany", () {
    const String companyID = "1";
    final testCompany = Company(
        id: UniqueID.fromUniqueString(companyID),
        name: "Test",
        industry: "Test");
    test("should call company repo if function is called", () async {
      // Given
      when(mockCompanyRepo.getCompany(companyID))
          .thenAnswer((_) async => right(testCompany));
      // When
      companyCubit.getCompany(companyID);
      await untilCalled(mockCompanyRepo.getCompany(companyID));
      // Then
      verify(mockCompanyRepo.getCompany(companyID));
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test(
        "should emit GetCompanyLoadingState and then GetCompanySuccessState when function is called",
        () {
      // Given
      final expectedResult = [
        GetCompanyLoadingState(),
        GetCompanySuccessState(company: testCompany)
      ];
      when(mockCompanyRepo.getCompany(companyID))
          .thenAnswer((_) async => right(testCompany));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.getCompany(companyID);
    });

    test(
        "should emit GetCompanyLoadingState and then GetCompanyFailureState when function is called and there was an error",
        () {
      // Given
      final expectedResult = [
        GetCompanyLoadingState(),
        GetCompanyFailureState(failure: BackendFailure())
      ];
      when(mockCompanyRepo.getCompany(companyID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.getCompany(companyID);
    });
  });

  group("CompanyCubit_registerCompany", () {
    final testCompany = Company(
        id: UniqueID.fromUniqueString("1"), name: "Test", industry: "Test");
    test("should call company repo if function is called", () async {
      // Given
      when(mockCompanyRepo.registerCompany(testCompany, true))
          .thenAnswer((_) async => right(unit));
      // When
      companyCubit.registerCompany(testCompany, true);
      await untilCalled(mockCompanyRepo.registerCompany(testCompany, true));
      // Then
      verify(mockCompanyRepo.registerCompany(testCompany, true));
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test(
        "should emit CompanyRegisterLoadingState and then CompanyRegisterSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        CompanyRegisterLoadingState(),
        CompanyRegisterSuccessState()
      ];
      when(mockCompanyRepo.registerCompany(testCompany, true))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.registerCompany(testCompany, true);
    });

    test(
        "should emit CompanyRegisterLoadingState and then CompanyRegisterFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        CompanyRegisterLoadingState(),
        CompanyRegisterFailureState(failure: BackendFailure())
      ];
      when(mockCompanyRepo.registerCompany(testCompany, true))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.registerCompany(testCompany, true);
    });
  });

  group("CompanyCubit_getPDFDownloadURL", () {
    final url = "https://test.de";
    final testCompany = Company(
        id: UniqueID.fromUniqueString("1"), name: "Test", industry: "Test");
    test("should call company repo if function is called", () async {
      // Given
      when(mockCompanyRepo.getAVVDownloadURL(testCompany, true))
          .thenAnswer((_) async => right(url));
      // When
      companyCubit.getPDFDownloadURL(testCompany, true);
      await untilCalled(mockCompanyRepo.getAVVDownloadURL(testCompany, true));
      // Then
      verify(mockCompanyRepo.getAVVDownloadURL(testCompany, true));
      verifyNoMoreInteractions(mockCompanyRepo);
    });

    test(
        "should emit CompanyGetAVVPDFLoadingState and then CompanyGetAVVPDFSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        CompanyGetAVVPDFLoadingState(),
        CompanyGetAVVPDFSuccessState(downloadURL: url)
      ];
      when(mockCompanyRepo.getAVVDownloadURL(testCompany, true))
          .thenAnswer((_) async => right(url));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.getPDFDownloadURL(testCompany, true);
    });

    test(
        "should emit CompanyGetAVVPDFLoadingState and then CompanyGetAVVPDFFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        CompanyGetAVVPDFLoadingState(),
        CompanyGetAVVPDFFailureState(failure: BackendFailure())
      ];
      when(mockCompanyRepo.getAVVDownloadURL(testCompany, true))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(companyCubit.stream, emitsInOrder(expectedResult));
      companyCubit.getPDFDownloadURL(testCompany, true);
    });
  });
}
