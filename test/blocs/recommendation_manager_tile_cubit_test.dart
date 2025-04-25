import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late RecommendationManagerTileCubit recoManagerTileCubit;
  late MockRecommendationRepository mockRecoRepo;

  setUp(() {
    mockRecoRepo = MockRecommendationRepository();
    recoManagerTileCubit = RecommendationManagerTileCubit(mockRecoRepo);
  });

  test("init state should be RecommendationsInitial", () {
    expect(recoManagerTileCubit.state, RecommendationManagerTileInitial());
  });

  group("RecommendationManagerTileCubit_setAppointmentState", () {
    final date = DateTime.now();
    final recommendation = RecommendationItem(
        id: "1",
        name: "Test",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test",
        serviceProviderName: "Test",
        defaultLandingPageID: "2",
        userID: "1",
        statusLevel: 2,
        statusTimestamps: {0: date, 1: date, 2: date});

    test("should call user repo when function is called", () async {
      // Given
      when(mockRecoRepo.setAppointmentState(recommendation))
          .thenAnswer((_) async => right(recommendation));
      // When
      recoManagerTileCubit.setAppointmentState(recommendation);
      await untilCalled(mockRecoRepo.setAppointmentState(recommendation));
      // Then
      verify(mockRecoRepo.setAppointmentState(recommendation));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationSetStatusLoadingState and then RecommendationSetStatusSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusLoadingState(recommendation: recommendation),
        RecommendationSetStatusSuccessState(recommendation: recommendation)
      ];
      when(mockRecoRepo.setAppointmentState(recommendation))
          .thenAnswer((_) async => right(recommendation));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setAppointmentState(recommendation);
    });

    test(
        "should emit RecommendationSetStatusLoadingState and then RecommendationSetStatusFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        RecommendationSetStatusLoadingState(recommendation: recommendation),
        RecommendationSetStatusFailureState(
            failure: BackendFailure(), recommendation: recommendation)
      ];
      when(mockRecoRepo.setAppointmentState(recommendation))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerTileCubit.stream, emitsInOrder(expectedResult));
      recoManagerTileCubit.setAppointmentState(recommendation);
    });
  });
}
