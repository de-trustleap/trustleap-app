import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_cubit.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late RecommendationManagerArchiveCubit recoManagerCubit;
  late MockUserRepository mockUserRepo;
  late MockRecommendationRepository mockRecoRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
    mockRecoRepo = MockRecommendationRepository();
    recoManagerCubit =
        RecommendationManagerArchiveCubit(mockRecoRepo, mockUserRepo);
  });

  test("init state should be RecommendationsInitial", () {
    expect(recoManagerCubit.state, RecommendationManagerArchiveInitial());
  });

  group("RecommendationManagerArchiveCubit_getUser", () {
    final user = CustomUser(id: UniqueID.fromUniqueString("1"));
    test("should call user repo when function is called", () async {
      // Given
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(user));
      // When
      recoManagerCubit.getUser();
      await untilCalled(mockUserRepo.getUser());
      // Then
      verify(mockUserRepo.getUser());
      verifyNoMoreInteractions(mockUserRepo);
    });

    test(
        "should emit RecommendationManagerArchiveLoadingState and then RecommendationManagerArchiveGetUserSuccessState when call was successful",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerArchiveLoadingState(),
        RecommendationManagerArchiveGetUserSuccessState(user: user)
      ];
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(user));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.getUser();
    });

    test(
        "should emit RecommendationManagerArchiveLoadingState and then RecommendationManagerArchiveGetUserFailureState when call has failed",
        () async {
      // Given
      final expectedResult = [
        RecommendationManagerArchiveLoadingState(),
        RecommendationManagerArchiveGetUserFailureState(
            failure: BackendFailure())
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(recoManagerCubit.stream, emitsInOrder(expectedResult));
      recoManagerCubit.getUser();
    });
  });

  group("RecommendationManagerArchiveCubit_getArchivedRecommendations", () {
    final userID = "1";
    final date = DateTime.now();
    final recommendations = [
      ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: userID,
          createdAt: null,
          finishedTimeStamp: date,
          expiresAt: null)
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
