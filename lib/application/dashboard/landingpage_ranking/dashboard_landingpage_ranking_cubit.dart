import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/dashboard_ranked_landingpage.dart';
import 'package:finanzbegleiter/domain/repositories/dashboard_repository.dart';

part 'dashboard_landingpage_ranking_state.dart';

class DashboardLandingpageRankingCubit
    extends Cubit<DashboardLandingpageRankingState> {
  final DashboardRepository dashboardRepo;
  DashboardLandingpageRankingCubit(this.dashboardRepo)
      : super(DashboardLandingpageRankingInitial());

  void getTop3LandingPages(
      List<String> landingPageIDs, TimePeriod? timePeriod) async {
    if (landingPageIDs.isEmpty) {
      emit(DashboardLandingPageRankingGetTop3NoPagesState());
    } else {
      emit(DashboardLandingPageRankingGetTop3LoadingState());
      final failureOrSuccess = await dashboardRepo
          .getTop3LandingPages(landingPageIDs, timePeriod: timePeriod);
      failureOrSuccess.fold(
          (failure) => emit(
              DashboardLandingPageRankingGetTop3FailureState(failure: failure)),
          (landingPages) => emit(DashboardLandingPageRankingGetTop3SuccessState(
              landingPages: landingPages)));
    }
  }
}
