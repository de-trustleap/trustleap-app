import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';

part 'recommendation_manager_state.dart';

class RecommendationManagerCubit extends Cubit<RecommendationManagerState> {
  final RecommendationRepository recommendationRepo;
  RecommendationManagerCubit(this.recommendationRepo)
      : super(RecommendationManagerInitial());

  void getRecommendations(String? userID) async {
    if (userID == null) {
      emit(RecommendationGetRecosFailureState(failure: NotFoundFailure()));
      return;
    }
    emit(RecommendationGetRecosLoadingState());
    final failureOrSuccess =
        await recommendationRepo.getRecommendations(userID);
    failureOrSuccess.fold((failure) {
      if (failure is NotFoundFailure) {
        emit(RecommendationGetRecosNoRecosState());
      } else {
        emit(RecommendationGetRecosFailureState(failure: failure));
      }
    },
        (recommendations) => emit(
            RecommendationGetRecosSuccessState(recoItems: recommendations)));
  }
}
