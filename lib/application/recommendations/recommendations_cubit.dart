// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/recommendations_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final RecommendationsRepository recommendationsRepo;
  final AuthRepository authRepo;

  RecommendationsCubit(this.recommendationsRepo, this.authRepo)
      : super(RecommendationsInitial());

  void registerPromoter(UnregisteredPromoter? promoter) async {
    if (promoter == null) {
      emit(RecommendationsShowValidationState());
    } else {
      emit(PromoterRegisterLoadingState());
      if (promoter.email == null) {
        emit(PromoterRegisterFailureState(failure: BackendFailure()));
      } else {
        final failureOrSuccess = await recommendationsRepo
            .checkIfPromoterAlreadyExists(email: promoter.email!);
        failureOrSuccess.fold(
            (failure) => emit(PromoterRegisterFailureState(failure: failure)),
            (emailExists) async {
          if (emailExists) {
            emit(PromoterAlreadyExistsFailureState());
          } else {
            final failureOrSuccessRegister =
                await recommendationsRepo.registerPromoter(promoter: promoter);
            failureOrSuccessRegister.fold(
                (failure) =>
                    emit(PromoterRegisterFailureState(failure: failure)),
                (r) => emit(PromoterRegisteredSuccessState()));
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
