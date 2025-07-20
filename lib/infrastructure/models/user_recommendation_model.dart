// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/infrastructure/models/last_edit_model.dart';
import 'package:finanzbegleiter/infrastructure/models/last_viewed_model.dart';
import 'package:finanzbegleiter/infrastructure/models/recommendation_item_model.dart';

class UserRecommendationModel extends Equatable {
  final String id;
  final String? recoID;
  final String? userID;
  final String? priority;
  final String? notes;
  final Map<String, dynamic>? recommendation;
  final List<Map<String, dynamic>> lastEdits;
  final List<Map<String, dynamic>> viewedByUsers;

  const UserRecommendationModel(
      {required this.id,
      required this.recoID,
      required this.userID,
      required this.priority,
      required this.notes,
      required this.recommendation,
      this.lastEdits = const [],
      this.viewedByUsers = const []});

  UserRecommendationModel copyWith(
      {String? id,
      String? recoID,
      String? userID,
      String? priority,
      String? notes,
      Map<String, dynamic>? recommendation,
      List<Map<String, dynamic>>? lastEdits,
      List<Map<String, dynamic>>? viewedByUsers}) {
    return UserRecommendationModel(
        id: id ?? this.id,
        recoID: recoID ?? this.recoID,
        userID: userID ?? this.userID,
        priority: priority ?? this.priority,
        notes: notes ?? this.notes,
        recommendation: recommendation ?? this.recommendation,
        lastEdits: lastEdits ?? this.lastEdits,
        viewedByUsers: viewedByUsers ?? this.viewedByUsers);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'recoID': recoID,
      'userID': userID,
      'priority': priority,
      'notes': notes,
      'lastEdits': lastEdits,
      'viewedByUsers': viewedByUsers
    };
  }

  factory UserRecommendationModel.fromMap(Map<String, dynamic> map) {
    return UserRecommendationModel(
        id: "",
        recoID: map['recommendationID'] != null
            ? map['recommendationID'] as String
            : null,
        userID: map['userID'] != null ? map['userID'] as String : null,
        priority: map['priority'] != null ? map['priority'] as String : null,
        notes: map['notes'] != null ? map['notes'] as String : null,
        recommendation: map['recommendation'] != null
            ? map['recommendation'] as Map<String, dynamic>
            : null,
        lastEdits: map['lastEdits'] != null
            ? List<Map<String, dynamic>>.from(map['lastEdits'])
            : [],
        viewedByUsers: map['viewedByUsers'] != null
            ? List<Map<String, dynamic>>.from(map['viewedByUsers'])
            : []);
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
        priority: _getPriorityFromString(priority),
        notes: notes,
        recommendation: recommendation != null
            ? RecommendationItemModel.fromMap(recommendation!).toDomain()
            : null,
        lastEdits: lastEdits
            .map((editMap) => LastEditModel.fromMap(editMap).toDomain())
            .toList(),
        viewedByUsers: viewedByUsers
            .map((viewMap) => LastViewedModel.fromMap(viewMap).toDomain())
            .toList());
  }

  factory UserRecommendationModel.fromDomain(
      UserRecommendation recommendation) {
    return UserRecommendationModel(
        id: recommendation.id.value,
        recoID: recommendation.recoID,
        userID: recommendation.userID,
        priority: recommendation.priority?.name,
        notes: recommendation.notes,
        recommendation: recommendation.recommendation != null
            ? RecommendationItemModel.fromDomain(recommendation.recommendation!)
                .toMap()
            : null,
        lastEdits: recommendation.lastEdits
            .map((edit) => LastEditModel.fromDomain(edit).toMap())
            .toList(),
        viewedByUsers: recommendation.viewedByUsers
            .map((view) => LastViewedModel.fromDomain(view).toMap())
            .toList());
  }

  RecommendationPriority? _getPriorityFromString(String? priority) {
    if (priority == null) {
      return null;
    }
    switch (priority) {
      case "low":
        return RecommendationPriority.low;
      case "medium":
        return RecommendationPriority.medium;
      case "high":
        return RecommendationPriority.high;
      default:
        return RecommendationPriority.medium;
    }
  }

  @override
  List<Object?> get props =>
      [id, recoID, userID, priority, notes, recommendation, lastEdits, viewedByUsers];
}
