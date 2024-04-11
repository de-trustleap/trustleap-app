// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class Recommendation {
  final UniqueID id;
  final String? name;
  final String? serviceProvider;
  final String? promoter;
  final RecommendationReason? reason;

  Recommendation({
    required this.id,
    this.name,
    this.serviceProvider,
    this.promoter,
    this.reason,
  });

  Recommendation copyWith({
    UniqueID? id,
    String? name,
    String? serviceProvider,
    String? promoter,
    RecommendationReason? reason,
  }) {
    return Recommendation(
      id: id ?? this.id,
      name: name ?? this.name,
      serviceProvider: serviceProvider ?? this.serviceProvider,
      promoter: promoter ?? this.promoter,
      reason: reason ?? this.reason,
    );
  }
}
