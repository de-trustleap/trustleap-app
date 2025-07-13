import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/repositories/dashboard_repository.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';

part 'dashboard_recommendations_state.dart';

class DashboardRecommendationsCubit
    extends Cubit<DashboardRecommendationsState> {
  final DashboardRepository dashboardRepo;
  final RecommendationRepository recommendationRepo;
  DashboardRecommendationsCubit(this.dashboardRepo, this.recommendationRepo)
      : super(DashboardRecommendationsInitial());

  void getRecommendationsCompany() {}

  void getRecommendationsPromoter(String userID) async {
    emit(DashboardRecommendationsGetRecosLoadingState());
    final failureOrSuccess =
        await recommendationRepo.getRecommendations(userID);
    failureOrSuccess.fold(
        (failure) => emit(
            DashboardRecommendationsGetRecosFailureState(failure: failure)),
        (recommendations) => emit(DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations)));
  }
}

// TODO: TESTEN OB PROMOTER RECOS FÜR COMPANY USER IN RECOMMENDATION MANAGER GEZEIGT WIRD (ES WERDEN NUR DIE EIGENEN ANGEZEIGT) (FERTIG)
// TODO: COMPANY CALL FÜR RECOMMENDATIONS IN RECO REPOSITORY (FERTIG)
// TODO: GRAPH IMPLEMENTIEREN (FERTIG)
// TODO: DROPDOWN FÜR TAG, WOCHE, MONAT (FERTIG)
// TODO: DROPDOWN FÜR STATUS (FERTIG)
// TODO: CALL FÜR COMPANY NUTZEN UND ZWISCHEN COMPANY UND PROMOTER UNTERSCHEIDEN
