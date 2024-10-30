// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class RecommendationReason extends Equatable {
  final String? reason;
  final bool? isActive;

  const RecommendationReason({
    required this.reason,
    required this.isActive,
  });

  @override
  List<Object?> get props => [];
} 
