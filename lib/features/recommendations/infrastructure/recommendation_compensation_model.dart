// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';

class RecommendationCompensationModel extends Equatable {
  final String status;
  final String? tremendousOrderID;
  final String? tremendousRewardID;
  final String? tremendousProductID;
  final double? amount;
  final String? currency;
  final String? error;
  final Map<String, String> timestamps;

  const RecommendationCompensationModel({
    required this.status,
    required this.timestamps,
    this.tremendousOrderID,
    this.tremendousRewardID,
    this.tremendousProductID,
    this.amount,
    this.currency,
    this.error,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "status": status,
      "tremendousOrderID": tremendousOrderID,
      "tremendousRewardID": tremendousRewardID,
      "tremendousProductID": tremendousProductID,
      "amount": amount,
      "currency": currency,
      "error": error,
      "timestamps": timestamps,
    };
  }

  factory RecommendationCompensationModel.fromMap(Map<String, dynamic> map) {
    return RecommendationCompensationModel(
      status: map["status"] as String,
      tremendousOrderID: map["tremendousOrderID"] as String?,
      tremendousRewardID: map["tremendousRewardID"] as String?,
      tremendousProductID: map["tremendousProductID"] as String?,
      amount: (map["amount"] as num?)?.toDouble(),
      currency: map["currency"] as String?,
      error: map["error"] as String?,
      timestamps: map["timestamps"] != null
          ? Map<String, String>.from(map["timestamps"] as Map)
          : {},
    );
  }

  RecommendationCompensation toDomain() {
    return RecommendationCompensation(
      status: RecommendationCompensationStatus.fromString(status) ??
          RecommendationCompensationStatus.pending,
      tremendousOrderID: tremendousOrderID,
      tremendousRewardID: tremendousRewardID,
      tremendousProductID: tremendousProductID,
      amount: amount,
      currency: currency,
      error: error,
      timestamps: timestamps.map((key, value) => MapEntry(
            RecommendationCompensationStatus.fromString(key) ??
                RecommendationCompensationStatus.pending,
            DateTime.parse(value),
          )),
    );
  }

  factory RecommendationCompensationModel.fromDomain(
      RecommendationCompensation compensation) {
    return RecommendationCompensationModel(
      status: compensation.status.name,
      tremendousOrderID: compensation.tremendousOrderID,
      tremendousRewardID: compensation.tremendousRewardID,
      tremendousProductID: compensation.tremendousProductID,
      amount: compensation.amount,
      currency: compensation.currency,
      error: compensation.error,
      timestamps: compensation.timestamps.map(
        (key, value) => MapEntry(key.name, value.toIso8601String()),
      ),
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
