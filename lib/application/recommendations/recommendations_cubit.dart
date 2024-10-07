import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final UserRepository userRepo;
  final LandingPageRepository landingPagesRepo;
  RecommendationsCubit(this.userRepo, this.landingPagesRepo)
      : super(RecommendationsInitial());

  void getUser() async {
    emit(RecommendationLoadingState());
    final failureOrSuccess = await userRepo.getUser();
    failureOrSuccess.fold((failure) {
      if (!isClosed) {
        emit(RecommendationGetUserFailureState(failure: failure));
      }
    }, (user) {
      if (!isClosed) {
        emit(RecommendationGetCurrentUserSuccessState(user: user));
      }
    });
  }

  void getParentUser(String parentID) async {
    emit(RecommendationLoadingState());
    final failureOrSuccess = await userRepo.getParentUser(parentID: parentID);
    failureOrSuccess.fold((failure) {
      if (!isClosed) {
        emit(RecommendationGetUserFailureState(failure: failure));
      }
    }, (user) {
      if (!isClosed) {
        emit(RecommendationGetParentUserSuccessState(user: user));
      }
    });
  }

  void getRecommendationReasons(List<String> landingPageIDs) async {
    emit(RecommendationLoadingState());
    if (landingPageIDs.isEmpty) {
      emit(RecommendationNoReasonsState());
    } else {
      final failureOrSuccess =
          await landingPagesRepo.getAllLandingPages(landingPageIDs);
      failureOrSuccess.fold(
          (failure) =>
              emit(RecommendationGetReasonsFailureState(failure: failure)),
          (landingPages) {
        final reasons = landingPages
            .map((e) => {'name': e.name, 'isActive': e.isActive})
            .toList();
        final reasonsWithoutNullValues =
            reasons.whereType<Map<String, Object?>>().toList();
        emit(RecommendationGetReasonsSuccessState(
            reasons: reasonsWithoutNullValues));
      });
    }
  }
}
