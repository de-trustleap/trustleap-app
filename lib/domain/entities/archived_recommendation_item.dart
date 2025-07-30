// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class ArchivedRecommendationItem extends Equatable {
  final UniqueID id;
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

  const ArchivedRecommendationItem({
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

  ArchivedRecommendationItem copyWith({
    UniqueID? id,
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
    return ArchivedRecommendationItem(
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

  @override
  List<Object?> get props =>
      [id, name, reason, landingPageID, promoterName, serviceProviderName, success, userID];
}
