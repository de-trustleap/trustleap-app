import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/promoter/domain/unregistered_promoter.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockPromoterRepository mockPromoterRepo;

  setUp(() {
    mockPromoterRepo = MockPromoterRepository();
  });

  group("PromoterRepositoryImplementation_RegisterPromoter", () {
    final testPromoter = UnregisteredPromoter(
        id: UniqueID.fromUniqueString("1"),
        gender: Gender.male,
        firstName: "Max",
        lastName: "Mustermann",
        parentUserID: UniqueID.fromUniqueString("2"),
        code: UniqueID.fromUniqueString("1234"));
    test("should return unit when registration of promoter was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockPromoterRepo.registerPromoter(promoter: testPromoter))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockPromoterRepo.registerPromoter(promoter: testPromoter);
      // Then
      verify(mockPromoterRepo.registerPromoter(promoter: testPromoter));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(AlreadyExistsFailure());
      when(mockPromoterRepo.registerPromoter(promoter: testPromoter))
          .thenAnswer((_) async => left(AlreadyExistsFailure()));
      // When
      final result =
          await mockPromoterRepo.registerPromoter(promoter: testPromoter);
      // Then
      verify(mockPromoterRepo.registerPromoter(promoter: testPromoter));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });
  });

  group("PromoterRepositoryImplementation_CheckIfPromoterAlreadyExists", () {
    const testEmail = "tester@test.de";
    test(
        "should return true when promoter already exists and the call succeeded",
        () async {
      // Given
      final expectedResult = right(true);
      when(mockPromoterRepo.checkIfPromoterAlreadyExists(email: testEmail))
          .thenAnswer((_) async => right(true));
      // When
      final result =
          await mockPromoterRepo.checkIfPromoterAlreadyExists(email: testEmail);
      // Then
      verify(mockPromoterRepo.checkIfPromoterAlreadyExists(email: testEmail));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPromoterRepo.checkIfPromoterAlreadyExists(email: testEmail))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result =
          await mockPromoterRepo.checkIfPromoterAlreadyExists(email: testEmail);
      // Then
      verify(mockPromoterRepo.checkIfPromoterAlreadyExists(email: testEmail));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });
  });

  group("PromoterRepositoryImplementation_GetRegisteredPromoters", () {
    final List<CustomUser> testUsers = [
      CustomUser(id: UniqueID.fromUniqueString("1"), lastName: "Mustermann"),
      CustomUser(id: UniqueID.fromUniqueString("2"), lastName: "Musterfrau")
    ];
    final List<String> testIds = ["1", "2"];
    test("should return list of users when the call was successful", () async {
      // Given
      final expectedResult = right(testUsers);
      when(mockPromoterRepo.getRegisteredPromoters(testIds))
          .thenAnswer((_) async => right(testUsers));
      // When
      final result = await mockPromoterRepo.getRegisteredPromoters(testIds);
      // Then
      verify(mockPromoterRepo.getRegisteredPromoters(testIds));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPromoterRepo.getRegisteredPromoters(testIds))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockPromoterRepo.getRegisteredPromoters(testIds);
      // Then
      verify(mockPromoterRepo.getRegisteredPromoters(testIds));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });
  });

  group("PromoterRepositoryImplementation_GetUnregisteredPromoters", () {
    final List<UnregisteredPromoter> testPromoters = [
      UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234")),
      UnregisteredPromoter(
          id: UniqueID.fromUniqueString("2"),
          gender: Gender.female,
          firstName: "Maria",
          lastName: "Musterfrau",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1235"))
    ];
    final List<String> testIds = ["1", "2"];
    test(
        "should return list of unregistered promoters when call was successful",
        () async {
      // Given
      final expectedResult = right(testPromoters);
      when(mockPromoterRepo.getUnregisteredPromoters(testIds))
          .thenAnswer((_) async => right(testPromoters));
      // When
      final result = await mockPromoterRepo.getUnregisteredPromoters(testIds);
      // Then
      verify(mockPromoterRepo.getUnregisteredPromoters(testIds));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPromoterRepo.getUnregisteredPromoters(testIds))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockPromoterRepo.getUnregisteredPromoters(testIds);
      // Then
      verify(mockPromoterRepo.getUnregisteredPromoters(testIds));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });
  });

  group("PromoterRepositoryImplementation_DeletePromoter", () {
    const testID = "1";
    test("should return nothing when call was successful", () async {
      // Given
      final expectedResult = right(unit);
      when(mockPromoterRepo.deletePromoter(id: testID, isRegistered: false))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockPromoterRepo.deletePromoter(
          id: testID, isRegistered: false);
      // Then
      verify(mockPromoterRepo.deletePromoter(id: testID, isRegistered: false));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPromoterRepo.deletePromoter(id: testID, isRegistered: false))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockPromoterRepo.deletePromoter(
          id: testID, isRegistered: false);
      // Then
      verify(mockPromoterRepo.deletePromoter(id: testID, isRegistered: false));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });
  });

  group("PromoterRepositoryImplementation_EditPromoter", () {
    const isRegistered = true;
    const landingPageIDs = ["1", "2"];
    const promoterID = "3";
    test("should return nothing when call was successful", () async {
      // Given
      final expectedResult = right(unit);
      when(mockPromoterRepo.editPromoter(
              isRegistered: isRegistered,
              landingPageIDs: landingPageIDs,
              promoterID: promoterID))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockPromoterRepo.editPromoter(
          isRegistered: isRegistered,
          landingPageIDs: landingPageIDs,
          promoterID: promoterID);
      // Then
      verify(mockPromoterRepo.editPromoter(
          isRegistered: isRegistered,
          landingPageIDs: landingPageIDs,
          promoterID: promoterID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPromoterRepo.editPromoter(
              isRegistered: isRegistered,
              landingPageIDs: landingPageIDs,
              promoterID: promoterID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockPromoterRepo.editPromoter(
          isRegistered: isRegistered,
          landingPageIDs: landingPageIDs,
          promoterID: promoterID);
      // Then
      verify(mockPromoterRepo.editPromoter(
          isRegistered: isRegistered,
          landingPageIDs: landingPageIDs,
          promoterID: promoterID));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });
  });

  group("PromoterRepositoryImplementation_GetLandingPages", () {
    final landingPages = [
      LandingPage(id: UniqueID.fromUniqueString("1")),
      LandingPage(id: UniqueID.fromUniqueString("2"))
    ];
    final ids = ["1", "2"];
    test("should return landingpages when call was successful", () async {
      // Given
      final expectedResult = right(landingPages);
      when(mockPromoterRepo.getLandingPages(ids))
          .thenAnswer((_) async => right(landingPages));
      // When
      final result = await mockPromoterRepo.getLandingPages(ids);
      // Then
      verify(mockPromoterRepo.getLandingPages(ids));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPromoterRepo.getLandingPages(ids))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockPromoterRepo.getLandingPages(ids);
      // Then
      verify(mockPromoterRepo.getLandingPages(ids));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });
  });

  group("PromoterRepositoryImplementation_GetPromoter", () {
    final id = "1";
    final promoter = Promoter(id: UniqueID.fromUniqueString(id));
    test("should return promoter when call was successful", () async {
      // Given
      final expectedResult = right(promoter);
      when(mockPromoterRepo.getPromoter(id))
          .thenAnswer((_) async => right(promoter));
      // When
      final result = await mockPromoterRepo.getPromoter(id);
      // Then
      verify(mockPromoterRepo.getPromoter(id));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPromoterRepo.getPromoter(id))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockPromoterRepo.getPromoter(id);
      // Then
      verify(mockPromoterRepo.getPromoter(id));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockPromoterRepo);
    });
  });
}
