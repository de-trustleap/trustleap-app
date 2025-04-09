// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'promoter_state.dart';

class PromoterCubit extends Cubit<PromoterState> {
  final PromoterRepository recommendationsRepo;
  final UserRepository userRepo;
  final LandingPageRepository landingPagesRepo;

  PromoterCubit(this.recommendationsRepo, this.userRepo, this.landingPagesRepo)
      : super(PromoterInitial());

  void registerPromoter(UnregisteredPromoter? promoter) async {
    if (promoter == null) {
      emit(PromoterShowValidationState());
    } else if ((promoter.landingPageIDs != null &&
            promoter.landingPageIDs!.isEmpty) ||
        promoter.landingPageIDs == null) {
      emit(PromoterLandingPagesMissingState());
    } else if (promoter.companyID != null &&
        promoter.companyID!.value.isEmpty) {
      emit(PromoterCompanyMissingState());
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
    emit(PromoterLoadingState());
    final failureOrSuccess = await userRepo.getUser();
    failureOrSuccess.fold((failure) {
      if (!isClosed) {
        emit(PromoterGetCurrentUserFailureState(failure: failure));
      }
    }, (user) {
      if (!isClosed) {
        emit(PromoterGetCurrentUserSuccessState(user: user));
      }
    });
  }

  void getPromotingLandingPages(List<String> landingPageIDs) async {
    emit(PromoterLoadingState());
    if (landingPageIDs.isEmpty) {
      emit(PromoterNoLandingPagesState());
    } else {
      final failureOrSuccess =
          await landingPagesRepo.getAllLandingPages(landingPageIDs);
      failureOrSuccess.fold(
          (failure) =>
              emit(PromoterGetLandingPagesFailureState(failure: failure)),
          (landingPages) {
        emit(PromoterGetLandingPagesSuccessState(landingPages: landingPages));
      });
    }
  }

  void deletePromoter(String id) async {
    emit(PromoterLoadingState());
    final failureOrSuccess = await recommendationsRepo.deletePromoter(id: id);
    failureOrSuccess.fold(
        (failure) => emit(PromoterDeleteFailureState(failure: failure)), (_) {
      emit(PromoterDeleteSuccessState());
    });
  }
}

// TODO: EMPTY PAGE FÜR EDIT PROMOTER WENN ES KEINE ID GIBT ODER DIESE FALSCH IST (PROMOTER GIBT ES NICHT ANZEIGEN OHNE RELOAD BUTTON) 
// TODO: LEADITEM TEST