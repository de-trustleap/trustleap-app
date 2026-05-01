// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum RecommendationCompensationStatus {
  pending,
  skipped,
  voucherSent,
  voucherDelivered,
  voucherFailed,
  manualIssued,
  manualConfirmed;

  static RecommendationCompensationStatus? fromString(String? value) {
    switch (value) {
      case "pending":
        return RecommendationCompensationStatus.pending;
      case "skipped":
        return RecommendationCompensationStatus.skipped;
      case "voucherSent":
        return RecommendationCompensationStatus.voucherSent;
      case "voucherDelivered":
        return RecommendationCompensationStatus.voucherDelivered;
      case "voucherFailed":
        return RecommendationCompensationStatus.voucherFailed;
      case "manualIssued":
        return RecommendationCompensationStatus.manualIssued;
      case "manualConfirmed":
        return RecommendationCompensationStatus.manualConfirmed;
      default:
        return null;
    }
  }
}

class RecommendationCompensation extends Equatable {
  final RecommendationCompensationStatus status;
  final String? tremendousOrderID;
  final String? tremendousRewardID;
  final String? tremendousProductID;
  final double? amount;
  final String? currency;
  final String? error;
  final Map<RecommendationCompensationStatus, DateTime> timestamps;

  const RecommendationCompensation({
    required this.status,
    required this.timestamps,
    this.tremendousOrderID,
    this.tremendousRewardID,
    this.tremendousProductID,
    this.amount,
    this.currency,
    this.error,
  });

  RecommendationCompensation copyWith({
    RecommendationCompensationStatus? status,
    String? tremendousOrderID,
    String? tremendousRewardID,
    String? tremendousProductID,
    double? amount,
    String? currency,
    String? error,
    Map<RecommendationCompensationStatus, DateTime>? timestamps,
  }) {
    return RecommendationCompensation(
      status: status ?? this.status,
      tremendousOrderID: tremendousOrderID ?? this.tremendousOrderID,
      tremendousRewardID: tremendousRewardID ?? this.tremendousRewardID,
      tremendousProductID: tremendousProductID ?? this.tremendousProductID,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      error: error ?? this.error,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tremendousOrderID,
        tremendousRewardID,
        tremendousProductID,
        amount,
        currency,
        error,
        timestamps,
      ];
}
