// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/infrastructure/models/recommendation_item_model.dart';

class UserRecommendationModel extends Equatable {
  final String id;
  final String? recoID;
  final String? userID;
  final int? priority;
  final bool? isFavorite;
  final Map<String, dynamic>? recommendation;

  const UserRecommendationModel(
      {required this.id,
      required this.recoID,
      required this.userID,
      required this.priority,
      required this.isFavorite,
      required this.recommendation});

  UserRecommendationModel copyWith(
      {String? id,
      String? recoID,
      String? userID,
      int? priority,
      bool? isFavorite,
      Map<String, dynamic>? recommendation}) {
    return UserRecommendationModel(
        id: id ?? this.id,
        recoID: recoID ?? this.recoID,
        userID: userID ?? this.userID,
        priority: priority ?? this.priority,
        isFavorite: isFavorite ?? this.isFavorite,
        recommendation: recommendation ?? this.recommendation);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'recoID': recoID,
      'userID': userID,
      'priority': priority,
      'isFavorite': isFavorite
    };
  }

  factory UserRecommendationModel.fromMap(Map<String, dynamic> map) {
    return UserRecommendationModel(
        id: "",
        recoID: map['recommendationID'] != null
            ? map['recommendationID'] as String
            : null,
        userID: map['userID'] != null ? map['userID'] as String : null,
        priority: map['priority'] != null ? map['priority'] as int : null,
        isFavorite:
            map['isFavorite'] != null ? map['isFavorite'] as bool : null,
        recommendation: map['recommendation'] != null
            ? map['recommendation'] as Map<String, dynamic>
            : null);
  }

  factory UserRecommendationModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return UserRecommendationModel.fromMap(doc).copyWith(id: id);
  }

  UserRecommendation toDomain() {
    return UserRecommendation(
        id: UniqueID.fromUniqueString(id),
        recoID: recoID,
        userID: userID,
        priority: priority,
        isFavorite: isFavorite,
        recommendation: recommendation != null
            ? RecommendationItemModel.fromMap(recommendation!).toDomain()
            : null);
  }

  factory UserRecommendationModel.fromDomain(
      UserRecommendation recommendation) {
    return UserRecommendationModel(
        id: recommendation.id.value,
        recoID: recommendation.recoID,
        userID: recommendation.userID,
        priority: recommendation.priority,
        isFavorite: recommendation.isFavorite,
        recommendation: recommendation.recommendation != null
            ? RecommendationItemModel.fromDomain(recommendation.recommendation!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props =>
      [id, recoID, userID, priority, isFavorite, recommendation];
}
