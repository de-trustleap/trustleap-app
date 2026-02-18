// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum StatusLevel {
  recommendationSend,
  linkClicked,
  contactFormSent,
  appointment,
  successful,
  failed,
}

enum RecommendationType { personalized, campaign }

abstract class RecommendationItem extends Equatable {
  final String id;
  final String? reason;
  final String? landingPageID;
  final String? promotionTemplate;
  final String? promoterName;
  final String? serviceProviderName;
  final String? defaultLandingPageID;
  final String? userID;
  final String? promoterImageDownloadURL;
  final RecommendationType? recommendationType;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  String? get displayName;

  RecommendationItem(
      {required this.id,
      required this.reason,
      required this.landingPageID,
      required this.promotionTemplate,
      required this.promoterName,
      required this.serviceProviderName,
      required this.defaultLandingPageID,
      required this.userID,
      required this.promoterImageDownloadURL,
      this.recommendationType,
      this.lastUpdated,
      DateTime? expiresAt,
      DateTime? createdAt})
      : expiresAt = expiresAt ?? DateTime.now().add(const Duration(days: 14)),
        createdAt = createdAt ?? DateTime.now();
}
