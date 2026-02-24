import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/legals/domain/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';

part 'landing_page_detail_state.dart';

class LandingPageDetailCubit extends Cubit<LandingPageDetailState> {
  final RecommendationRepository recommendationRepo;
  final LandingPageRepository landingPageRepo;

  LandingPageDetailCubit(this.recommendationRepo, this.landingPageRepo)
      : super(LandingPageDetailInitial());

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
    emit(LandingPageDetailRecommendationsLoading());

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsCompanyWithArchived(userId);
    failureOrSuccess.fold(
      (failure) => failure is NotFoundFailure
          ? emit(LandingPageDetailRecommendationsNotFound())
          : emit(LandingPageDetailRecommendationsFailure(failure: failure)),
      (result) async {
        final allLandingPageIds = <String>{};
        for (final promoterRec in result.promoterRecommendations) {
          if (promoterRec.promoter.landingPageIDs != null) {
            allLandingPageIds.addAll(promoterRec.promoter.landingPageIDs!);
          }
        }

        final allLandingPages =
            await _loadLandingPages(allLandingPageIds.toList());

        emit(LandingPageDetailRecommendationsSuccess(
          recommendations: result.allRecommendations,
          promoterRecommendations: result.promoterRecommendations,
          allLandingPages: allLandingPages,
        ));
      },
    );
  }

  void _loadRecommendationsPromoter(
      String userId, List<String>? landingPageIds) async {
    emit(LandingPageDetailRecommendationsLoading());

    final failureOrSuccess =
        await recommendationRepo.getRecommendationsWithArchived(userId);
    failureOrSuccess.fold(
      (failure) => failure is NotFoundFailure
          ? emit(LandingPageDetailRecommendationsNotFound())
          : emit(LandingPageDetailRecommendationsFailure(failure: failure)),
      (recommendations) async {
        final allLandingPages = await _loadLandingPages(landingPageIds ?? []);

        emit(LandingPageDetailRecommendationsSuccess(
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

  void getAssignedPromoters(List<String>? associatedUsersIDs) async {
    emit(LandingPageDetailPromotersLoading());
    List<Promoter> promoters = [];
    if (associatedUsersIDs == null || associatedUsersIDs.isEmpty) {
      emit(LandingPageDetailPromotersSuccess(promoters: promoters));
    } else {
      final failureOrSuccess =
          await landingPageRepo.getUnregisteredPromoters(associatedUsersIDs);
      failureOrSuccess.fold((failure) {
        emit(LandingPageDetailPromotersFailure(failure: failure));
      }, (unregisteredPromoters) async {
        promoters.addAll(unregisteredPromoters);
        final failureOrSuccessRegistered =
            await landingPageRepo.getRegisteredPromoters(associatedUsersIDs);
        failureOrSuccessRegistered.fold((failure) {
          emit(LandingPageDetailPromotersFailure(failure: failure));
        }, (registeredPromoters) {
          promoters.addAll(registeredPromoters);
          emit(LandingPageDetailPromotersSuccess(promoters: promoters));
        });
      });
    }
  }

  void getAllPromotersForUser(CustomUser user) async {
    emit(LandingPageDetailAllPromotersLoading());
    List<Promoter> promoters = [];
    final registeredIds = user.registeredPromoterIDs ?? [];
    final unregisteredIds = user.unregisteredPromoterIDs ?? [];

    if (registeredIds.isEmpty && unregisteredIds.isEmpty) {
      emit(LandingPageDetailAllPromotersSuccess(promoters: promoters));
      return;
    }

    if (unregisteredIds.isNotEmpty) {
      final failureOrSuccess =
          await landingPageRepo.getUnregisteredPromoters(unregisteredIds);
      if (failureOrSuccess.isLeft()) {
        emit(LandingPageDetailAllPromotersFailure(
            failure: failureOrSuccess.fold((f) => f, (_) => throw Error())));
        return;
      }
      promoters.addAll(failureOrSuccess.getOrElse(() => []));
    }

    if (registeredIds.isNotEmpty) {
      final failureOrSuccess =
          await landingPageRepo.getRegisteredPromoters(registeredIds);
      if (failureOrSuccess.isLeft()) {
        emit(LandingPageDetailAllPromotersFailure(
            failure: failureOrSuccess.fold((f) => f, (_) => throw Error())));
        return;
      }
      promoters.addAll(failureOrSuccess.getOrElse(() => []));
    }

    emit(LandingPageDetailAllPromotersSuccess(promoters: promoters));
  }

  void getArchivedLandingPageLegals(String landingPageId) async {
    emit(LandingPageDetailArchivedLegalsLoading());
    final failureOrSuccess =
        await landingPageRepo.getArchivedLandingPageLegals(landingPageId);
    failureOrSuccess.fold(
      (failure) =>
          emit(LandingPageDetailArchivedLegalsFailure(failure: failure)),
      (legals) =>
          emit(LandingPageDetailArchivedLegalsSuccess(archivedLegals: legals)),
    );
  }
}
