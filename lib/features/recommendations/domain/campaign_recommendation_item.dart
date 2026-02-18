// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_status_counts.dart';

class CampaignRecommendationItem extends RecommendationItem {
  final String? campaignName;
  final int? campaignDurationDays;
  final RecommendationStatusCounts? statusCounts;

  @override
  String? get displayName => campaignName;

  CampaignRecommendationItem(
      {required super.id,
      required this.campaignName,
      required this.campaignDurationDays,
      required super.reason,
      required super.landingPageID,
      required super.promotionTemplate,
      required super.promoterName,
      required super.serviceProviderName,
      required super.defaultLandingPageID,
      required super.userID,
      required super.promoterImageDownloadURL,
      this.statusCounts,
      super.lastUpdated,
      super.expiresAt,
      super.createdAt})
      : super(recommendationType: RecommendationType.campaign);

  CampaignRecommendationItem copyWith(
      {String? id,
      String? campaignName,
      int? campaignDurationDays,
      String? reason,
      String? landingPageID,
      String? promotionTemplate,
      String? promoterName,
      String? serviceProviderName,
      String? defaultLandingPageID,
      String? userID,
      String? promoterImageDownloadURL,
      RecommendationStatusCounts? statusCounts,
      DateTime? lastUpdated}) {
    return CampaignRecommendationItem(
        id: id ?? this.id,
        campaignName: campaignName ?? this.campaignName,
        campaignDurationDays: campaignDurationDays ?? this.campaignDurationDays,
        reason: reason ?? this.reason,
        landingPageID: landingPageID ?? this.landingPageID,
        promotionTemplate: promotionTemplate ?? this.promotionTemplate,
        promoterName: promoterName ?? this.promoterName,
        serviceProviderName: serviceProviderName ?? this.serviceProviderName,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        userID: userID ?? this.userID,
        promoterImageDownloadURL:
            promoterImageDownloadURL ?? this.promoterImageDownloadURL,
        statusCounts: statusCounts ?? this.statusCounts,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        expiresAt: expiresAt,
        createdAt: createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        campaignName,
        campaignDurationDays,
        reason,
        landingPageID,
        promotionTemplate,
        promoterName,
        serviceProviderName,
        defaultLandingPageID,
        userID,
        promoterImageDownloadURL,
        recommendationType,
        statusCounts,
      ];
}
