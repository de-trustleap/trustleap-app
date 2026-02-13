import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late RecommendationManagerArchiveCubit recoManagerCubit;
  late MockRecommendationRepository mockRecoRepo;

  setUp(() {
    mockRecoRepo = MockRecommendationRepository();
    recoManagerCubit =
        RecommendationManagerArchiveCubit(mockRecoRepo);
  });

  test("init state should be RecommendationsInitial", () {
    expect(recoManagerCubit.state, RecommendationManagerArchiveInitial());
  });


  group("RecommendationManagerArchiveCubit_getArchivedRecommendations", () {
    final userID = "1";
    final date = DateTime.now();
    final recommendations = <ArchivedRecommendationItem>[
      ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: userID,
          createdAt: null,
          finishedTimeStamp: date),
    ];

    test("should call reco repo when function is called", () async {
      // Given
      when(mockRecoRepo.getArchivedRecommendations(userID))
          .thenAnswer((_) async => right(recommendations));
      // When
      recoManagerCubit.getArchivedRecommendations(userID);
      await untilCalled(mockRecoRepo.getArchivedRecommendations(userID));
      // Then
      verify(mockRecoRepo.getArchivedRecommendations(userID));
      verifyNoMoreInteractions(mockRecoRepo);
    });

    test(
        "should emit RecommendationManagerArchiveLoadingState and then RecommendationGetRecosSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerArchiveLoadingState(),
        RecommendationManagerArchiveGetRecommendationsSuccessState(
            recommendations: recommendations)
      ];
      when(mockRecoRepo.getArchivedRecommendations(userID))
          .thenAnswer((_) async => right(recommendations));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.getArchivedRecommendations(userID);
    });

    test(
        "should emit RecommendationManagerArchiveLoadingState and then RecommendationGetUserFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerArchiveLoadingState(),
        RecommendationManagerArchiveGetRecommendationsFailureState(
            failure: BackendFailure())
      ];
      when(mockRecoRepo.getArchivedRecommendations(userID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.getArchivedRecommendations(userID);
    });
  });
}
