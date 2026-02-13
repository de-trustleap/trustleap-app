import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/legals/application/legals_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/constants.dart';

void main() {
  late LegalsCubit legalsCubit;
  late MockLegalsRepository mockLegalsRepo;

  setUp(() {
    mockLegalsRepo = MockLegalsRepository();
    legalsCubit = LegalsCubit(mockLegalsRepo);
  });

  test("init state should be CompanyInitial", () {
    expect(legalsCubit.state, LegalsInitial());
  });

  group("LegalsCubit_GetLegals", () {
    const privacyPolicy = "Test";
    test("should call company repo if function is called", () async {
      // Given
      when(mockLegalsRepo.getLegals(LegalsType.privacyPolicy))
          .thenAnswer((_) async => right(privacyPolicy));
      // When
      legalsCubit.getLegals(LegalsType.privacyPolicy);
      await untilCalled(mockLegalsRepo.getLegals(LegalsType.privacyPolicy));
      // Then
      verify(mockLegalsRepo.getLegals(LegalsType.privacyPolicy));
      verifyNoMoreInteractions(mockLegalsRepo);
    });

    test(
        "should emit GetLegalsLoadingState and then GetLegalsSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        GetLegalsLoadingState(),
        GetLegalsSuccessState(text: privacyPolicy)
      ];
      when(mockLegalsRepo.getLegals(LegalsType.privacyPolicy))
          .thenAnswer((_) async => right(privacyPolicy));
      // Then
      expectLater(legalsCubit.stream, emitsInOrder(expectedResult));
      legalsCubit.getLegals(LegalsType.privacyPolicy);
    });

    test(
        "should emit GetLegalsLoadingState and then GetLegalsFailureState when function failed",
        () async {
      // Given
      final expectedResult = [
        GetLegalsLoadingState(),
        GetLegalsFailureState(failure: BackendFailure())
      ];
      when(mockLegalsRepo.getLegals(LegalsType.privacyPolicy))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(legalsCubit.stream, emitsInOrder(expectedResult));
      legalsCubit.getLegals(LegalsType.privacyPolicy);
    });
  });
}
