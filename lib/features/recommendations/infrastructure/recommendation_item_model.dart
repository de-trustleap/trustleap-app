// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/recommendations/domain/campaign_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/recommendation_status_counts_model.dart';

class RecommendationItemModel extends Equatable {
  final String id;
  final String? name;
  final String? landingPageID;
  final String? promoterName;
  final String? serviceProviderName;
  final String? reason;
  final String? defaultLandingPageID;
  final String? statusLevel;
  final Map<int, DateTime?>? statusTimestamps;
  final String? userID;
  final String? promoterImageDownloadURL;
  final String? recommendationType;
  final Map<String, int>? statusCounts;
  final String? campaignName;
  final int? campaignDurationDays;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? lastUpdated;

  const RecommendationItemModel(
      {required this.id,
      required this.name,
      required this.landingPageID,
      required this.promoterName,
      required this.serviceProviderName,
      required this.reason,
      required this.defaultLandingPageID,
      required this.statusLevel,
      required this.statusTimestamps,
      required this.userID,
      required this.promoterImageDownloadURL,
      required this.recommendationType,
      required this.statusCounts,
      required this.campaignName,
      required this.campaignDurationDays,
      required this.expiresAt,
      required this.createdAt,
      required this.lastUpdated});

  RecommendationItemModel copyWith(
      {String? id,
      String? name,
      String? landingPageID,
      String? promoterName,
      String? serviceProviderName,
      String? reason,
      String? defaultLandingPageID,
      String? statusLevel,
      Map<int, DateTime?>? statusTimestamps,
      String? userID,
      String? promoterImageDownloadURL,
      String? recommendationType,
      Map<String, int>? statusCounts,
      String? campaignName,
      int? campaignDurationDays,
      DateTime? expiresAt,
      DateTime? createdAt,
      DateTime? lastUpdated}) {
    return RecommendationItemModel(
        id: id ?? this.id,
        name: name ?? this.name,
        landingPageID: landingPageID ?? this.landingPageID,
        promoterName: promoterName ?? this.promoterName,
        serviceProviderName: serviceProviderName ?? this.serviceProviderName,
        reason: reason ?? this.reason,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        statusLevel: statusLevel ?? this.statusLevel,
        statusTimestamps: statusTimestamps ?? this.statusTimestamps,
        userID: userID ?? this.userID,
        promoterImageDownloadURL:
            promoterImageDownloadURL ?? this.promoterImageDownloadURL,
        recommendationType: recommendationType ?? this.recommendationType,
        statusCounts: statusCounts ?? this.statusCounts,
        campaignName: campaignName ?? this.campaignName,
        campaignDurationDays: campaignDurationDays ?? this.campaignDurationDays,
        expiresAt: expiresAt ?? this.expiresAt,
        createdAt: createdAt ?? this.createdAt,
        lastUpdated: lastUpdated ?? this.lastUpdated);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'landingPageID': landingPageID,
      'promoterName': promoterName,
      'serviceProviderName': serviceProviderName,
      'reason': reason,
      'defaultLandingPageID': defaultLandingPageID,
      'statusLevel': statusLevel,
      'statusTimestamps': statusTimestamps == null
          ? null
          : Map.fromEntries(
              statusTimestamps!.entries.where((e) => e.value != null).map((e) =>
                  MapEntry(e.key.toString(), e.value!.toIso8601String())),
            ),
      'userID': userID,
      'promoterImageDownloadURL': promoterImageDownloadURL,
      'recommendationType': recommendationType,
      'statusCounts': statusCounts,
      'campaignName': campaignName,
      'campaignDurationDays': campaignDurationDays,
      'expiresAt': expiresAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory RecommendationItemModel.fromMap(Map<String, dynamic> map) {
    return RecommendationItemModel(
        id: "",
        name: map['name'] != null ? map['name'] as String : null,
        landingPageID: map['landingPageID'] != null
            ? map['landingPageID'] as String
            : null,
        promoterName:
            map['promoterName'] != null ? map['promoterName'] as String : null,
        serviceProviderName: map['serviceProviderName'] != null
            ? map['serviceProviderName'] as String
            : null,
        reason: map['reason'] != null ? map['reason'] as String : null,
        defaultLandingPageID: map['defaultLandingPageID'] != null
            ? map['defaultLandingPageID'] as String
            : null,
        statusLevel:
            map['statusLevel'] != null ? map['statusLevel'] as String : null,
        statusTimestamps: map['statusTimestamps'] != null
            ? (map['statusTimestamps'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(int.parse(key), DateTime.parse(value)))
            : null,
        userID: map['userID'] != null ? map['userID'] as String : null,
        promoterImageDownloadURL: map['promoterImageDownloadURL'] != null
            ? map['promoterImageDownloadURL'] as String
            : null,
        recommendationType: map['recommendationType'] != null
            ? map['recommendationType'] as String
            : null,
        statusCounts: map['statusCounts'] != null
            ? Map<String, int>.from(map['statusCounts'] as Map)
            : null,
        campaignName: map['campaignName'] != null
            ? map['campaignName'] as String
            : null,
        campaignDurationDays: map['campaignDurationDays'] != null
            ? map['campaignDurationDays'] as int
            : null,
        expiresAt: (map['expiresAt'] as Timestamp).toDate(),
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        lastUpdated: map['lastUpdated'] != null
            ? (map['lastUpdated'] as Timestamp).toDate()
            : null);
  }

  factory RecommendationItemModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return RecommendationItemModel.fromMap(doc).copyWith(id: id);
  }

  RecommendationItem toDomain() {
    final type = _getRecommendationTypeFromString(recommendationType);
    if (type == RecommendationType.campaign) {
      return CampaignRecommendationItem(
          id: id,
          campaignName: campaignName,
          campaignDurationDays: campaignDurationDays,
          reason: reason,
          landingPageID: landingPageID,
          promotionTemplate: null,
          promoterName: promoterName,
          serviceProviderName: serviceProviderName,
          defaultLandingPageID: defaultLandingPageID,
          userID: userID,
          promoterImageDownloadURL: promoterImageDownloadURL,
          statusCounts: statusCounts != null
              ? RecommendationStatusCountsModel.fromMap(statusCounts!)
                  .toDomain()
              : null,
          expiresAt: expiresAt,
          createdAt: createdAt,
          lastUpdated: lastUpdated);
    }
    return PersonalizedRecommendationItem(
        id: id,
        name: name,
        reason: reason,
        promotionTemplate: null,
        landingPageID: landingPageID,
        promoterName: promoterName,
        serviceProviderName: serviceProviderName,
        defaultLandingPageID: defaultLandingPageID,
        statusLevel: _getStatusLevelFromString(statusLevel),
        statusTimestamps: statusTimestamps,
        userID: userID,
        promoterImageDownloadURL: promoterImageDownloadURL,
        expiresAt: expiresAt,
        createdAt: createdAt,
        lastUpdated: lastUpdated);
  }

  factory RecommendationItemModel.fromDomain(
      RecommendationItem recommendation) {
    if (recommendation is CampaignRecommendationItem) {
      return RecommendationItemModel(
          id: recommendation.id,
          name: null,
          landingPageID: recommendation.landingPageID,
          promoterName: recommendation.promoterName,
          serviceProviderName: recommendation.serviceProviderName,
          reason: recommendation.reason,
          defaultLandingPageID: recommendation.defaultLandingPageID,
          statusLevel: null,
          statusTimestamps: null,
          userID: recommendation.userID,
          promoterImageDownloadURL: recommendation.promoterImageDownloadURL,
          recommendationType: recommendation.recommendationType?.name,
          statusCounts: recommendation.statusCounts != null
              ? RecommendationStatusCountsModel.fromDomain(
                      recommendation.statusCounts!)
                  .toMap()
              : null,
          campaignName: recommendation.campaignName,
          campaignDurationDays: recommendation.campaignDurationDays,
          expiresAt: recommendation.expiresAt,
          createdAt: recommendation.createdAt,
          lastUpdated: recommendation.lastUpdated);
    }
    final personalized = recommendation as PersonalizedRecommendationItem;
    return RecommendationItemModel(
        id: personalized.id,
        name: personalized.name,
        landingPageID: personalized.landingPageID,
        promoterName: personalized.promoterName,
        serviceProviderName: personalized.serviceProviderName,
        reason: personalized.reason,
        defaultLandingPageID: personalized.defaultLandingPageID,
        statusLevel: personalized.statusLevel?.name,
        statusTimestamps: personalized.statusTimestamps,
        userID: personalized.userID,
        promoterImageDownloadURL: personalized.promoterImageDownloadURL,
        recommendationType: personalized.recommendationType?.name,
        statusCounts: null,
        campaignName: null,
        campaignDurationDays: null,
        expiresAt: personalized.expiresAt,
        createdAt: personalized.createdAt,
        lastUpdated: personalized.lastUpdated);
  }

  RecommendationType? _getRecommendationTypeFromString(String? type) {
    if (type == null) return null;
    switch (type) {
      case "personalized":
        return RecommendationType.personalized;
      case "general":
      case "campaign":
        return RecommendationType.campaign;
      default:
        return null;
    }
  }

  StatusLevel? _getStatusLevelFromString(String? statusLevel) {
    if (statusLevel == null) {
      return null;
    }
    switch (statusLevel) {
      case "recommendationSend":
        return StatusLevel.recommendationSend;
      case "linkClicked":
        return StatusLevel.linkClicked;
      case "contactFormSent":
        return StatusLevel.contactFormSent;
      case "appointment":
        return StatusLevel.appointment;
      case "successful":
        return StatusLevel.successful;
      case "failed":
        return StatusLevel.failed;
      default:
        return null;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        landingPageID,
        promoterName,
        serviceProviderName,
        reason,
        defaultLandingPageID,
        statusLevel,
        statusTimestamps,
        userID,
        promoterImageDownloadURL,
        recommendationType,
        statusCounts,
        campaignName,
        campaignDurationDays,
        expiresAt,
        createdAt,
        lastUpdated,
      ];
}
