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

final class PromoterDetailLoaded extends PromoterDetailState
    with EquatableMixin {
  final Promoter promoter;
  final List<LandingPage> landingPages;
  final List<UserRecommendation>? recommendations;
  final List<PromoterRecommendations>? promoterRecommendations;
  final bool isRecommendationsLoading;
  final DatabaseFailure? recommendationsFailure;

  PromoterDetailLoaded({
    required this.promoter,
    required this.landingPages,
    this.recommendations,
    this.promoterRecommendations,
    this.isRecommendationsLoading = false,
    this.recommendationsFailure,
  });

  @override
  List<Object?> get props => [
        promoter,
        landingPages,
        recommendations,
        promoterRecommendations,
        isRecommendationsLoading,
        recommendationsFailure,
      ];
}

final class PromoterDetailFailure extends PromoterDetailState
    with EquatableMixin {
  final DatabaseFailure failure;

  PromoterDetailFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
