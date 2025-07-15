import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
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

  void getRecommendationsCompany(String userID) async {
    emit(DashboardRecommendationsGetRecosLoadingState());
    final failureOrSuccess =
        await recommendationRepo.getRecommendationsCompany(userID);
    failureOrSuccess.fold(
        (failure) => failure is NotFoundFailure
            ? emit(DashboardRecommendationsGetRecosNotFoundFailureState())
            : emit(
                DashboardRecommendationsGetRecosFailureState(failure: failure)),
        (promoterRecommendations) {
      final allRecommendations = <UserRecommendation>[];
      for (final promoterRec in promoterRecommendations) {
        allRecommendations.addAll(promoterRec.recommendations);
      }
      emit(DashboardRecommendationsGetRecosSuccessState(
        recommendation: allRecommendations,
        promoterRecommendations: promoterRecommendations,
      ));
    });
  }

  void getRecommendationsPromoter(String userID) async {
    emit(DashboardRecommendationsGetRecosLoadingState());
    final failureOrSuccess =
        await recommendationRepo.getRecommendations(userID);
    failureOrSuccess.fold(
        (failure) => failure is NotFoundFailure
            ? emit(DashboardRecommendationsGetRecosNotFoundFailureState())
            : emit(
                DashboardRecommendationsGetRecosFailureState(failure: failure)),
        (recommendations) => emit(DashboardRecommendationsGetRecosSuccessState(
            recommendation: recommendations)));
  }
}

// TODO: Localizations
