// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'promoter_state.dart';

class PromoterCubit extends Cubit<PromoterState> {
  final PromoterRepository promoterRepo;
  final UserRepository userRepo;
  final LandingPageRepository landingPagesRepo;

  PromoterCubit(this.promoterRepo, this.userRepo, this.landingPagesRepo)
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
        final failureOrSuccess = await promoterRepo
            .checkIfPromoterAlreadyExists(email: promoter.email!);
        failureOrSuccess.fold(
            (failure) => emit(PromoterRegisterFailureState(failure: failure)),
            (emailExists) async {
          if (emailExists) {
            emit(PromoterAlreadyExistsFailureState());
          } else {
            final failureOrSuccessRegister =
                await promoterRepo.registerPromoter(promoter: promoter);
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
    final failureOrSuccess = await promoterRepo.deletePromoter(id: id);
    failureOrSuccess.fold(
        (failure) => emit(PromoterDeleteFailureState(failure: failure)), (_) {
      emit(PromoterDeleteSuccessState());
    });
  }

  void editPromoter(
      bool isRegistered, List<String> landingPageIDs, String promoterID) async {
    emit(PromoterLoadingState());
    final failureOrSuccess = await promoterRepo.editPromoter(
        isRegistered: isRegistered,
        landingPageIDs: landingPageIDs,
        promoterID: promoterID);
    failureOrSuccess.fold(
        (failure) => emit(PromoterEditFailureState(failure: failure)), (_) {
      emit(PromoterEditSuccessState());
    });
  }

  void getPromoter(String id, CustomUser? user, Permissions permission) async {
    emit(PromoterLoadingState());
    if (user == null || !permission.hasEditPromoterPermission()) {
      emit(PromoterGetFailureState(failure: PermissionDeniedFailure()));
      return;
    }
    final isInRegistered = user.registeredPromoterIDs?.contains(id) ?? false;
    final isInUnregistered =
        user.unregisteredPromoterIDs?.contains(id) ?? false;

    if (!isInRegistered && !isInUnregistered) {
      emit(PromoterGetFailureState(failure: NotFoundFailure()));
      return;
    }
    final failureOrSuccess = await promoterRepo.getPromoter(id);
    failureOrSuccess.fold(
        (failure) => emit(PromoterGetFailureState(failure: failure)),
        (promoter) => emit(PromoterGetSuccessState(promoter: promoter)));
  }
}
