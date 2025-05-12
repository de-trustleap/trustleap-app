import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';

class UserRecommendation extends Equatable {
  final UniqueID id;
  final String? recoID;
  final String? userID;
  final int? priority;
  final bool? isFavorite;
  final RecommendationItem? recommendation;

  const UserRecommendation(
      {required this.id,
      required this.recoID,
      required this.userID,
      required this.priority,
      required this.isFavorite,
      required this.recommendation});

  UserRecommendation copyWith(
      {UniqueID? id,
      String? recoID,
      String? userID,
      int? priority,
      bool? isFavorite,
      RecommendationItem? recommendation}) {
    return UserRecommendation(
        id: id ?? this.id,
        recoID: recoID ?? this.recoID,
        userID: userID ?? this.userID,
        priority: priority ?? this.priority,
        isFavorite: isFavorite ?? this.isFavorite,
        recommendation: recommendation ?? this.recommendation);
  }

  @override
  List<Object?> get props =>
      [id, recoID, userID, priority, isFavorite, recommendation];
}
