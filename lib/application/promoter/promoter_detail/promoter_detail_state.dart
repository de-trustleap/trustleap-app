part of 'promoter_detail_cubit.dart';

sealed class PromoterDetailState {}

final class PromoterDetailInitial extends PromoterDetailState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class PromoterDetailLoading extends PromoterDetailState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class PromoterDetailSuccess extends PromoterDetailState
    with EquatableMixin {
  final Promoter promoter;
  final List<LandingPage> landingPages;

  PromoterDetailSuccess({
    required this.promoter,
    required this.landingPages,
  });

  @override
  List<Object> get props => [promoter, landingPages];
}

final class PromoterDetailFailure extends PromoterDetailState
    with EquatableMixin {
  final DatabaseFailure failure;

  PromoterDetailFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class PromoterDetailRecommendationsLoading extends PromoterDetailState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class PromoterDetailRecommendationsSuccess extends PromoterDetailState
    with EquatableMixin {
  final List<UserRecommendation> recommendations;
  final List<PromoterRecommendations>? promoterRecommendations;
  final List<LandingPage>? allLandingPages;

  PromoterDetailRecommendationsSuccess({
    required this.recommendations,
    this.promoterRecommendations,
    this.allLandingPages,
  });

  @override
  List<Object?> get props =>
      [recommendations, promoterRecommendations, allLandingPages];
}

final class PromoterDetailRecommendationsFailure extends PromoterDetailState
    with EquatableMixin {
  final DatabaseFailure failure;

  PromoterDetailRecommendationsFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}

