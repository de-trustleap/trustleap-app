// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class ArchivedRecommendationItemModel extends Equatable {
  final String id;
  final String? name;
  final String? reason;
  final String? landingPageID;
  final String? promoterName;
  final String? serviceProviderName;
  final bool? success;
  final String? userID;
  final DateTime? createdAt;
  final DateTime finishedTimeStamp;
  final DateTime? expiresAt;

  const ArchivedRecommendationItemModel({
    required this.id,
    required this.name,
    required this.reason,
    required this.landingPageID,
    required this.promoterName,
    required this.serviceProviderName,
    required this.success,
    required this.userID,
    required this.createdAt,
    required this.finishedTimeStamp,
    required this.expiresAt,
  });

  ArchivedRecommendationItemModel copyWith({
    String? id,
    String? name,
    String? reason,
    String? landingPageID,
    String? promoterName,
    String? serviceProviderName,
    bool? success,
    String? userID,
    DateTime? createdAt,
    DateTime? finishedTimeStamp,
    DateTime? expiresAt,
  }) {
    return ArchivedRecommendationItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      reason: reason ?? this.reason,
      landingPageID: landingPageID ?? this.landingPageID,
      promoterName: promoterName ?? this.promoterName,
      serviceProviderName: serviceProviderName ?? this.serviceProviderName,
      success: success ?? this.success,
      userID: userID ?? this.userID,
      createdAt: createdAt ?? this.createdAt,
      finishedTimeStamp: finishedTimeStamp ?? this.finishedTimeStamp,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'reason': reason,
      'landingPageID': landingPageID,
      'promoterName': promoterName,
      'serviceProviderName': serviceProviderName,
      'success': success,
      'userID': userID,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'finishedTimeStamp': Timestamp.fromDate(finishedTimeStamp)
    };
  }

  factory ArchivedRecommendationItemModel.fromMap(Map<String, dynamic> map) {
    return ArchivedRecommendationItemModel(
        id: "",
        name: map['name'] != null ? map['name'] as String : null,
        reason: map['reason'] != null ? map['reason'] as String : null,
        landingPageID: map['landingPageID'] != null ? map['landingPageID'] as String : null,
        promoterName:
            map['promoterName'] != null ? map['promoterName'] as String : null,
        serviceProviderName: map['serviceProviderName'] != null
            ? map['serviceProviderName'] as String
            : null,
        success: map['success'] != null ? map['success'] as bool : null,
        userID: map['userID'] != null ? map['userID'] as String : null,
        expiresAt: (map['expiresAt'] as Timestamp).toDate(),
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        finishedTimeStamp: (map['finishedTimeStamp'] as Timestamp).toDate());
  }

  factory ArchivedRecommendationItemModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return ArchivedRecommendationItemModel.fromMap(doc).copyWith(id: id);
  }

  ArchivedRecommendationItem toDomain() {
    return ArchivedRecommendationItem(
        id: UniqueID.fromUniqueString(id),
        name: name,
        reason: reason,
        landingPageID: landingPageID,
        promoterName: promoterName,
        serviceProviderName: serviceProviderName,
        success: success,
        userID: userID,
        createdAt: createdAt,
        finishedTimeStamp: finishedTimeStamp,
        expiresAt: expiresAt);
  }

  factory ArchivedRecommendationItemModel.fromDomain(
      ArchivedRecommendationItem recommendation) {
    return ArchivedRecommendationItemModel(
        id: recommendation.id.value,
        name: recommendation.name,
        reason: recommendation.reason,
        landingPageID: recommendation.landingPageID,
        promoterName: recommendation.promoterName,
        serviceProviderName: recommendation.serviceProviderName,
        success: recommendation.success,
        userID: recommendation.userID,
        createdAt: recommendation.createdAt,
        finishedTimeStamp: recommendation.finishedTimeStamp,
        expiresAt: recommendation.expiresAt);
  }

  @override
  List<Object?> get props =>
      [id, name, reason, landingPageID, promoterName, serviceProviderName, success, userID];
}
