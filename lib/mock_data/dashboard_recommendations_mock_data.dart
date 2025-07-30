import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';

class DashboardRecommendationsMockData {
  static List<UserRecommendation> getMockRecommendations() {
    final now = DateTime.now();
    final recommendations = <UserRecommendation>[];

    // Letzter Monat (50 Recommendations): 60-31 Tage her
    for (int i = 0; i < 50; i++) {
      final daysAgo = 60 - i; // Verteilt über den letzten Monat
      final statusLevel = _getRandomStatusLevel(i);

      recommendations.add(UserRecommendation(
        id: UniqueID.fromUniqueString('mock-reco-lastmonth-$i'),
        recoID: 'reco-lastmonth-$i',
        userID: 'user-$i',
        priority: _getRandomPriority(i),
        notes: 'Mock recommendation $i from last month',
        recommendation: RecommendationItem(
          id: 'reco-item-lastmonth-$i',
          name: 'Versicherung ${i + 1}',
          reason: 'Optimierung für Kunde ${i + 1}',
          landingPageID: 'landing-$i',
          promotionTemplate: 'template-$i',
          promoterName: 'Promoter ${i % 10 + 1}',
          serviceProviderName: 'Anbieter ${i % 5 + 1}',
          defaultLandingPageID: 'default-landing-$i',
          statusLevel: statusLevel,
          statusTimestamps: _getStatusTimestamps(
              statusLevel, now.subtract(Duration(days: daysAgo))),
          userID: 'user-$i',
          promoterImageDownloadURL: null,
          createdAt: now.subtract(Duration(days: daysAgo)),
          expiresAt: now.add(const Duration(days: 14)),
        ),
      ));
    }

    // Dieser Monat (30 Recommendations): 30-1 Tage her
    for (int i = 0; i < 30; i++) {
      final daysAgo = 30 - i; // Verteilt über diesen Monat
      final statusLevel = _getRandomStatusLevel(i + 50);

      recommendations.add(UserRecommendation(
        id: UniqueID.fromUniqueString('mock-reco-thismonth-$i'),
        recoID: 'reco-thismonth-$i',
        userID: 'user-${i + 50}',
        priority: _getRandomPriority(i + 50),
        notes: 'Mock recommendation $i from this month',
        recommendation: RecommendationItem(
          id: 'reco-item-thismonth-$i',
          name: 'Finanzprodukt ${i + 1}',
          reason: 'Beratung für Kunde ${i + 1}',
          landingPageID: 'landing-${i + 50}',
          promotionTemplate: 'template-${i + 50}',
          promoterName: 'Promoter ${(i + 50) % 10 + 1}',
          serviceProviderName: 'Anbieter ${(i + 50) % 5 + 1}',
          defaultLandingPageID: 'default-landing-${i + 50}',
          statusLevel: statusLevel,
          statusTimestamps: _getStatusTimestamps(
              statusLevel, now.subtract(Duration(days: daysAgo))),
          userID: 'user-${i + 50}',
          promoterImageDownloadURL: null,
          createdAt: now.subtract(Duration(days: daysAgo)),
          expiresAt: now.add(const Duration(days: 14)),
        ),
      ));
    }

    return recommendations;
  }

  static StatusLevel _getRandomStatusLevel(int index) {
    // Mix verschiedener Status für realistische Daten
    switch (index % 6) {
      case 0:
        return StatusLevel.recommendationSend;
      case 1:
        return StatusLevel.linkClicked;
      case 2:
        return StatusLevel.contactFormSent;
      case 3:
        return StatusLevel.appointment;
      case 4:
        return StatusLevel.successful;
      case 5:
        return StatusLevel.failed;
      default:
        return StatusLevel.recommendationSend;
    }
  }

  static RecommendationPriority _getRandomPriority(int index) {
    switch (index % 3) {
      case 0:
        return RecommendationPriority.low;
      case 1:
        return RecommendationPriority.medium;
      case 2:
        return RecommendationPriority.high;
      default:
        return RecommendationPriority.medium;
    }
  }

  static Map<int, DateTime?> _getStatusTimestamps(
      StatusLevel statusLevel, DateTime createdAt) {
    final timestamps = <int, DateTime?>{};

    // Füge Timestamps basierend auf dem Status hinzu
    switch (statusLevel) {
      case StatusLevel.recommendationSend:
        timestamps[0] = createdAt;
        break;
      case StatusLevel.linkClicked:
        timestamps[0] = createdAt;
        timestamps[1] = createdAt.add(const Duration(hours: 2));
        break;
      case StatusLevel.contactFormSent:
        timestamps[0] = createdAt;
        timestamps[1] = createdAt.add(const Duration(hours: 2));
        timestamps[2] = createdAt.add(const Duration(hours: 6));
        break;
      case StatusLevel.appointment:
        timestamps[0] = createdAt;
        timestamps[1] = createdAt.add(const Duration(hours: 2));
        timestamps[2] = createdAt.add(const Duration(hours: 6));
        timestamps[3] = createdAt.add(const Duration(days: 1));
        break;
      case StatusLevel.successful:
        timestamps[0] = createdAt;
        timestamps[1] = createdAt.add(const Duration(hours: 2));
        timestamps[2] = createdAt.add(const Duration(hours: 6));
        timestamps[3] = createdAt.add(const Duration(days: 1));
        timestamps[4] = createdAt.add(const Duration(days: 7));
        break;
      case StatusLevel.failed:
        timestamps[0] = createdAt;
        timestamps[1] = createdAt.add(const Duration(hours: 2));
        timestamps[5] = createdAt.add(const Duration(days: 3));
        break;
    }

    return timestamps;
  }

  /// Überblick der Mockdaten:
  /// - Letzter Monat (60-31 Tage her): 50 Recommendations
  /// - Dieser Monat (30-1 Tage her): 30 Recommendations
  ///
  /// Mix aus verschiedenen StatusLevels:
  /// - recommendationSend, linkClicked, contactFormSent
  /// - appointment, successful, failed
  ///
  /// Erwartete Trends:
  /// - Woche: ~7 (diese) vs ~7 (letzte) = ~0% → stabil
  /// - Monat: 30 (dieser) vs 50 (letzter) = -40% → fallend
  /// - Jahr: 80 (dieses) vs 0 (letztes) = +100% → steigend

  static List<PromoterRecommendations> getMockPromoterRecommendations() {
    final mockRecommendations = getMockRecommendations();

    // Erstelle Mock Promoter als CustomUser
    final mockPromoters = List.generate(
        5,
        (index) => CustomUser(
              id: UniqueID.fromUniqueString('mock-promoter-$index'),
              firstName: 'Promoter ${index + 1}',
              lastName: 'Schmidt',
              email: 'promoter${index + 1}@example.com',
              role: Role.promoter,
              createdAt: DateTime.now().subtract(Duration(days: 30 + index)),
            ));

    // Verteile Recommendations auf Promoter
    final promoterRecommendations = <PromoterRecommendations>[];

    for (int i = 0; i < mockPromoters.length; i++) {
      final startIndex =
          (i * mockRecommendations.length / mockPromoters.length).floor();
      final endIndex =
          ((i + 1) * mockRecommendations.length / mockPromoters.length).floor();

      final promoterRecs = mockRecommendations.sublist(startIndex, endIndex);

      promoterRecommendations.add(PromoterRecommendations(
        promoter: mockPromoters[i],
        recommendations: promoterRecs,
      ));
    }

    return promoterRecommendations;
  }
}
