import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';

void main() {
  late PromoterCubit promoterCubit;
  late MockPromoterRepository mockPromoterRepo;
  late MockUserRepository mockUserRepo;
  late MockLandingPageRepository mockLandingPagesRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
    mockLandingPagesRepo = MockLandingPageRepository();
    mockPromoterRepo = MockPromoterRepository();
    promoterCubit =
        PromoterCubit(mockPromoterRepo, mockUserRepo, mockLandingPagesRepo);
  });

  test("init state should be PromoterInitial", () {
    expect(promoterCubit.state, PromoterInitial());
  });

  group("PromoterCubit_DeletePromoter", () {
    final testID = "1";
    test("should call promoter repo when function is called", () async {
      // Given
      when(mockPromoterRepo.deletePromoter(id: testID))
          .thenAnswer((_) async => right(unit));
      // When
      promoterCubit.deletePromoter(testID);
      await untilCalled(mockPromoterRepo.deletePromoter(id: testID));
      // Then
      verify(mockPromoterRepo.deletePromoter(id: testID));
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test(
        "should emit PromoterLoadingState and then PromoterDeleteSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        PromoterLoadingState(),
        PromoterDeleteSuccessState()
      ];
      when(mockPromoterRepo.deletePromoter(id: testID))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(promoterCubit.stream, emitsInOrder(expectedResult));
      promoterCubit.deletePromoter(testID);
    });

    test(
        "should emit PromoterLoadingState and then PromoterDeleteFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        PromoterLoadingState(),
        PromoterDeleteFailureState(failure: BackendFailure())
      ];
      when(mockPromoterRepo.deletePromoter(id: testID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(promoterCubit.stream, emitsInOrder(expectedResult));
      promoterCubit.deletePromoter(testID);
    });
  });

  group("PromoterCubit_EditPromoter", () {
    const isRegistered = true;
    const landingPageIDs = ["1", "2"];
    const promoterID = "3";

    test("should call promoter repo when function is called", () async {
      // Given
      when(mockPromoterRepo.editPromoter(
              isRegistered: isRegistered,
              landingPageIDs: landingPageIDs,
              promoterID: promoterID))
          .thenAnswer((_) async => right(unit));
      // When
      promoterCubit.editPromoter(isRegistered, landingPageIDs, promoterID);
      await untilCalled(mockPromoterRepo.editPromoter(
          isRegistered: isRegistered,
          landingPageIDs: landingPageIDs,
          promoterID: promoterID));
      // Then
      verify(mockPromoterRepo.editPromoter(
          isRegistered: isRegistered,
          landingPageIDs: landingPageIDs,
          promoterID: promoterID));
      verifyNoMoreInteractions(mockPromoterRepo);
    });

    test(
        "should emit PromoterLoadingState and then PromoterEditSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        PromoterLoadingState(),
        PromoterEditSuccessState()
      ];
      when(mockPromoterRepo.editPromoter(
              isRegistered: isRegistered,
              landingPageIDs: landingPageIDs,
              promoterID: promoterID))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(promoterCubit.stream, emitsInOrder(expectedResult));
      promoterCubit.editPromoter(isRegistered, landingPageIDs, promoterID);
    });

    test(
        "should emit PromoterLoadingState and then PromoterEditFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        PromoterLoadingState(),
        PromoterEditFailureState(failure: BackendFailure())
      ];
      when(mockPromoterRepo.editPromoter(
              isRegistered: isRegistered,
              landingPageIDs: landingPageIDs,
              promoterID: promoterID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(promoterCubit.stream, emitsInOrder(expectedResult));
      promoterCubit.editPromoter(isRegistered, landingPageIDs, promoterID);
    });
  });

  group("PromoterCubit_GetPromoter", () {
    const id = "1";
    final promoter = Promoter(id: UniqueID.fromUniqueString(id));
    final user = CustomUser(
        id: UniqueID.fromUniqueString("1"), registeredPromoterIDs: ["1"]);
    final permission = Permissions(permissions: {"editPromoter": true});

    test(
        "should emit PromoterLoadingState and then PromoterGetSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        PromoterLoadingState(),
        PromoterGetSuccessState(promoter: promoter)
      ];
      when(mockPromoterRepo.getPromoter(id))
          .thenAnswer((_) async => right(promoter));
      // Then
      expectLater(promoterCubit.stream, emitsInOrder(expectedResult));
      promoterCubit.getPromoter(id, user, permission);
    });

    test(
        "should emit PromoterLoadingState and then PromoterGetFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        PromoterLoadingState(),
        PromoterGetFailureState(failure: BackendFailure())
      ];
      when(mockPromoterRepo.getPromoter(id))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(promoterCubit.stream, emitsInOrder(expectedResult));
      promoterCubit.getPromoter(id, user, permission);
    });
  });
}
