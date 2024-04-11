import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final UserRepository userRepo;
  RecommendationsCubit(this.userRepo) : super(RecommendationsInitial());

  void getUser() async {
    emit(RecommendationGetUserLoadingState());
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
    emit(RecommendationGetUserLoadingState());
    print("LOADING!");
    final failureOrSuccess = await userRepo.getParentUser(parentID: parentID);
    failureOrSuccess.fold((failure) {
      if (!isClosed) {
        print("FAILURE!");
        emit(RecommendationGetUserFailureState(failure: failure));
      }
    }, (user) {
      if (!isClosed) {
        print("SUCCESS!");
        emit(RecommendationGetParentUserSuccessState(user: user));
      }
    });
  }
}
