// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';

class PersonalizedRecommendationItem extends RecommendationItem {
  final String? name;
  final StatusLevel? statusLevel;
  final Map<int, DateTime?>? statusTimestamps;

  @override
  String? get displayName => name;

  PersonalizedRecommendationItem(
      {required super.id,
      required this.name,
      required super.reason,
      required super.landingPageID,
      required super.promotionTemplate,
      required super.promoterName,
      required super.serviceProviderName,
      required super.defaultLandingPageID,
      required this.statusLevel,
      required this.statusTimestamps,
      required super.userID,
      required super.promoterImageDownloadURL,
      super.lastUpdated,
      super.expiresAt,
      super.createdAt})
      : super(recommendationType: RecommendationType.personalized);

  PersonalizedRecommendationItem copyWith(
      {String? id,
      String? name,
      String? reason,
      String? landingPageID,
      String? promotionTemplate,
      String? promoterName,
      String? serviceProviderName,
      String? defaultLandingPageID,
      StatusLevel? statusLevel,
      Map<int, DateTime?>? statusTimestamps,
      String? userID,
      String? promoterImageDownloadURL,
      DateTime? lastUpdated}) {
    return PersonalizedRecommendationItem(
        id: id ?? this.id,
        name: name ?? this.name,
        reason: reason ?? this.reason,
        landingPageID: landingPageID ?? this.landingPageID,
        promotionTemplate: promotionTemplate ?? this.promotionTemplate,
        promoterName: promoterName ?? this.promoterName,
        serviceProviderName: serviceProviderName ?? this.serviceProviderName,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        statusLevel: statusLevel ?? this.statusLevel,
        statusTimestamps: statusTimestamps ?? this.statusTimestamps,
        userID: userID ?? this.userID,
        promoterImageDownloadURL:
            promoterImageDownloadURL ?? this.promoterImageDownloadURL,
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
        defaultLandingPageID,
        statusLevel,
        statusTimestamps,
        userID,
        promoterImageDownloadURL,
        recommendationType,
      ];
}
