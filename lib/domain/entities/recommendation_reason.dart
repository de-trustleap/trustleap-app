// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class RecommendationReason extends Equatable {
  final UniqueID? id;
  final String? reason;
  final String? promotionTemplate;
  final bool? isActive;

  const RecommendationReason({
    required this.id,
    required this.reason,
    required this.promotionTemplate,
    required this.isActive,
  });

  @override
  List<Object?> get props => [];
} 
