import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:flutter/widgets.dart';

class RecommendationDetailArgs {
  final UserRecommendation recommendation;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation, bool, bool, bool, bool) onUpdate;
  final List<Widget> Function(UserRecommendation, bool isLoading) buildContent;
  final List<Widget> Function(UserRecommendation)? buildBottomRowTrailing;

  const RecommendationDetailArgs({
    required this.recommendation,
    required this.onFavoritePressed,
    required this.onUpdate,
    required this.buildContent,
    this.buildBottomRowTrailing,
  });
}
