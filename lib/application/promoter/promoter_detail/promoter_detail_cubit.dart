import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';

part 'promoter_detail_state.dart';

class PromoterDetailCubit extends Cubit<PromoterDetailState> {
  final PromoterRepository promoterRepo;
  final RecommendationRepository recommendationRepo;
  final LandingPageRepository landingPageRepo;

  PromoterDetailCubit(
      this.promoterRepo, this.recommendationRepo, this.landingPageRepo)
      : super(PromoterDetailInitial());

  void loadPromoterWithLandingPages(String promoterId) async {
    emit(PromoterDetailLoading());

    final failureOrSuccess = await promoterRepo.getPromoter(promoterId);
    failureOrSuccess.fold(
      (failure) => emit(PromoterDetailFailure(failure: failure)),
      (promoter) async {
        final landingPageIDs = promoter.landingPageIDs;
        if (landingPageIDs == null || landingPageIDs.isEmpty) {
          emit(PromoterDetailSuccess(promoter: promoter, landingPages: []));
          return;
        }

        final lpResult = await promoterRepo.getLandingPages(landingPageIDs);
        lpResult.fold(
          (failure) =>
              emit(PromoterDetailSuccess(promoter: promoter, landingPages: [])),
          (landingPages) => emit(PromoterDetailSuccess(
              promoter: promoter, landingPages: landingPages)),
        );
      },
    );
  }

  void loadRecommendations({
    required String userId,
    required Role role,
    List<String>? landingPageIds,
  }) {
    if (role == Role.company) {
      _loadRecommendationsCompany(userId);
    } else {
      _loadRecommendationsPromoter(userId, landingPageIds);
    }
  }

  void _loadRecommendationsCompany(String userId) async {
    emit(PromoterDetailRecommendationsLoading());

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsCompanyWithArchived(userId);
    failureOrSuccess.fold(
      (failure) =>
          emit(PromoterDetailRecommendationsFailure(failure: failure)),
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

        emit(PromoterDetailRecommendationsSuccess(
          recommendations: allRecommendations,
          promoterRecommendations: promoterRecommendations,
          allLandingPages: allLandingPages,
        ));
      },
    );
  }

  void _loadRecommendationsPromoter(
      String userId, List<String>? landingPageIds) async {
    emit(PromoterDetailRecommendationsLoading());

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsWithArchived(userId);
    failureOrSuccess.fold(
      (failure) =>
          emit(PromoterDetailRecommendationsFailure(failure: failure)),
      (recommendations) async {
        final allLandingPages =
            await _loadLandingPages(landingPageIds ?? []);

        emit(PromoterDetailRecommendationsSuccess(
          recommendations: recommendations,
          allLandingPages: allLandingPages,
        ));
      },
    );
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
