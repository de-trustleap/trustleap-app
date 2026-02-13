import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/legals/application/admin_legals/admin_legals_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/legals/domain/legals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  late AdminLegalsCubit cubit;
  late MockLegalsRepository mockLegalsRepository;

  setUp(() {
    mockLegalsRepository = MockLegalsRepository();
    cubit = AdminLegalsCubit(mockLegalsRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('AdminLegalsCubit_InitialState', () {
    test('initial state should be AdminLegalsInitial', () {
      expect(cubit.state, AdminLegalsInitial());
    });
  });

  group('AdminLegalsCubit_GetLegals', () {
    const testLegals = Legals(
      avv: "Test AVV",
      privacyPolicy: "Test Privacy Policy",
      termsAndCondition: "Test Terms",
    );

    test('should call repo when getLegals is called', () async {
      // Given
      when(mockLegalsRepository.getAllLegals())
          .thenAnswer((_) async => right(testLegals));

      // When
      cubit.getLegals();
      await untilCalled(mockLegalsRepository.getAllLegals());

      // Then
      verify(mockLegalsRepository.getAllLegals()).called(1);
      verifyNoMoreInteractions(mockLegalsRepository);
    });

    test('should emit [AdminGetLegalsLoadingState, AdminGetLegalsSuccessState] when getAllLegals succeeds', () {
      // Given
      final expectedResult = [
        AdminGetLegalsLoadingState(),
        AdminGetLegalsSuccessState(legals: testLegals),
      ];
      when(mockLegalsRepository.getAllLegals())
          .thenAnswer((_) async => right(testLegals));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getLegals();
    });

    test('should emit [AdminGetLegalsLoadingState, AdminGetLegalsFailureState] when getAllLegals fails', () {
      // Given
      final expectedResult = [
        AdminGetLegalsLoadingState(),
        AdminGetLegalsFailureState(failure: NotFoundFailure()),
      ];
      when(mockLegalsRepository.getAllLegals())
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getLegals();
    });

    test('should emit [AdminGetLegalsLoadingState, AdminGetLegalsFailureState] when backend error occurs', () {
      // Given
      final expectedResult = [
        AdminGetLegalsLoadingState(),
        AdminGetLegalsFailureState(failure: BackendFailure()),
      ];
      when(mockLegalsRepository.getAllLegals())
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getLegals();
    });
  });

  group('AdminLegalsCubit_SaveLegals', () {
    const testLegals = Legals(
      avv: "Updated AVV",
      privacyPolicy: "Updated Privacy Policy",
      termsAndCondition: "Updated Terms",
    );

    test('should call repo when saveLegals is called', () async {
      // Given
      when(mockLegalsRepository.saveLegals(testLegals))
          .thenAnswer((_) async => right(unit));

      // When
      cubit.saveLegals(testLegals);
      await untilCalled(mockLegalsRepository.saveLegals(testLegals));

      // Then
      verify(mockLegalsRepository.saveLegals(testLegals)).called(1);
      verifyNoMoreInteractions(mockLegalsRepository);
    });

    test('should emit [AdminSaveLegalsLoadingState, AdminSaveLegalsSuccessState] when saveLegals succeeds', () {
      // Given
      final expectedResult = [
        AdminSaveLegalsLoadingState(),
        AdminSaveLegalsSuccessState(),
      ];
      when(mockLegalsRepository.saveLegals(testLegals))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.saveLegals(testLegals);
    });

    test('should emit [AdminSaveLegalsLoadingState, AdminSaveLegalsFailureState] when saveLegals fails', () {
      // Given
      final expectedResult = [
        AdminSaveLegalsLoadingState(),
        AdminSaveLegalsFailureState(failure: BackendFailure()),
      ];
      when(mockLegalsRepository.saveLegals(testLegals))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.saveLegals(testLegals);
    });

    test('should emit [AdminSaveLegalsLoadingState, AdminSaveLegalsFailureState] when permission error occurs', () {
      // Given
      final expectedResult = [
        AdminSaveLegalsLoadingState(),
        AdminSaveLegalsFailureState(failure: PermissionDeniedFailure()),
      ];
      when(mockLegalsRepository.saveLegals(testLegals))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.saveLegals(testLegals);
    });

    test('should emit [AdminLegalsShowValidationState] when saveLegals is called with null', () {
      // Given
      final expectedResult = [
        AdminLegalsShowValidationState(),
      ];

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.saveLegals(null);
      
      // Verify no repo interaction
      verifyNever(mockLegalsRepository.saveLegals(any));
    });

    test('should handle legals with null values correctly', () {
      // Given
      const legalsWithNulls = Legals(
        avv: null,
        privacyPolicy: "Only Privacy Policy",
        termsAndCondition: null,
      );
      final expectedResult = [
        AdminSaveLegalsLoadingState(),
        AdminSaveLegalsSuccessState(),
      ];
      when(mockLegalsRepository.saveLegals(legalsWithNulls))
          .thenAnswer((_) async => right(unit));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.saveLegals(legalsWithNulls);
    });
  });
}