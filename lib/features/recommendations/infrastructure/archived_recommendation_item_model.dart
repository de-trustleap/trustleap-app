// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
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
      'finishedTimeStamp': Timestamp.fromDate(finishedTimeStamp)
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
        finishedTimeStamp: (map['finishedTimeStamp'] as Timestamp).toDate());
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
        finishedTimeStamp: finishedTimeStamp);
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
        finishedTimeStamp: recommendation.finishedTimeStamp);
  }

  @override
  List<Object?> get props => [
        id,
        reason,
        landingPageID,
        promoterName,
        serviceProviderName,
        success,
        userID
      ];
}
