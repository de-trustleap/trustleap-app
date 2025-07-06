// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';

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
    return RecommendationItem(
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
    return RecommendationItemModel(
        id: recommendation.id,
        name: recommendation.name,
        landingPageID: recommendation.landingPageID,
        promoterName: recommendation.promoterName,
        serviceProviderName: recommendation.serviceProviderName,
        reason: recommendation.reason,
        defaultLandingPageID: recommendation.defaultLandingPageID,
        statusLevel: recommendation.statusLevel?.name,
        statusTimestamps: recommendation.statusTimestamps,
        userID: recommendation.userID,
        promoterImageDownloadURL: recommendation.promoterImageDownloadURL,
        expiresAt: recommendation.expiresAt,
        createdAt: recommendation.createdAt,
        lastUpdated: recommendation.lastUpdated);
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
        expiresAt,
        defaultLandingPageID,
        userID,
        promoterImageDownloadURL
      ];
}
