import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';

class PromoterRecommendations extends Equatable {
  final CustomUser promoter;
  final List<UserRecommendation> recommendations;

  const PromoterRecommendations({
    required this.promoter,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [promoter, recommendations];

  PromoterRecommendations copyWith({
    CustomUser? promoter,
    List<UserRecommendation>? recommendations,
  }) {
    return PromoterRecommendations(
      promoter: promoter ?? this.promoter,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}