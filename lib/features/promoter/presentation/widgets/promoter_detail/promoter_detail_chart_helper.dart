import 'package:fl_chart/fl_chart.dart';
import 'package:finanzbegleiter/features/recommendations/domain/campaign_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:intl/intl.dart';

class PromoterDetailChartHelper {
  final List<UserRecommendation> recommendations;
  final int selectedDays;
  final String locale;

  const PromoterDetailChartHelper({
    required this.recommendations,
    required this.selectedDays,
    this.locale = 'de',
  });

  List<UserRecommendation> get nonSuccessful => recommendations
      .where((rec) {
        final reco = rec.recommendation;
        if (reco is PersonalizedRecommendationItem) {
          return reco.statusLevel != StatusLevel.successful;
        }
        if (reco is CampaignRecommendationItem) {
          return (reco.statusCounts?.successful ?? 0) == 0;
        }
        return true;
      })
      .toList();

  List<UserRecommendation> get conversions => recommendations
      .where((rec) {
        final reco = rec.recommendation;
        if (reco is PersonalizedRecommendationItem) {
          return reco.statusLevel == StatusLevel.successful;
        }
        if (reco is CampaignRecommendationItem) {
          return (reco.statusCounts?.successful ?? 0) > 0;
        }
        return false;
      })
      .toList();

  bool get hasConversionsInTimeframe =>
      generateSpots(conversions).any((spot) => spot.y > 0);

  List<FlSpot> generateSpots(List<UserRecommendation> recs) {
    final now = DateTime.now();
    final spots = <FlSpot>[];

    for (int i = 0; i < selectedDays; i++) {
      final day = now.subtract(Duration(days: selectedDays - 1 - i));
      final dayKey = DateTime(day.year, day.month, day.day);

      int count = 0;
      for (final rec in recs) {
        final reco = rec.recommendation;
        DateTime? timestamp;
        if (reco is PersonalizedRecommendationItem) {
          timestamp = reco.statusTimestamps?[0];
        } else if (reco is CampaignRecommendationItem) {
          timestamp = reco.createdAt;
        }
        if (timestamp != null) {
          final recDay =
              DateTime(timestamp.year, timestamp.month, timestamp.day);
          if (recDay == dayKey) {
            count++;
          }
        }
      }

      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return spots;
  }

  double calculateMaxY(List<List<FlSpot>> spotSeries) {
    final allValues = spotSeries.expand((spots) => spots.map((s) => s.y));
    if (allValues.isEmpty) return 5.0;
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return (maxValue + (maxValue * 0.2)).clamp(5.0, double.infinity);
  }

  double get xAxisInterval {
    if (selectedDays <= 7) return 1;
    if (selectedDays <= 30) return 5;
    return 15;
  }

  double getYAxisInterval(double maxY) {
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    return 20;
  }

  String getXAxisLabel(int index) {
    final now = DateTime.now();
    final day = now.subtract(Duration(days: selectedDays - 1 - index));
    if (selectedDays <= 7) {
      return DateFormat('E', locale).format(day);
    }
    return DateFormat('dd.MM').format(day);
  }
}
