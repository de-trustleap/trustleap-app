import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';

class ArchivedRecommendationDetailArgs {
  final ArchivedRecommendationItem recommendation;
  final bool isPromoter;
  final bool isCampaign;

  const ArchivedRecommendationDetailArgs({
    required this.recommendation,
    required this.isPromoter,
    required this.isCampaign,
  });
}
