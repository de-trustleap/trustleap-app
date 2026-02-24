import 'package:finanzbegleiter/features/recommendations/domain/recommendation_status_counts.dart';

class RecommendationStatusCountsModel {
  final int linkClicked;
  final int contactFormSent;
  final int appointment;
  final int successful;
  final int failed;

  const RecommendationStatusCountsModel({
    this.linkClicked = 0,
    this.contactFormSent = 0,
    this.appointment = 0,
    this.successful = 0,
    this.failed = 0,
  });

  Map<String, int> toMap() {
    return <String, int>{
      'linkClicked': linkClicked,
      'contactFormSent': contactFormSent,
      'appointment': appointment,
      'successful': successful,
      'failed': failed,
    };
  }

  factory RecommendationStatusCountsModel.fromMap(Map<String, dynamic> map) {
    return RecommendationStatusCountsModel(
      linkClicked: map['linkClicked'] as int? ?? 0,
      contactFormSent: map['contactFormSent'] as int? ?? 0,
      appointment: map['appointment'] as int? ?? 0,
      successful: map['successful'] as int? ?? 0,
      failed: map['failed'] as int? ?? 0,
    );
  }

  RecommendationStatusCounts toDomain() {
    return RecommendationStatusCounts(
      linkClicked: linkClicked,
      contactFormSent: contactFormSent,
      appointment: appointment,
      successful: successful,
      failed: failed,
    );
  }

  factory RecommendationStatusCountsModel.fromDomain(
      RecommendationStatusCounts counts) {
    return RecommendationStatusCountsModel(
      linkClicked: counts.linkClicked,
      contactFormSent: counts.contactFormSent,
      appointment: counts.appointment,
      successful: counts.successful,
      failed: counts.failed,
    );
  }
}
