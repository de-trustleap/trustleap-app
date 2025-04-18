import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'recommendation_manager_state.dart';

class RecommendationManagerCubit extends Cubit<RecommendationManagerState> {
  final RecommendationRepository recommendationRepo;
  final UserRepository userRepo;
  RecommendationManagerCubit(this.recommendationRepo, this.userRepo)
      : super(RecommendationManagerInitial());

  void getRecommendations(String? userID) async {
    if (userID == null) {
      emit(RecommendationGetRecosFailureState(failure: NotFoundFailure()));
      return;
    }
    emit(RecommendationManagerLoadingState());
    final failureOrSuccess =
        await recommendationRepo.getRecommendations(userID);
    failureOrSuccess.fold((failure) {
      if (failure is NotFoundFailure) {
        emit(RecommendationGetRecosNoRecosState());
      } else {
        emit(RecommendationGetRecosFailureState(failure: failure));
      }
    }, (recommendations) {
      if (recommendations.isEmpty) {
        emit(RecommendationGetRecosNoRecosState());
      } else {
        emit(RecommendationGetRecosSuccessState(recoItems: recommendations));
      }
    });
  }

  void getUser() async {
    emit(RecommendationManagerLoadingState());
    final failureOrSuccess = await userRepo.getUser();
    failureOrSuccess.fold((failure) {
      if (!isClosed) {
        emit(RecommendationManagerGetUserFailureState(failure: failure));
      }
    }, (user) {
      if (!isClosed) {
        emit(RecommendationManagerGetUserSuccessState(user: user));
      }
    });
  }
}
