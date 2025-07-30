import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/mock_data/dashboard_promoters_mock_data.dart';

part 'dashboard_promoters_state.dart';

class DashboardPromotersCubit extends Cubit<DashboardPromotersState> {
  final PromoterRepository promoterRepo;
  DashboardPromotersCubit(this.promoterRepo)
      : super(DashboardPromotersInitial());

  void getRegisteredPromoters(CustomUser user) async {
    emit(DashboardPromotersGetRegisteredPromotersLoadingState());
    
    /* TODO: Uncomment for testing trend functionality
    // For testing purposes, return mock data
    final mockPromoters = DashboardPromotersMockData.getMockPromoters();
    emit(DashboardPromotersGetRegisteredPromotersSuccessState(
        promoters: mockPromoters));
    */
    
    // Original implementation:
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
