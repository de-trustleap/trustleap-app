part of 'landing_page_detail_cubit.dart';

sealed class LandingPageDetailState {}

final class LandingPageDetailInitial extends LandingPageDetailState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class LandingPageDetailRecommendationsLoading
    extends LandingPageDetailState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class LandingPageDetailRecommendationsSuccess
    extends LandingPageDetailState with EquatableMixin {
  final List<UserRecommendation> recommendations;
  final List<PromoterRecommendations>? promoterRecommendations;
  final List<LandingPage>? allLandingPages;

  LandingPageDetailRecommendationsSuccess({
    required this.recommendations,
    this.promoterRecommendations,
    this.allLandingPages,
  });

  @override
  List<Object?> get props =>
      [recommendations, promoterRecommendations, allLandingPages];
}

final class LandingPageDetailRecommendationsFailure
    extends LandingPageDetailState with EquatableMixin {
  final DatabaseFailure failure;

  LandingPageDetailRecommendationsFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class LandingPageDetailRecommendationsNotFound
    extends LandingPageDetailState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class LandingPageDetailPromotersLoading extends LandingPageDetailState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class LandingPageDetailPromotersSuccess extends LandingPageDetailState
    with EquatableMixin {
  final List<Promoter> promoters;

  LandingPageDetailPromotersSuccess({required this.promoters});

  @override
  List<Object> get props => [promoters];
}

final class LandingPageDetailPromotersFailure extends LandingPageDetailState
    with EquatableMixin {
  final DatabaseFailure failure;

  LandingPageDetailPromotersFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class LandingPageDetailAllPromotersLoading extends LandingPageDetailState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class LandingPageDetailAllPromotersSuccess extends LandingPageDetailState
    with EquatableMixin {
  final List<Promoter> promoters;

  LandingPageDetailAllPromotersSuccess({required this.promoters});

  @override
  List<Object> get props => [promoters];
}

final class LandingPageDetailAllPromotersFailure extends LandingPageDetailState
    with EquatableMixin {
  final DatabaseFailure failure;

  LandingPageDetailAllPromotersFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class LandingPageDetailArchivedLegalsLoading
    extends LandingPageDetailState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class LandingPageDetailArchivedLegalsSuccess
    extends LandingPageDetailState with EquatableMixin {
  final ArchivedLandingPageLegals archivedLegals;

  LandingPageDetailArchivedLegalsSuccess({required this.archivedLegals});

  @override
  List<Object> get props => [archivedLegals];
}

final class LandingPageDetailArchivedLegalsFailure
    extends LandingPageDetailState with EquatableMixin {
  final DatabaseFailure failure;

  LandingPageDetailArchivedLegalsFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
