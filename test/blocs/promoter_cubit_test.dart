import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';

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
}
