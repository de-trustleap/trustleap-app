// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class DashboardRankedLandingpage extends Equatable {
  final String landingPageName;
  final int rank;
  final int completedRecommendationsCount;
  const DashboardRankedLandingpage({
    required this.landingPageName,
    required this.rank,
    required this.completedRecommendationsCount,
  });

  @override
  List<Object?> get props =>
      [landingPageName, rank, completedRecommendationsCount];
}
