import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_reason.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/user_repository.dart';

part 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final UserRepository userRepo;
  final LandingPageRepository landingPagesRepo;

  RecommendationsCubit(this.userRepo, this.landingPagesRepo)
      : super(RecommendationsInitial());

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
            .map((e) => RecommendationReason(
                id: e.id,
                reason: e.name,
                isActive: e.isActive,
                promotionTemplate: e.promotionTemplate))
            .toList();
        final reasonsWithoutNullValues = reasons.toList();
        emit(RecommendationGetReasonsSuccessState(
            reasons: reasonsWithoutNullValues));
      });
    }
  }
}
