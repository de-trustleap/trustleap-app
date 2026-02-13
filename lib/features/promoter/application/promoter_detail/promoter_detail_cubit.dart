import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';

part 'promoter_detail_state.dart';

class PromoterDetailCubit extends Cubit<PromoterDetailState> {
  final PromoterRepository promoterRepo;
  final RecommendationRepository recommendationRepo;

  PromoterDetailCubit(this.promoterRepo, this.recommendationRepo)
      : super(PromoterDetailInitial());

  void loadPromoterWithLandingPages(String promoterId) async {
    emit(PromoterDetailLoading());

    final failureOrSuccess = await promoterRepo.getPromoter(promoterId);
    failureOrSuccess.fold(
      (failure) => emit(PromoterDetailFailure(failure: failure)),
      (promoter) async {
        final landingPageIDs = promoter.landingPageIDs;
        if (landingPageIDs == null || landingPageIDs.isEmpty) {
          emit(PromoterDetailLoaded(promoter: promoter, landingPages: []));
          return;
        }

        final lpResult = await promoterRepo.getLandingPages(landingPageIDs);
        lpResult.fold(
          (failure) =>
              emit(PromoterDetailLoaded(promoter: promoter, landingPages: [])),
          (landingPages) => emit(PromoterDetailLoaded(
              promoter: promoter, landingPages: landingPages)),
        );
      },
    );
  }

  void loadRecommendations({
    required String userId,
    required Role role,
  }) {
    if (state is! PromoterDetailLoaded) return;

    if (role == Role.company) {
      _loadRecommendationsCompany(userId);
    } else {
      _loadRecommendationsPromoter(userId);
    }
  }

  void _loadRecommendationsCompany(String userId) async {
    final currentState = state;
    if (currentState is! PromoterDetailLoaded) return;

    emit(PromoterDetailLoaded(
      promoter: currentState.promoter,
      landingPages: currentState.landingPages,
      isRecommendationsLoading: true,
    ));

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsCompanyWithArchived(userId);
    final loadedState = state;
    if (loadedState is! PromoterDetailLoaded) return;

    failureOrSuccess.fold(
      (failure) => emit(PromoterDetailLoaded(
        promoter: loadedState.promoter,
        landingPages: loadedState.landingPages,
        recommendationsFailure: failure,
      )),
      (promoterRecommendations) {
        final promoterRec = promoterRecommendations
            .where(
                (pr) => pr.promoter.id.value == loadedState.promoter.id.value)
            .firstOrNull;
        final filteredRecommendations = promoterRec?.recommendations ?? [];

        emit(PromoterDetailLoaded(
          promoter: loadedState.promoter,
          landingPages: loadedState.landingPages,
          recommendations: filteredRecommendations,
          promoterRecommendations: promoterRecommendations,
        ));
      },
    );
  }

  void _loadRecommendationsPromoter(String userId) async {
    final currentState = state;
    if (currentState is! PromoterDetailLoaded) return;

    emit(PromoterDetailLoaded(
      promoter: currentState.promoter,
      landingPages: currentState.landingPages,
      isRecommendationsLoading: true,
    ));

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsWithArchived(userId);
    final loadedState = state;
    if (loadedState is! PromoterDetailLoaded) return;

    failureOrSuccess.fold(
      (failure) => emit(PromoterDetailLoaded(
        promoter: loadedState.promoter,
        landingPages: loadedState.landingPages,
        recommendationsFailure: failure,
      )),
      (recommendations) => emit(PromoterDetailLoaded(
        promoter: loadedState.promoter,
        landingPages: loadedState.landingPages,
        recommendations: recommendations,
      )),
    );
  }
}
