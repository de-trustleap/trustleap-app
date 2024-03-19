// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/registered_recommendor.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/recommendations_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final RecommendationsRepository recommendationsRepo;
  final AuthRepository authRepo;

  RecommendationsCubit(this.recommendationsRepo, this.authRepo)
      : super(RecommendationsInitial());

  void registerRecommendor(RegisteredRecommendor? recommendor) async {
    if (recommendor == null) {
      emit(RecommendationsShowValidationState());
    } else {
      emit(RecommendorRegisterLoadingState());
      if (recommendor.email == null) {
        emit(RecommendorRegisterFailureState(failure: BackendFailure()));
      } else {
        final failureOrSuccess = await recommendationsRepo
            .checkIfRecommendorAlreadyExists(email: recommendor.email!);
        failureOrSuccess.fold(
            (failure) =>
                emit(RecommendorRegisterFailureState(failure: failure)),
            (emailExists) async {
          if (emailExists) {
            emit(RecommendorAlreadyExistsFailureState());
          } else {
            final failureOrSuccessRegister = await recommendationsRepo
                .registerRecommendor(recommendor: recommendor);
            failureOrSuccessRegister.fold(
                (failure) =>
                    emit(RecommendorRegisterFailureState(failure: failure)),
                (r) => emit(RecommendorRegisteredSuccessState()));
          }
        });
      }
    }
  }

  void getCurrentUser() async {
    emit(RecommendationsGetCurrentUserLoadingState());
    final currentUser = await authRepo.getCurrentUser();
    emit(RecommendationsGetCurrentUserSuccessState(user: currentUser));
  }
}
