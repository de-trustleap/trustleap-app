// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_status_counts.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/recommendation_status_counts_model.dart';
import 'package:finanzbegleiter/core/id.dart';

class ArchivedRecommendationItemModel extends Equatable {
  final String id;
  final String? reason;
  final String? landingPageID;
  final String? promoterName;
  final String? serviceProviderName;
  final bool? success;
  final String? userID;
  final DateTime? createdAt;
  final DateTime finishedTimeStamp;
  final String? recommendationType;
  final String? campaignName;
  final int? campaignDurationDays;
  final RecommendationStatusCounts? statusCounts;

  const ArchivedRecommendationItemModel({
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

  ArchivedRecommendationItemModel copyWith({
    String? id,
    String? reason,
    String? landingPageID,
    String? promoterName,
    String? serviceProviderName,
    bool? success,
    String? userID,
    DateTime? createdAt,
    DateTime? finishedTimeStamp,
    String? recommendationType,
    String? campaignName,
    int? campaignDurationDays,
    RecommendationStatusCounts? statusCounts,
  }) {
    return ArchivedRecommendationItemModel(
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'reason': reason,
      'landingPageID': landingPageID,
      'promoterName': promoterName,
      'serviceProviderName': serviceProviderName,
      'success': success,
      'userID': userID,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'finishedTimeStamp': Timestamp.fromDate(finishedTimeStamp),
      'recommendationType': recommendationType,
      'campaignName': campaignName,
      'campaignDurationDays': campaignDurationDays,
      'statusCounts': statusCounts != null
          ? RecommendationStatusCountsModel.fromDomain(statusCounts!).toMap()
          : null,
    };
  }

  factory ArchivedRecommendationItemModel.fromMap(Map<String, dynamic> map) {
    return ArchivedRecommendationItemModel(
        id: "",
        reason: map['reason'] != null ? map['reason'] as String : null,
        landingPageID: map['landingPageID'] != null
            ? map['landingPageID'] as String
            : null,
        promoterName:
            map['promoterName'] != null ? map['promoterName'] as String : null,
        serviceProviderName: map['serviceProviderName'] != null
            ? map['serviceProviderName'] as String
            : null,
        success: map['success'] != null ? map['success'] as bool : null,
        userID: map['userID'] != null ? map['userID'] as String : null,
        createdAt: map['createdAt'] != null
            ? (map['createdAt'] as Timestamp).toDate()
            : null,
        finishedTimeStamp: (map['finishedTimeStamp'] as Timestamp).toDate(),
        recommendationType: map['recommendationType'] != null
            ? map['recommendationType'] as String
            : null,
        campaignName: map['campaignName'] != null
            ? map['campaignName'] as String
            : null,
        campaignDurationDays: map['campaignDurationDays'] != null
            ? map['campaignDurationDays'] as int
            : null,
        statusCounts: map['statusCounts'] != null
            ? RecommendationStatusCountsModel.fromMap(
                    map['statusCounts'] as Map<String, dynamic>)
                .toDomain()
            : null);
  }

  factory ArchivedRecommendationItemModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return ArchivedRecommendationItemModel.fromMap(doc).copyWith(id: id);
  }

  ArchivedRecommendationItem toDomain() {
    return ArchivedRecommendationItem(
        id: UniqueID.fromUniqueString(id),
        reason: reason,
        landingPageID: landingPageID,
        promoterName: promoterName,
        serviceProviderName: serviceProviderName,
        success: success,
        userID: userID,
        createdAt: createdAt,
        finishedTimeStamp: finishedTimeStamp,
        recommendationType: _getRecommendationTypeFromString(recommendationType),
        campaignName: campaignName,
        campaignDurationDays: campaignDurationDays,
        statusCounts: statusCounts);
  }

  factory ArchivedRecommendationItemModel.fromDomain(
      ArchivedRecommendationItem recommendation) {
    return ArchivedRecommendationItemModel(
        id: recommendation.id.value,
        reason: recommendation.reason,
        landingPageID: recommendation.landingPageID,
        promoterName: recommendation.promoterName,
        serviceProviderName: recommendation.serviceProviderName,
        success: recommendation.success,
        userID: recommendation.userID,
        createdAt: recommendation.createdAt,
        finishedTimeStamp: recommendation.finishedTimeStamp,
        recommendationType: recommendation.recommendationType.name,
        campaignName: recommendation.campaignName,
        campaignDurationDays: recommendation.campaignDurationDays,
        statusCounts: recommendation.statusCounts);
  }

  RecommendationType _getRecommendationTypeFromString(String? type) {
    switch (type) {
      case "personalized":
        return RecommendationType.personalized;
      case "general":
      case "campaign":
        return RecommendationType.campaign;
      default:
        return RecommendationType.personalized;
    }
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
