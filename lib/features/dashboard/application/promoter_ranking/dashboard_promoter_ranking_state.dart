part of 'dashboard_promoter_ranking_cubit.dart';

sealed class PromoterRankingState {}

final class PromoterRankingInitial extends PromoterRankingState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterRankingGetTop3LoadingState extends PromoterRankingState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterRankingGetTop3NoPromotersState extends PromoterRankingState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterRankingGetTop3FailureState extends PromoterRankingState
    with EquatableMixin {
  final DatabaseFailure failure;
  PromoterRankingGetTop3FailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class PromoterRankingGetTop3SuccessState extends PromoterRankingState
    with EquatableMixin {
  final List<DashboardRankedPromoter> promoters;
  PromoterRankingGetTop3SuccessState({required this.promoters});
  @override
  List<Object?> get props => [promoters];
}
