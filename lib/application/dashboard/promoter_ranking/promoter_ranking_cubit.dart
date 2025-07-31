import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/dashboard_ranked_promoter.dart';
import 'package:finanzbegleiter/domain/repositories/dashboard_repository.dart';

part 'promoter_ranking_state.dart';

class PromoterRankingCubit extends Cubit<PromoterRankingState> {
  final DashboardRepository dashboardRepo;
  PromoterRankingCubit(this.dashboardRepo) : super(PromoterRankingInitial());

  void getTop3Promoters(List<String> registeredPromoterIDs) async {
    if (registeredPromoterIDs.isEmpty) {
      emit(PromoterRankingGetTop3NoPromotersState());
    } else {
      emit(PromoterRankingGetTop3LoadingState());
      final failureOrSuccess =
          await dashboardRepo.getTop3Promoters(registeredPromoterIDs);
      failureOrSuccess.fold(
          (failure) =>
              emit(PromoterRankingGetTop3FailureState(failure: failure)),
          (promoters) =>
              emit(PromoterRankingGetTop3SuccessState(promoters: promoters)));
    }
  }
}
