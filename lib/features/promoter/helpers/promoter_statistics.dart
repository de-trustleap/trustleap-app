import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_stats.dart';
import 'package:finanzbegleiter/features/recommendations/domain/campaign_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';

class PromoterStatistics {
  final List<PromoterRecommendations> promoterRecommendations;
  final String? landingPageName;

  const PromoterStatistics({
    required this.promoterRecommendations,
    this.landingPageName,
  });

  PromoterStats getStatsForPromoter(String promoterId) {
    final promoterRec = promoterRecommendations
        .where((pr) => pr.promoter.id.value == promoterId)
        .firstOrNull;

    if (promoterRec == null) {
      return const PromoterStats(shares: 0, conversions: 0);
    }

    return _calculateStats(
      _filterByLandingPage(promoterRec.recommendations),
    );
  }

  PromoterStats getStatsForLandingPage(
    List<UserRecommendation> recommendations,
    String? landingPageName,
  ) {
    final filtered = recommendations
        .where((rec) => rec.recommendation?.reason == landingPageName)
        .toList();
    return _calculateStats(filtered);
  }

  List<Promoter> sortByConversions(List<Promoter> promoters) {
    final sorted = List<Promoter>.from(promoters);
    sorted.sort((a, b) {
      final statsA = getStatsForPromoter(a.id.value);
      final statsB = getStatsForPromoter(b.id.value);
      final cmp = statsB.conversions.compareTo(statsA.conversions);
      if (cmp != 0) return cmp;
      return statsB.performance.compareTo(statsA.performance);
    });
    return sorted;
  }

  List<UserRecommendation> _filterByLandingPage(
    List<UserRecommendation> recommendations,
  ) {
    if (landingPageName == null) return recommendations;
    return recommendations
        .where((rec) => rec.recommendation?.reason == landingPageName)
        .toList();
  }

  PromoterStats _calculateStats(List<UserRecommendation> recommendations) {
    final shares = recommendations.length;
    final conversions = recommendations
        .where(
            (rec) {
              final reco = rec.recommendation;
              if (reco is PersonalizedRecommendationItem) {
                return reco.statusLevel == StatusLevel.successful;
              }
              if (reco is CampaignRecommendationItem) {
                return (reco.statusCounts?.successful ?? 0) > 0;
              }
              return false;
            })
        .length;

    return PromoterStats(shares: shares, conversions: conversions);
  }
}
