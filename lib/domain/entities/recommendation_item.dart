// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class RecommendationItem extends Equatable {
  final String id;
  final String? name;
  final String? reason;
  final String? landingPageID;
  final String? promotionTemplate;
  final String? promoterName;
  final String? serviceProviderName;
  final String? defaultLandingPageID;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  RecommendationItem(
      {required this.id,
      required this.name,
      required this.reason,
      required this.landingPageID,
      required this.promotionTemplate,
      required this.promoterName,
      required this.serviceProviderName,
      required this.defaultLandingPageID,
      this.lastUpdated,
      DateTime? expiresAt,
      DateTime? createdAt})
      : expiresAt = expiresAt ?? DateTime.now().add(const Duration(days: 14)),
        createdAt = createdAt ?? DateTime.now();

  RecommendationItem copyWith(
      {String? id,
      String? name,
      String? reason,
      String? landingPageID,
      String? promotionTemplate,
      String? promoterName,
      String? serviceProviderName,
      String? defaultLandingPageID,
      DateTime? lastUpdated}) {
    return RecommendationItem(
        id: id ?? this.id,
        name: name ?? this.name,
        reason: reason ?? this.reason,
        landingPageID: landingPageID ?? this.landingPageID,
        promotionTemplate: promotionTemplate ?? this.promotionTemplate,
        promoterName: promoterName ?? this.promoterName,
        serviceProviderName: serviceProviderName ?? this.serviceProviderName,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        expiresAt: expiresAt,
        createdAt: createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        reason,
        landingPageID,
        promotionTemplate,
        promoterName,
        serviceProviderName,
        defaultLandingPageID
      ];
}
