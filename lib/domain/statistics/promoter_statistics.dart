import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/promoter_stats.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';

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

  List<Promoter> sortByConversions(List<Promoter> promoters) {
    final sorted = List<Promoter>.from(promoters);
    sorted.sort((a, b) {
      final statsA = getStatsForPromoter(a.id.value);
      final statsB = getStatsForPromoter(b.id.value);
      return statsB.conversions.compareTo(statsA.conversions);
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
            (rec) => rec.recommendation?.statusLevel == StatusLevel.successful)
        .length;

    return PromoterStats(shares: shares, conversions: conversions);
  }
}
