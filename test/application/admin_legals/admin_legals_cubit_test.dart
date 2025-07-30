import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/legals/admin_legals/admin_legals_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/legals.dart';
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

  group('AdminLegalsCubit_GetLegals', () {
    const testLegals = Legals(
      avv: "Test AVV",
      privacyPolicy: "Test Privacy Policy",
      termsAndCondition: "Test Terms",
    );

    blocTest<AdminLegalsCubit, AdminLegalsState>(
      'should emit [AdminGetLegalsLoadingState, AdminGetLegalsSuccessState] when getAllLegals succeeds',
      build: () {
        when(mockLegalsRepository.getAllLegals())
            .thenAnswer((_) async => right(testLegals));
        return cubit;
      },
      act: (cubit) => cubit.getLegals(),
      expect: () => [
        AdminGetLegalsLoadingState(),
        AdminGetLegalsSuccessState(legals: testLegals),
      ],
      verify: (cubit) {
        verify(mockLegalsRepository.getAllLegals()).called(1);
        verifyNoMoreInteractions(mockLegalsRepository);
      },
    );

    blocTest<AdminLegalsCubit, AdminLegalsState>(
      'should emit [AdminGetLegalsLoadingState, AdminGetLegalsFailureState] when getAllLegals fails',
      build: () {
        when(mockLegalsRepository.getAllLegals())
            .thenAnswer((_) async => left(NotFoundFailure()));
        return cubit;
      },
      act: (cubit) => cubit.getLegals(),
      expect: () => [
        AdminGetLegalsLoadingState(),
        AdminGetLegalsFailureState(failure: NotFoundFailure()),
      ],
      verify: (cubit) {
        verify(mockLegalsRepository.getAllLegals()).called(1);
        verifyNoMoreInteractions(mockLegalsRepository);
      },
    );

    blocTest<AdminLegalsCubit, AdminLegalsState>(
      'should emit [AdminGetLegalsLoadingState, AdminGetLegalsFailureState] when backend error occurs',
      build: () {
        when(mockLegalsRepository.getAllLegals())
            .thenAnswer((_) async => left(BackendFailure()));
        return cubit;
      },
      act: (cubit) => cubit.getLegals(),
      expect: () => [
        AdminGetLegalsLoadingState(),
        AdminGetLegalsFailureState(failure: BackendFailure()),
      ],
      verify: (cubit) {
        verify(mockLegalsRepository.getAllLegals()).called(1);
        verifyNoMoreInteractions(mockLegalsRepository);
      },
    );
  });

  group('AdminLegalsCubit_SaveLegals', () {
    const testLegals = Legals(
      avv: "Updated AVV",
      privacyPolicy: "Updated Privacy Policy",
      termsAndCondition: "Updated Terms",
    );

    blocTest<AdminLegalsCubit, AdminLegalsState>(
      'should emit [AdminSaveLegalsLoadingState, AdminSaveLegalsSuccessState] when saveLegals succeeds',
      build: () {
        when(mockLegalsRepository.saveLegals(testLegals))
            .thenAnswer((_) async => right(unit));
        return cubit;
      },
      act: (cubit) => cubit.saveLegals(testLegals),
      expect: () => [
        AdminSaveLegalsLoadingState(),
        AdminSaveLegalsSuccessState(),
      ],
      verify: (cubit) {
        verify(mockLegalsRepository.saveLegals(testLegals)).called(1);
        verifyNoMoreInteractions(mockLegalsRepository);
      },
    );

    blocTest<AdminLegalsCubit, AdminLegalsState>(
      'should emit [AdminSaveLegalsLoadingState, AdminSaveLegalsFailureState] when saveLegals fails',
      build: () {
        when(mockLegalsRepository.saveLegals(testLegals))
            .thenAnswer((_) async => left(BackendFailure()));
        return cubit;
      },
      act: (cubit) => cubit.saveLegals(testLegals),
      expect: () => [
        AdminSaveLegalsLoadingState(),
        AdminSaveLegalsFailureState(failure: BackendFailure()),
      ],
      verify: (cubit) {
        verify(mockLegalsRepository.saveLegals(testLegals)).called(1);
        verifyNoMoreInteractions(mockLegalsRepository);
      },
    );

    blocTest<AdminLegalsCubit, AdminLegalsState>(
      'should emit [AdminSaveLegalsLoadingState, AdminSaveLegalsFailureState] when permission error occurs',
      build: () {
        when(mockLegalsRepository.saveLegals(testLegals))
            .thenAnswer((_) async => left(PermissionDeniedFailure()));
        return cubit;
      },
      act: (cubit) => cubit.saveLegals(testLegals),
      expect: () => [
        AdminSaveLegalsLoadingState(),
        AdminSaveLegalsFailureState(failure: PermissionDeniedFailure()),
      ],
      verify: (cubit) {
        verify(mockLegalsRepository.saveLegals(testLegals)).called(1);
        verifyNoMoreInteractions(mockLegalsRepository);
      },
    );

    blocTest<AdminLegalsCubit, AdminLegalsState>(
      'should emit [AdminLegalsShowValidationState] when saveLegals is called with null',
      build: () => cubit,
      act: (cubit) => cubit.saveLegals(null),
      expect: () => [
        AdminLegalsShowValidationState(),
      ],
      verify: (cubit) {
        verifyNever(mockLegalsRepository.saveLegals(any));
      },
    );

    blocTest<AdminLegalsCubit, AdminLegalsState>(
      'should handle legals with null values correctly',
      build: () {
        const legalsWithNulls = Legals(
          avv: null,
          privacyPolicy: "Only Privacy Policy",
          termsAndCondition: null,
        );
        when(mockLegalsRepository.saveLegals(legalsWithNulls))
            .thenAnswer((_) async => right(unit));
        return cubit;
      },
      act: (cubit) => cubit.saveLegals(const Legals(
        avv: null,
        privacyPolicy: "Only Privacy Policy",
        termsAndCondition: null,
      )),
      expect: () => [
        AdminSaveLegalsLoadingState(),
        AdminSaveLegalsSuccessState(),
      ],
      verify: (cubit) {
        verify(mockLegalsRepository.saveLegals(any)).called(1);
        verifyNoMoreInteractions(mockLegalsRepository);
      },
    );
  });

  group('AdminLegalsCubit_InitialState', () {
    test('initial state should be AdminLegalsInitial', () {
      expect(cubit.state, AdminLegalsInitial());
    });
  });
}