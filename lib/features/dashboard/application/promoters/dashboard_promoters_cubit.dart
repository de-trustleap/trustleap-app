import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_repository.dart';

part 'dashboard_promoters_state.dart';

class DashboardPromotersCubit extends Cubit<DashboardPromotersState> {
  final PromoterRepository promoterRepo;
  DashboardPromotersCubit(this.promoterRepo)
      : super(DashboardPromotersInitial());

  void getRegisteredPromoters(CustomUser user) async {
    emit(DashboardPromotersGetRegisteredPromotersLoadingState());

    if (user.registeredPromoterIDs == null ||
        user.registeredPromoterIDs!.isEmpty) {
      emit(DashboardPromotersGetRegisteredPromotersEmptyState());
    } else {
      final failureOrSuccess = await promoterRepo
          .getRegisteredPromoters(user.registeredPromoterIDs!);
      failureOrSuccess.fold(
          (failure) => emit(
              DashboardPromotersGetRegisteredPromotersFailureState(
                  failure: failure)),
          (promoters) => emit(
              DashboardPromotersGetRegisteredPromotersSuccessState(
                  promoters: promoters)));
    }
  }
}
