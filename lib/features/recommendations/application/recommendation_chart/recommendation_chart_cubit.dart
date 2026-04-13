import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';

part 'recommendation_chart_state.dart';

class RecommendationChartCubit extends Cubit<RecommendationChartState> {
  final RecommendationRepository recommendationRepo;
  final LandingPageRepository landingPageRepo;

  RecommendationChartCubit(this.recommendationRepo, this.landingPageRepo)
      : super(RecommendationChartInitial());

  void getRecommendationsCompany(String userID) async {
    emit(RecommendationChartLoadingState());

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsCompanyWithArchived(userID);
    failureOrSuccess.fold(
        (failure) => failure is NotFoundFailure
            ? emit(RecommendationChartNotFoundState())
            : emit(RecommendationChartFailureState(failure: failure)),
        (result) async {
      final allLandingPageIds = <String>{};
      for (final promoterRec in result.promoterRecommendations) {
        if (promoterRec.promoter.landingPageIDs != null) {
          allLandingPageIds.addAll(promoterRec.promoter.landingPageIDs!);
        }
      }

      final allLandingPages =
          await _loadLandingPages(allLandingPageIds.toList());

      emit(RecommendationChartSuccessState(
        recommendation: result.allRecommendations,
        promoterRecommendations: result.promoterRecommendations,
        allLandingPages: allLandingPages,
        filteredLandingPages: allLandingPages,
      ));
    });
  }

  void getRecommendationsPromoter(
      String userID, List<String>? landingPageIDs) async {
    emit(RecommendationChartLoadingState());

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsWithArchived(userID);
    failureOrSuccess.fold(
        (failure) => failure is NotFoundFailure
            ? emit(RecommendationChartNotFoundState())
            : emit(RecommendationChartFailureState(failure: failure)),
        (recommendations) async {
      final allLandingPages = await _loadLandingPages(landingPageIDs ?? []);

      emit(RecommendationChartSuccessState(
        recommendation: recommendations,
        allLandingPages: allLandingPages,
        filteredLandingPages: allLandingPages,
      ));
    });
  }

  void filterLandingPagesForPromoter(String? promoterId) {
    final currentState = state;
    if (currentState is RecommendationChartSuccessState) {
      if (promoterId == null) {
        emit(currentState.copyWith(
            filteredLandingPages: currentState.allLandingPages));
        return;
      }

      if (currentState.promoterRecommendations != null &&
          currentState.allLandingPages != null) {
        final selectedPromoter = currentState.promoterRecommendations!
            .firstWhere(
                (promoterRec) => promoterRec.promoter.id.value == promoterId)
            .promoter;

        if (selectedPromoter.landingPageIDs != null &&
            selectedPromoter.landingPageIDs!.isNotEmpty) {
          final filteredPages = currentState.allLandingPages!
              .where((landingPage) => selectedPromoter.landingPageIDs!
                  .contains(landingPage.id.value))
              .toList();

          emit(currentState.copyWith(filteredLandingPages: filteredPages));
        } else {
          emit(currentState.copyWith(filteredLandingPages: []));
        }
      }
    }
  }

  Future<List<LandingPage>?> _loadLandingPages(
      List<String> landingPageIds) async {
    if (landingPageIds.isEmpty) return null;

    final result = await landingPageRepo.getAllLandingPages(landingPageIds);
    return result.fold(
      (failure) => null,
      (landingPages) => landingPages,
    );
  }
}
