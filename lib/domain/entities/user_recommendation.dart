import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/last_edit.dart';
import 'package:finanzbegleiter/domain/entities/last_viewed.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

enum RecommendationPriority {
  low,
  medium,
  high;

  String getLocalizedLabel(AppLocalizations localizations) {
    switch (this) {
      case RecommendationPriority.low:
        return localizations.recommendation_priority_low;
      case RecommendationPriority.medium:
        return localizations.recommendation_priority_medium;
      case RecommendationPriority.high:
        return localizations.recommendation_priority_high;
    }
  }
}

class UserRecommendation extends Equatable {
  final UniqueID id;
  final String? recoID;
  final String? userID;
  final RecommendationPriority? priority;
  final String? notes;
  final RecommendationItem? recommendation;
  final List<LastEdit> lastEdits;
  final List<LastViewed> viewedByUsers;

  const UserRecommendation(
      {required this.id,
      required this.recoID,
      required this.userID,
      required this.priority,
      required this.notes,
      required this.recommendation,
      this.lastEdits = const [],
      this.viewedByUsers = const []});

  UserRecommendation copyWith(
      {UniqueID? id,
      String? recoID,
      String? userID,
      RecommendationPriority? priority,
      String? notes,
      RecommendationItem? recommendation,
      List<LastEdit>? lastEdits,
      List<LastViewed>? viewedByUsers}) {
    return UserRecommendation(
        id: id ?? this.id,
        recoID: recoID ?? this.recoID,
        userID: userID ?? this.userID,
        priority: priority ?? this.priority,
        notes: notes ?? this.notes,
        recommendation: recommendation ?? this.recommendation,
        lastEdits: lastEdits ?? this.lastEdits,
        viewedByUsers: viewedByUsers ?? this.viewedByUsers);
  }

  // Hilfsmethoden
  LastEdit? getLastEdit(String fieldName) {
    return lastEdits.where((edit) => edit.fieldName == fieldName).firstOrNull;
  }
  
  bool wasFieldEditedByOther(String fieldName, String currentUserId) {
    final edit = getLastEdit(fieldName);
    return edit != null && edit.editedBy != currentUserId;
  }
  
  bool hasUnseenChangesByUser(String userID) {
    final lastViewed = viewedByUsers.where((view) => view.userID == userID).firstOrNull;
    if (lastViewed == null) return lastEdits.isNotEmpty;
    
    return lastEdits.any((edit) => edit.editedAt.isAfter(lastViewed.viewedAt));
  }

  @override
  List<Object?> get props =>
      [id, recoID, userID, priority, notes, recommendation, lastEdits, viewedByUsers];
}
