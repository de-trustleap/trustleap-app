// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'promoter_state.dart';

class PromoterCubit extends Cubit<PromoterState> {
  final PromoterRepository recommendationsRepo;
  final AuthRepository authRepo;

  PromoterCubit(this.recommendationsRepo, this.authRepo)
      : super(PromoterInitial());

  void registerPromoter(UnregisteredPromoter? promoter) async {
    if (promoter == null) {
      emit(PromoterShowValidationState());
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
    emit(PromoterGetCurrentUserLoadingState());
    final currentUser = await authRepo.getCurrentUser();
    emit(PromoterGetCurrentUserSuccessState(user: currentUser));
  }
}
