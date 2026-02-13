import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';

part 'dashboard_recommendations_state.dart';

class DashboardRecommendationsCubit
    extends Cubit<DashboardRecommendationsState> {
  final RecommendationRepository recommendationRepo;
  final LandingPageRepository landingPageRepo;

  DashboardRecommendationsCubit(this.recommendationRepo, this.landingPageRepo)
      : super(DashboardRecommendationsInitial());

  void getRecommendationsCompany(String userID) async {
    emit(DashboardRecommendationsGetRecosLoadingState());

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsCompanyWithArchived(userID);
    failureOrSuccess.fold(
        (failure) => failure is NotFoundFailure
            ? emit(DashboardRecommendationsGetRecosNotFoundFailureState())
            : emit(
                DashboardRecommendationsGetRecosFailureState(failure: failure)),
        (promoterRecommendations) async {
      final allRecommendations = <UserRecommendation>[];
      for (final promoterRec in promoterRecommendations) {
        allRecommendations.addAll(promoterRec.recommendations);
      }

      final allLandingPageIds = <String>{};
      for (final promoterRec in promoterRecommendations) {
        if (promoterRec.promoter.landingPageIDs != null) {
          allLandingPageIds.addAll(promoterRec.promoter.landingPageIDs!);
        }
      }

      final allLandingPages =
          await _loadLandingPages(allLandingPageIds.toList());

      emit(DashboardRecommendationsGetRecosSuccessState(
        recommendation: allRecommendations,
        promoterRecommendations: promoterRecommendations,
        allLandingPages: allLandingPages,
        filteredLandingPages: allLandingPages,
      ));
    });
  }

  void getRecommendationsPromoter(
      String userID, List<String>? landingPageIDs) async {
    emit(DashboardRecommendationsGetRecosLoadingState());

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsWithArchived(userID);
    failureOrSuccess.fold(
        (failure) => failure is NotFoundFailure
            ? emit(DashboardRecommendationsGetRecosNotFoundFailureState())
            : emit(
                DashboardRecommendationsGetRecosFailureState(failure: failure)),
        (recommendations) async {
      final allLandingPages = await _loadLandingPages(landingPageIDs ?? []);

      emit(DashboardRecommendationsGetRecosSuccessState(
        recommendation: recommendations,
        allLandingPages: allLandingPages,
        filteredLandingPages: allLandingPages,
      ));
    });
  }

  void filterLandingPagesForPromoter(String? promoterId) {
    final currentState = state;
    if (currentState is DashboardRecommendationsGetRecosSuccessState) {
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
