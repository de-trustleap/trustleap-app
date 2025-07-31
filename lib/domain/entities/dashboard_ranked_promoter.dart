// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class DashboardRankedPromoter extends Equatable {
  final String promoterName;
  final int rank;
  final int completedRecommendationsCount;

  const DashboardRankedPromoter({
    required this.promoterName,
    required this.rank,
    required this.completedRecommendationsCount,
  });

  @override
  List<Object?> get props => [promoterName, rank, completedRecommendationsCount];
}
