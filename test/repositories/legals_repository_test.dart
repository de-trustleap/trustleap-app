import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockLegalsRepository mockLegalsRepo;

  setUp(() {
    mockLegalsRepo = MockLegalsRepository();
  });

  group("LegalsRepositoryImplementation_GetLegals", () {
    const privacyPolicy = "Test";
    test("should return legals when call was successful", () async {
      // Given
      final expectedResult = right(privacyPolicy);
      when(mockLegalsRepo.getLegals(LegalsType.privacyPolicy))
          .thenAnswer((_) async => right(privacyPolicy));
      // When
      final result = await mockLegalsRepo.getLegals(LegalsType.privacyPolicy);
      // Then
      verify(mockLegalsRepo.getLegals(LegalsType.privacyPolicy));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLegalsRepo.getLegals(LegalsType.privacyPolicy))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLegalsRepo.getLegals(LegalsType.privacyPolicy);
      // Then
      verify(mockLegalsRepo.getLegals(LegalsType.privacyPolicy));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });
  });
}
