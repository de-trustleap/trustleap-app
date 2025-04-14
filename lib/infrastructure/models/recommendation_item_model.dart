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
  final String? defaultLandingPageID;
  final DateTime createdAt;
  final DateTime expiresAt;

  const RecommendationItemModel(
      {required this.id,
      required this.name,
      required this.landingPageID,
      required this.promoterName,
      required this.serviceProviderName,
      required this.defaultLandingPageID,
      required this.expiresAt,
      required this.createdAt});

  RecommendationItemModel copyWith(
      {String? id,
      String? name,
      String? landingPageID,
      String? promoterName,
      String? serviceProviderName,
      String? defaultLandingPageID,
      DateTime? expiresAt,
      DateTime? createdAt}) {
    return RecommendationItemModel(
        id: id ?? this.id,
        name: name ?? this.name,
        landingPageID: landingPageID ?? this.landingPageID,
        promoterName: promoterName ?? this.promoterName,
        serviceProviderName: serviceProviderName ?? this.serviceProviderName,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        expiresAt: expiresAt ?? this.expiresAt,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'landingPageID': landingPageID,
      'promoterName': promoterName,
      'serviceProviderName': serviceProviderName,
      'defaultLandingPageID': defaultLandingPageID,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'createdAt': Timestamp.fromDate(createdAt)
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
        defaultLandingPageID: map['defaultLandingPageID'] != null
            ? map['defaultLandingPageID'] as String
            : null,
        expiresAt: (map['expiresAt'] as Timestamp).toDate(),
        createdAt: (map['createdAt'] as Timestamp).toDate());
  }

  factory RecommendationItemModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return RecommendationItemModel.fromMap(doc).copyWith(id: id);
  }

  RecommendationItem toDomain() {
    return RecommendationItem(
        id: id,
        name: name,
        reason: null,
        promotionTemplate: null,
        landingPageID: landingPageID,
        promoterName: promoterName,
        serviceProviderName: serviceProviderName,
        defaultLandingPageID: defaultLandingPageID,
        expiresAt: expiresAt);
  }

  factory RecommendationItemModel.fromDomain(
      RecommendationItem recommendation) {
    return RecommendationItemModel(
        id: recommendation.id,
        name: recommendation.name,
        landingPageID: recommendation.landingPageID,
        promoterName: recommendation.promoterName,
        serviceProviderName: recommendation.serviceProviderName,
        defaultLandingPageID: recommendation.defaultLandingPageID,
        expiresAt: recommendation.expiresAt,
        createdAt: recommendation.createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        landingPageID,
        promoterName,
        serviceProviderName,
        expiresAt,
        defaultLandingPageID
      ];
}
