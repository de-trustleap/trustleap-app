// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_status_counts.dart';

class ArchivedRecommendationItem extends Equatable {
  final UniqueID id;
  final String? reason;
  final String? landingPageID;
  final String? promoterName;
  final String? serviceProviderName;
  final bool? success;
  final String? userID;
  final DateTime? createdAt;
  final DateTime finishedTimeStamp;
  final RecommendationType recommendationType;
  final String? campaignName;
  final int? campaignDurationDays;
  final RecommendationStatusCounts? statusCounts;

  const ArchivedRecommendationItem({
    required this.id,
    required this.reason,
    required this.landingPageID,
    required this.promoterName,
    required this.serviceProviderName,
    required this.success,
    required this.userID,
    required this.createdAt,
    required this.finishedTimeStamp,
    required this.recommendationType,
    required this.campaignName,
    required this.campaignDurationDays,
    required this.statusCounts,
  });

  ArchivedRecommendationItem copyWith({
    UniqueID? id,
    String? reason,
    String? landingPageID,
    String? promoterName,
    String? serviceProviderName,
    bool? success,
    String? userID,
    DateTime? createdAt,
    DateTime? finishedTimeStamp,
    RecommendationType? recommendationType,
    String? campaignName,
    int? campaignDurationDays,
    RecommendationStatusCounts? statusCounts,
  }) {
    return ArchivedRecommendationItem(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      landingPageID: landingPageID ?? this.landingPageID,
      promoterName: promoterName ?? this.promoterName,
      serviceProviderName: serviceProviderName ?? this.serviceProviderName,
      success: success ?? this.success,
      userID: userID ?? this.userID,
      createdAt: createdAt ?? this.createdAt,
      finishedTimeStamp: finishedTimeStamp ?? this.finishedTimeStamp,
      recommendationType: recommendationType ?? this.recommendationType,
      campaignName: campaignName ?? this.campaignName,
      campaignDurationDays: campaignDurationDays ?? this.campaignDurationDays,
      statusCounts: statusCounts ?? this.statusCounts,
    );
  }

  @override
  List<Object?> get props => [
        id,
        reason,
        landingPageID,
        promoterName,
        serviceProviderName,
        success,
        userID,
        recommendationType,
        campaignName,
        campaignDurationDays,
        statusCounts,
      ];
}
